package com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils;

import android.content.Context;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import net.sqlcipher.database.SQLiteDatabase;
import net.sqlcipher.database.SQLiteException;
import net.sqlcipher.database.SQLiteStatement;

public class UtilsSQLCipher {

  private static final String TAG = UtilsSQLCipher.class.getName();

  /**
   * The detected state of the database, based on whether we can
   * open it without a passphrase, with the passphrase 'secret'.
   */
  public enum State {
    DOES_NOT_EXIST,
    UNENCRYPTED,
    ENCRYPTED_SECRET,
    ENCRYPTED_NEW_SECRET,
  }

  /**
   * Determine whether or not this database appears to be encrypted,
   * based on whether we can open it without a passphrase or with
   * the passphrase 'secret'.
   *
   * @param dbPath a File pointing to the database
   * @param globVar an instance of Global
   * @return the detected state of the database
   */
  public State getDatabaseState(File dbPath, Global globVar) {
    if (dbPath.exists()) {
      SQLiteDatabase db = null;

      try {
        db = SQLiteDatabase.openDatabase(
          dbPath.getAbsolutePath(),
          "",
          null,
          SQLiteDatabase.OPEN_READONLY
        );

        db.getVersion();

        return (State.UNENCRYPTED);
      } catch (Exception e) {
        try {
          db = SQLiteDatabase.openDatabase(
            dbPath.getAbsolutePath(),
            globVar.secret,
            null,
            SQLiteDatabase.OPEN_READONLY
          );
          return (State.ENCRYPTED_SECRET);
        } catch (Exception e1) {
          return (State.ENCRYPTED_NEW_SECRET);
        }
      } finally {
        if (db != null) {
          db.close();
        }
      }
    }

    return (State.DOES_NOT_EXIST);
  }

  /**
   * Replaces this database with a version encrypted with the supplied
   * passphrase, deleting the original.
   * Do not call this while the database is open.
   *
   * The passphrase is untouched in this call.
   *
   * @param ctxt a Context
   * @param originalFile a File pointing to the database
   * @param passphrase the passphrase from the user
   * @throws IOException
   */
  public void encrypt(Context ctxt, File originalFile, byte[] passphrase)
    throws IOException {
    SQLiteDatabase.loadLibs(ctxt);

    if (originalFile.exists()) {
      File newFile = File.createTempFile(
        "sqlcipherutils",
        "tmp",
        ctxt.getCacheDir()
      );
      SQLiteDatabase db = SQLiteDatabase.openDatabase(
        originalFile.getAbsolutePath(),
        "",
        null,
        SQLiteDatabase.OPEN_READWRITE
      );
      int version = db.getVersion();

      db.close();

      db = SQLiteDatabase.openDatabase(
        newFile.getAbsolutePath(),
        passphrase,
        null,
        SQLiteDatabase.OPEN_READWRITE,
        null,
        null
      );
      StringBuilder sql = new StringBuilder();
      sql.append("ATTACH DATABASE ? AS plaintext KEY ");
      sql.append("'';");
      final SQLiteStatement st = db.compileStatement(sql.toString());

      st.bindString(1, originalFile.getAbsolutePath());
      st.execute();

      db.rawExecSQL("SELECT sqlcipher_export('main', 'plaintext')");
      db.rawExecSQL("DETACH DATABASE plaintext");
      db.setVersion(version);
      st.close();
      db.close();

      originalFile.delete();
      newFile.renameTo(originalFile);
    } else {
      throw new FileNotFoundException(
        originalFile.getAbsolutePath() + " not found"
      );
    }
  }

  public void changePassword(
    Context ctxt,
    File file,
    String password,
    String nwpassword
  ) throws IOException {
    SQLiteDatabase.loadLibs(ctxt);

    if (file.exists()) {
      SQLiteDatabase db = SQLiteDatabase.openDatabase(
        file.getAbsolutePath(),
        password,
        null,
        SQLiteDatabase.OPEN_READWRITE
      );

      if (!db.isOpen()) {
        throw new SQLiteException(
          "database " + file.getAbsolutePath() + " open failed"
        );
      }
      db.changePassword(nwpassword);
      db.close();
    } else {
      throw new FileNotFoundException(file.getAbsolutePath() + " not found");
    }
  }
}
