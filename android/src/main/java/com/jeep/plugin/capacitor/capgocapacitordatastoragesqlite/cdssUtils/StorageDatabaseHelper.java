package com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils;

import android.content.Context;
import android.util.Log;
import androidx.sqlite.db.SimpleSQLiteQuery;
import androidx.sqlite.db.SupportSQLiteDatabase;
import androidx.sqlite.db.SupportSQLiteStatement;
import com.getcapacitor.JSObject;
import com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.ImportExportJson.JsonStore;
import com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.ImportExportJson.JsonTable;
import com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.ImportExportJson.JsonValue;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import net.sqlcipher.Cursor;
import net.sqlcipher.database.SQLiteDatabase;

public class StorageDatabaseHelper {

  public Boolean isOpen = false;
  private static final String TAG = "StorageDatabaseHelper";
  private Context _context;
  private String _tableName;
  private String _dbName;
  private Boolean _encrypted;
  private String _mode;
  private String _secret;
  private String _newsecret;
  private int _dbVersion;
  private File _file;
  private Global _globVar;
  private UtilsSQLCipher _uCipher;
  private SupportSQLiteDatabase _db = null;

  // Storage Table Columns
  private static final String COL_ID = "id";
  private static final String COL_NAME = "name";
  private static final String COL_VALUE = "value";
  private static final String IDX_COL_NAME = "name";

  public StorageDatabaseHelper(
    Context context,
    String dbName,
    String tableName,
    Boolean encrypted,
    String mode,
    int vNumber
  ) {
    this._context = context;
    this._dbName = dbName;
    this._tableName = tableName;
    this._dbVersion = vNumber;
    this._encrypted = encrypted;
    this._mode = mode;
    this._file = context.getDatabasePath(dbName);
    this._globVar = new Global();
    this._uCipher = new UtilsSQLCipher();

    this.InitializeSQLCipher();
    if (!this._file.getParentFile().exists()) {
      this._file.getParentFile().mkdirs();
    }
    Log.v(TAG, "&&& file path " + this._file.getAbsolutePath());
  }

  /**
   * InitializeSQLCipher Method
   * Initialize the SQLCipher Libraries
   */
  private void InitializeSQLCipher() {
    Log.d(TAG, " in InitializeSQLCipher: ");
    SQLiteDatabase.loadLibs(_context);
  }

  /**
   * GetStoreName
   * Return the current store name
   * @return
   */
  public String getStoreName() {
    return this._dbName;
  }

  /**
   * Open Method
   * Open the store
   */
  public void open() throws Exception {
    int curVersion;

    String password = _encrypted &&
      (_mode.equals("secret") || _mode.equals("encryption"))
      ? _globVar.secret
      : "";
    if (_mode.equals("newsecret")) {
      try {
        _uCipher.changePassword(
          _context,
          _file,
          _globVar.secret,
          _globVar.newsecret
        );
        password = _globVar.newsecret;
      } catch (Exception e) {
        String msg = "Failed in change password" + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      }
    }
    if (_mode.equals("encryption")) {
      try {
        _uCipher.encrypt(
          _context,
          _file,
          SQLiteDatabase.getBytes(password.toCharArray())
        );
      } catch (Exception e) {
        String msg = "Failed in encryption " + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      }
    }

    _db = SQLiteDatabase.openOrCreateDatabase(_file, password, null);
    if (_db != null) {
      if (_db.isOpen()) {
        try {
          setTable(_tableName, true);
          isOpen = true;
          return;
        } catch (Exception e) {
          isOpen = false;
          _db = null;
          throw new Exception("Store not opened " + e.getMessage());
        }
      } else {
        isOpen = false;
        _db = null;
        throw new Exception("Store not opened");
      }
    } else {
      isOpen = false;
      throw new Exception("No store returned");
    }
  }

  /**
   * Close Method
   * Close the store
   */
  public void close() throws Exception {
    if (_db.isOpen()) {
      try {
        _db.close();
        isOpen = false;
        return;
      } catch (Exception e) {
        String msg = "Failed in closing the store" + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  /**
   * SetTable Method
   * Set a table and associated index
   * @param name
   * @param ifNotExists
   * @throws Exception
   */
  public void setTable(String name, Boolean ifNotExists) throws Exception {
    String exist = ifNotExists ? "IF NOT EXISTS" : "";
    if (_db.isOpen()) {
      try {
        String CREATE_STORAGE_TABLE =
          "CREATE TABLE " +
          exist +
          " " +
          name +
          "(" +
          COL_ID +
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          COL_NAME +
          " TEXT," +
          COL_VALUE +
          " TEXT" +
          ");";
        _db.execSQL(CREATE_STORAGE_TABLE);
        String idx = "index_" + name + "_on_" + IDX_COL_NAME;
        String CREATE_INDEX_NAME =
          "CREATE INDEX " +
          exist +
          " " +
          idx +
          " ON " +
          name +
          " (" +
          IDX_COL_NAME +
          ");";
        _db.execSQL(CREATE_INDEX_NAME);
        if (!this._tableName.equals(name)) this._tableName = name;
        return;
      } catch (Exception e) {
        String msg = "Failed in creating table " + name + " " + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  /**
   * Get Method
   * Get a value from a given key
   * @param name
   * @return
   * @throws Exception
   */
  public Data get(String name) throws Exception {
    Cursor c = null;
    Data data = null;
    if (_db.isOpen()) {
      try {
        String DATA_SELECT_QUERY =
          "SELECT * FROM " +
          this._tableName +
          " WHERE " +
          COL_NAME +
          " = '" +
          name +
          "';";

        c = (Cursor) _db.query(DATA_SELECT_QUERY);
        if (c.getCount() > 0) {
          c.moveToFirst();
          data = new Data();
          data.id = c.getLong(c.getColumnIndex(COL_ID));
          data.name = c.getString(c.getColumnIndex(COL_NAME));
          data.value = c.getString(c.getColumnIndex(COL_VALUE));
        } else {
          data = new Data();
          data.id = null;
        }
        return data;
      } catch (Exception e) {
        String msg = "Failed in get" + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      } finally {
        if (c != null) c.close();
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  /**
   * Set Method
   * Set the value for a given key
   * @param data
   * @throws Exception
   */
  public void set(Data data) throws Exception {
    String name = data.name;
    String value = data.value;
    if (_db.isOpen()) {
      try {
        boolean ret = iskey(name);
        String statement = "";
        SupportSQLiteStatement stmt = null;

        if (ret) {
          // update
          statement = statement
            .concat("UPDATE ")
            .concat(this._tableName)
            .concat(" SET ");
          statement = statement.concat(COL_VALUE).concat(" = ? ");
          statement = statement
            .concat(" WHERE ")
            .concat(COL_NAME)
            .concat(" = ?;");
          stmt = _db.compileStatement(statement);
          Object[] valObj = new Object[2];
          valObj[0] = value;
          valObj[1] = name;
          SimpleSQLiteQuery.bind(stmt, valObj);
          stmt.executeUpdateDelete();
          /*                    stmt =
                        "UPDATE " + this._tableName + " SET " + COL_VALUE + " = '" + value + "' WHERE " + COL_NAME + " = '" + name + "';";
                        */
        } else {
          // insert

          statement = statement.concat("INSERT INTO ").concat(this._tableName);
          statement = statement.concat(" (").concat(COL_NAME).concat(",");
          statement = statement.concat(COL_VALUE).concat(") VALUES(?,?);");
          stmt = _db.compileStatement(statement);
          Object[] valObj = new Object[2];
          valObj[0] = name;
          valObj[1] = value;
          SimpleSQLiteQuery.bind(stmt, valObj);
          stmt.executeInsert();
          /*
                    stmt =
                        "INSERT INTO " + _tableName + " (" + COL_NAME + "," + COL_VALUE + ") " + "VALUES('" + name + "','" + value + "');";
                */
        }
        //                _db.execSQL(stmt);
      } catch (IllegalStateException e) {
        String msg = "Failed in set" + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      } catch (IllegalArgumentException e) {
        String msg = "Failed in set" + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      } catch (Exception e) {
        String msg = "Failed in set" + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  /**
   * Iskey
   * Check if a key is existing in the store
   * @param name
   * @return
   * @throws Exception
   */
  public boolean iskey(String name) throws Exception {
    boolean ret = false;
    if (_db.isOpen()) {
      try {
        Data data = get(name);
        if (data.id != null) ret = true;
        return ret;
      } catch (Exception e) {
        String msg = "Failed in iskey" + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  public void clear() throws Exception {
    if (_db.isOpen()) {
      try {
        _db.execSQL("DELETE FROM " + this._tableName);
        return;
      } catch (Exception e) {
        String msg = "Failed in clear" + e.getMessage();
        throw new Exception(msg);
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  public void remove(String name) throws Exception {
    if (_db.isOpen()) {
      try {
        _db.execSQL(
          "DELETE FROM " +
          this._tableName +
          " WHERE " +
          COL_NAME +
          " = '" +
          name +
          "';"
        );
        return;
      } catch (Exception e) {
        String msg = "Failed in remove" + e.getMessage();
        throw new Exception(msg);
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  public List<String> keys() throws Exception {
    Cursor c = null;
    List<String> data = new ArrayList<>();
    if (_db.isOpen()) {
      try {
        String DATA_SELECT_QUERY =
          "SELECT " +
          COL_NAME +
          " FROM " +
          this._tableName +
          " ORDER BY " +
          COL_NAME +
          ";";

        c = (Cursor) _db.query(DATA_SELECT_QUERY);
        if (c.getCount() > 0) {
          if (c.moveToFirst()) {
            do {
              String key = c.getString(c.getColumnIndex(COL_NAME));
              data.add(key);
            } while (c.moveToNext());
          }
        } else {
          data = Collections.emptyList();
        }
        return data;
      } catch (Exception e) {
        String msg = "Failed in keys" + e.getMessage();
        throw new Exception(msg);
      } finally {
        if (c != null) c.close();
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  public List<String> values() throws Exception {
    Cursor c = null;
    List<String> data = new ArrayList<>();
    if (_db.isOpen()) {
      try {
        String DATA_SELECT_QUERY =
          "SELECT " +
          COL_VALUE +
          " FROM " +
          this._tableName +
          " ORDER BY " +
          COL_NAME +
          ";";

        c = (Cursor) _db.query(DATA_SELECT_QUERY);
        if (c.getCount() > 0) {
          if (c.moveToFirst()) {
            do {
              String key = c.getString(c.getColumnIndex(COL_VALUE));
              data.add(key);
            } while (c.moveToNext());
          }
        } else {
          data = Collections.emptyList();
        }
        return data;
      } catch (Exception e) {
        String msg = "Failed in values" + e.getMessage();
        throw new Exception(msg);
      } finally {
        if (c != null) c.close();
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  public List<Data> keysvalues() throws Exception {
    Cursor c = null;
    List<Data> data = new ArrayList<>();
    if (_db.isOpen()) {
      try {
        String DATA_SELECT_QUERY =
          "SELECT * FROM " + this._tableName + " ORDER BY " + COL_NAME + ";";

        c = (Cursor) _db.query(DATA_SELECT_QUERY);
        if (c.getCount() > 0) {
          if (c.moveToFirst()) {
            do {
              Data newData = new Data();
              newData.name = c.getString(c.getColumnIndex(COL_NAME));
              newData.value = c.getString(c.getColumnIndex(COL_VALUE));
              data.add(newData);
            } while (c.moveToNext());
          }
        } else {
          data = Collections.emptyList();
        }
        return data;
      } catch (Exception e) {
        String msg = "Failed in keysvalues" + e.getMessage();
        throw new Exception(msg);
      } finally {
        if (c != null) c.close();
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  public List<String> filtervalues(String filter) throws Exception {
    String inFilter = filter;
    if (!inFilter.startsWith("%") && !inFilter.endsWith("%")) {
      inFilter = "%" + inFilter + "%";
    }
    Cursor c = null;
    List<String> data = new ArrayList<>();
    if (_db.isOpen()) {
      try {
        String DATA_SELECT_QUERY =
          "SELECT " +
          COL_VALUE +
          " FROM " +
          this._tableName +
          " WHERE " +
          COL_NAME +
          " LIKE '" +
          inFilter +
          "'" +
          " ORDER BY " +
          COL_NAME +
          ";";
        c = (Cursor) _db.query(DATA_SELECT_QUERY);
        if (c.getCount() > 0) {
          if (c.moveToFirst()) {
            do {
              String key = c.getString(c.getColumnIndex(COL_VALUE));
              data.add(key);
            } while (c.moveToNext());
          }
        } else {
          data = Collections.emptyList();
        }
        return data;
      } catch (Exception e) {
        String msg = "Failed in values" + e.getMessage();
        throw new Exception(msg);
      } finally {
        if (c != null) c.close();
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  public boolean isTable(String table) throws Exception {
    boolean ret = false;
    if (_db.isOpen()) {
      try {
        List<String> tables = getTables();
        if (tables.size() > 0 && tables.contains(table)) {
          ret = true;
        }
        return ret;
      } catch (Exception e) {
        String msg = "Failed in isTable" + e.getMessage();
        throw new Exception(msg);
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  public List<String> tables() throws Exception {
    try {
      List<String> tables = getTables();
      return tables;
    } catch (Exception e) {
      String msg = "Failed in tables" + e.getMessage();
      throw new Exception(msg);
    }
  }

  public void deleteTable(String table) throws Exception {
    if (_db.isOpen()) {
      try {
        List<String> tables = getTables();
        if (tables.size() > 0 && tables.contains(table)) {
          _db.execSQL("DROP TABLE IF EXISTS " + table + ";");
          return;
        } else {
          throw new Exception("table " + table + " does not exist");
        }
      } catch (Exception e) {
        String msg = "Failed in deleteTable" + e.getMessage();
        throw new Exception(msg);
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  private List<String> getTables() throws Exception {
    Cursor c = null;
    List<String> tables = new ArrayList<>();
    if (_db.isOpen()) {
      try {
        String DATA_SELECT_QUERY =
          "SELECT name FROM sqlite_master WHERE TYPE='table'" +
          " ORDER BY name " +
          ";";

        c = (Cursor) _db.query(DATA_SELECT_QUERY);
        if (c.getCount() > 0) {
          if (c.moveToFirst()) {
            do {
              String table = c.getString(c.getColumnIndex("name"));
              if (!table.equals("sqlite_sequence")) {
                tables.add(table);
              }
            } while (c.moveToNext());
          }
        } else {
          tables = Collections.emptyList();
        }
        return tables;
      } catch (Exception e) {
        String msg = "Failed in tables" + e.getMessage();
        Log.v(TAG, msg);
        throw new Exception(msg);
      } finally {
        if (c != null) c.close();
      }
    } else {
      throw new Exception("Store not opened");
    }
  }

  /**
   * Import from Json object
   * @param values
   * @return
   * @throws Exception
   */
  public Integer importFromJson(ArrayList<JsonValue> values) throws Exception {
    int changes = Integer.valueOf(0);
    try {
      for (JsonValue val : values) {
        Data data = new Data();
        data.name = val.getKey();
        data.value = val.getValue();
        set(data);
        changes += 1;
      }
      return changes;
    } catch (Exception e) {
      throw new Exception(e.getMessage());
    }
  }

  public JSObject exportToJson() {
    JsonStore retJson = new JsonStore();
    JSObject retObj = new JSObject();
    retJson.setDatabase(_dbName.substring(0, _dbName.length() - 9));
    retJson.setEncrypted(_encrypted);

    String previousName = _tableName;
    try {
      List<String> tables = tables();
      ArrayList<JsonTable> rTables = new ArrayList<JsonTable>();
      for (String table : tables) {
        JsonTable rTable = new JsonTable();
        _tableName = table;
        rTable.setName(table);
        List<Data> dataTable = keysvalues();
        ArrayList<JsonValue> values = new ArrayList<JsonValue>();
        for (Data data : dataTable) {
          JsonValue rData = new JsonValue();
          rData.setKey(data.name);
          rData.setValue(data.value);
          values.add(rData);
        }
        rTable.setValues(values);
        rTables.add(rTable);
      }
      retJson.setTables(rTables);
      _tableName = previousName;
      ArrayList<String> keys = retJson.getKeys();
      if (keys.contains("tables")) {
        if (retJson.getTables().size() > 0) {
          retObj.put("database", retJson.getDatabase());
          retObj.put("encrypted", retJson.getEncrypted());
          retObj.put("tables", retJson.getTablesAsJSObject());
        }
      }
    } catch (Exception e) {
      Log.e(TAG, "Error: exportToJson " + e.getMessage());
    } finally {
      return retObj;
    }
  }
}
