//
//  StorageDatabaseHelper.java
//  Plugin
//
//  Created by  Quéau Jean Pierre on 12/23/2019.
//  Copyright © 2018 Max Lynch. All rights reserved.
//
package com.jeep.plugin.capacitor.cdssUtils;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import net.sqlcipher.database.SQLiteDatabase;
import net.sqlcipher.database.SQLiteOpenHelper;
//import android.database.sqlite.SQLiteDatabase;
//import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import com.jeep.plugin.capacitor.cdssUtils.Data;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;



public class StorageDatabaseHelper extends SQLiteOpenHelper {
    public Boolean isOpen = false;
    private static final String TAG = "StorageDatabaseHelper";
//    private static StorageDatabaseHelper sInstance;
    // Database Info
/*    private static final String DATABASE_NAME = "storageSQLite.db";
    private static final int DATABASE_VERSION = 1;

    // Table Names
    private static final String TABLE_STORAGE = "storage_table";
*/

    private String tableName;
    private String dbName;
    private Boolean encrypted;
    private String mode;
    private String secret;
    private final String newsecret;
    private final int dbVersion;

    // Storage Table Columns
    private static final String COL_ID = "id";
    private static final String COL_NAME = "name";
    private static final String COL_VALUE = "value";
    private static final String IDX_COL_NAME = "name";
/*
    public static synchronized StorageDatabaseHelper getInstance(Context context) {
        // Use the application context, which will ensure that you
        // don't accidentally leak an Activity's context.
        // See this article for more information: http://bit.ly/6LRzfx
        if (sInstance == null) {
            sInstance = new StorageDatabaseHelper(context.getApplicationContext());
        }
        return sInstance;
    }
*/
    /**
     * Constructor should be private to prevent direct instantiation.
     * Make a call to the static method "getInstance()" instead.
     */
    /*
    private StorageDatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    */

    public StorageDatabaseHelper(Context context, String _dbName, String _tableName,
                                 Boolean _encrypted, String _mode, String _secret,
                                 String _newsecret, int _vNumber) {
        super(context, _dbName, null, _vNumber);
        dbName = _dbName;
        tableName = _tableName;
        dbVersion = _vNumber;
        encrypted = _encrypted;
        secret = _secret;
        newsecret = _newsecret;
        mode = _mode;

        InitializeSQLCipher(context);


    }
    private void InitializeSQLCipher(Context context) {
        SQLiteDatabase.loadLibs(context);
        SQLiteDatabase database = null;
        File databaseFile;
        File tempFile;

        if(!encrypted && mode.equals("no-encryption")) {

            databaseFile = context.getDatabasePath(dbName);
            try {
                database = SQLiteDatabase.openOrCreateDatabase(databaseFile, "", null);
                isOpen = true;
            } catch (Exception e) {
                database = null;
            }
        } else if (encrypted && mode.equals("secret") && secret.length() > 0) {
            databaseFile = context.getDatabasePath(dbName);
            try {
                database = SQLiteDatabase.openOrCreateDatabase(databaseFile, secret, null);
                isOpen = true;
            } catch (Exception e) {
                Log.d(TAG, "InitializeSQLCipher: Wrong Secret " );
                database = null;
            }
        } else if(encrypted && mode.equals("newsecret") && secret.length() > 0
                && newsecret.length() > 0) {

            databaseFile = context.getDatabasePath(dbName);
            try {
                database = SQLiteDatabase.openOrCreateDatabase(databaseFile, secret, null);
                // Change database secret to newsecret
                database.changePassword(newsecret);
                secret = newsecret;
                isOpen = true;
            } catch (Exception e) {
                Log.d(TAG, "InitializeSQLCipher: " + e );
                database = null;
            }

        } else if (encrypted && mode.equals("encryption") && secret.length() > 0) {

            // Encrypt an existing non-encrypted database
            // get the db  and rename it
            File oriDBFile = context.getDatabasePath(dbName);
            if (oriDBFile.exists()) {
                tempFile = context.getDatabasePath("temp.db");
                oriDBFile.renameTo(tempFile);
            } else {
                tempFile = null;
            }

            databaseFile = context.getDatabasePath(dbName);
            database = SQLiteDatabase.openOrCreateDatabase(databaseFile, secret, null);

            if (tempFile.exists()) {
                SQLiteDatabase tempDB = SQLiteDatabase.openOrCreateDatabase(tempFile,
                        null, null);

                // create tables
                List<String> tables = getTables(tempDB);
                String currentTable = tableName;
                for (String table : tables) {
                    System.out.println(table);
                    tableName = table;
                    List<Data> rawData = getKeysValues(tempDB);

                    Boolean res = createTable(database,table,true);
                    if (res) {

                        database.beginTransaction();
                        try {
                            ContentValues values = new ContentValues();
                            for (Data row  : rawData) {
                                values.put(COL_NAME, row.name);
                                values.put(COL_VALUE, row.value);
                                database.insertOrThrow(table, null, values);
                            }
                            database.setTransactionSuccessful();
                        } catch (Exception e) {
                            Log.d(TAG, "InitializeSQLCipher: Error while trying to add data " +
                                    "in table " + table + "of the encryptedDB");
                        } finally {
                            database.endTransaction();
                            Boolean resIndex = createIndex(database,table,IDX_COL_NAME,true);
                            if (!resIndex) {
                                Log.d(TAG, "InitializeSQLCipher: Error while trying to index table "
                                        + table + "of the encryptedDB");
                            }
                        }
                    } else {
                        Log.d(TAG,"InitializeSQLCipher: create Table failed during encryption process");
                    }

                }
                tempDB.close();
                tempFile.delete();
                tableName = currentTable;
                encrypted = true;
                isOpen = true;
            }
        }
        if(database != null) database.close();
        if(isOpen) {
            boolean isTable = checkForTableExists(tableName);
            if(!isTable ) {
                isOpen = setTable(tableName);
            }
        }
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        Log.d(TAG, "******* onCreate: in ");
        Boolean res = createTable(db,tableName,true);
        if(res) {
            Log.d(TAG, "onCreate: table " + tableName + " created");
            Boolean resIndex = createIndex(db,tableName,IDX_COL_NAME,true);
            if (!resIndex) {
                Log.d(TAG, "onCreate: index table "
                        + tableName + " not created");
            } else {
                Log.d(TAG, "onCreate: index table "
                        + tableName + " created");
            }

        } else {
            Log.d(TAG, "onCreate: table " + tableName + " not created");
        }
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        if (oldVersion != newVersion) {
            db.execSQL("DROP TABLE IF EXISTS " + tableName);
            onCreate(db);
        }
    }

    public boolean setTable(String _tableName) {
        Boolean ret = false;
        SQLiteDatabase db = getWritableDatabase(secret);
        boolean res = createTable(db,_tableName,true);
        if (res) {
            tableName = _tableName;
            Boolean resIndex = createIndex(db,_tableName,IDX_COL_NAME,true);
            if (resIndex) {
                ret = true;
            }
        }
        db.close();
        return ret;
    }

    // Insert a data into the database
    public boolean set(Data data) {
        boolean ret = false;
        // Check if data.name does not exist otherwise update it

        Data res = this.get(data.name);
        // Create and/or open the database for writing
        SQLiteDatabase db = this.getWritableDatabase(secret);

        if (res.id != null) {
            // exists so update it
            db.close();
            return this.update(data);

        } else {
            // does not exist add it
            // wrap our insert in a transaction.
            db.beginTransaction();
            try {

                ContentValues values = new ContentValues();
                values.put(COL_NAME, data.name);
                values.put(COL_VALUE, data.value);

                // do not need to specify the primary key. SQLite auto increments the primary key column.
                db.insertOrThrow(tableName, null, values);
                db.setTransactionSuccessful();
                ret = true;
            } catch (Exception e) {
                Log.d(TAG, "set: Error while trying to add data to database");
            } finally {
                db.endTransaction();
                db.close();
                return ret;
            }
        }
    }

    // update data value into the database
    public boolean update(Data data) {
        boolean ret = false;
        SQLiteDatabase db = this.getWritableDatabase(secret);
        ContentValues values = new ContentValues();
        values.put(COL_VALUE, data.value);

        // wrap our update in a transaction.
        db.beginTransaction();
        try {
            db.update(tableName, values, COL_NAME + " = ?",
                    new String[] { String.valueOf(data.name) });
            db.setTransactionSuccessful();
            ret = true;
        } catch (Exception e) {
            Log.d(TAG, "update: Error while trying to update " + data.name);
        } finally {
            db.endTransaction();
            db.close();
            return ret;
        }

    }

    // delete a data into the database
    public boolean remove(String name) {
        boolean ret = false;
        SQLiteDatabase db = this.getWritableDatabase(secret);
        // wrap our delete in a transaction.
        db.beginTransaction();
        try {
            db.execSQL("DELETE FROM " + tableName + " WHERE " + COL_NAME + " = '" + name + "'");
            db.setTransactionSuccessful();
            ret = true;
        } catch (Exception e) {
            Log.d(TAG, "remove: Error while trying to delete " + name);
        } finally {
            db.endTransaction();
            db.close();
            return ret;
        }
    }

    // delete a all data into the database
    public boolean clear() {
        boolean ret = false;
        // check if the table exists
        boolean isTable = checkForTableExists(tableName);

        if( isTable ) {
             // wrap our delete in a transaction.
            SQLiteDatabase db = this.getWritableDatabase(secret);

            db.beginTransaction();
            try {
                Log.d(TAG, "Clear: Delete from DB");

                db.execSQL("DELETE FROM " + tableName);

                // set back the key primary index to 0
                Log.d(TAG, "Clear: Delete from sqlite_sequence");
                db.execSQL("DELETE FROM sqlite_sequence WHERE name = '" + tableName + "'");
                db.setTransactionSuccessful();
                ret = true;
            } catch (Exception e) {
                Log.d(TAG, "Clear: Error while trying to delete all data" + e);
            } finally {
                db.endTransaction();
                db.close();
                return ret;
            }
        } else {
            return true;
        }
    }

    // isKey exists
    public boolean iskey(String name) {
        boolean ret = false;
        Data data = get(name);
        if(data.id != null) ret =true;
        return ret;
    }

    // get a Data
    public Data get(String name) {
        Data data = null;

        String DATA_SELECT_QUERY = "SELECT * FROM "+ tableName +
                " WHERE " + COL_NAME + " = '" + name + "'";
        SQLiteDatabase db = this.getReadableDatabase(secret);
        Cursor cursor = null;
        cursor = db.rawQuery(DATA_SELECT_QUERY, null);
        if (cursor.getCount() > 0) {
            try {
                if (cursor.moveToFirst()) {
                    data = new Data();
                    data.id = cursor.getLong(cursor.getColumnIndex(COL_ID));
                    data.name = cursor.getString(cursor.getColumnIndex(COL_NAME));
                    data.value = cursor.getString(cursor.getColumnIndex(COL_VALUE));
                }
            } catch (Exception e) {
                Log.d(TAG, "get: Error while trying to get data from storage database");
            } finally {
                if (cursor != null && !cursor.isClosed()) {
                    cursor.close();
                }
            }
        } else {
            data = new Data();
            data.id = null;
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
        db.close();
        return data;
    }

    // get All Keys
    public List<String> keys() {
        List<String> data = new ArrayList<>();

        String DATA_SELECT_QUERY = "SELECT * FROM "+ tableName;
        SQLiteDatabase db = this.getReadableDatabase(secret);
        Cursor cursor = null;
        cursor = db.rawQuery(DATA_SELECT_QUERY, null);
        if (cursor.getCount() > 0) {
            try {
                if (cursor.moveToFirst()) {
                    do {

                        String key = cursor.getString(cursor.getColumnIndex(COL_NAME));
                        data.add(key);
                    } while(cursor.moveToNext());
                }
            } catch (Exception e) {
                Log.d(TAG, "keys: Error while trying to get all keys from storage database");
            } finally {
                if (cursor != null && !cursor.isClosed()) {
                    cursor.close();
                }
            }
        } else {
            data = Collections.emptyList();
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
        db.close();
        return data;
    }

    // get All Values
    public List<String> values() {
        List<String> data = new ArrayList<>();

        String DATA_SELECT_QUERY = "SELECT * FROM "+ tableName;
        SQLiteDatabase db = this.getReadableDatabase(secret);
        Cursor cursor = null;
        cursor = db.rawQuery(DATA_SELECT_QUERY, null);
        if (cursor.getCount() > 0) {
            try {
                if (cursor.moveToFirst()) {
                    do {

                        String value = cursor.getString(cursor.getColumnIndex(COL_VALUE));
                        data.add(value);
                    } while(cursor.moveToNext());
                }
            } catch (Exception e) {
                Log.d(TAG, "values: Error while trying to get all values from storage database");
            } finally {
                if (cursor != null && !cursor.isClosed()) {
                    cursor.close();
                }
            }
        } else {
            data = Collections.emptyList();
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
        db.close();
        return data;
    }


    // get All Data
    public List<Data> keysvalues() {
        List<Data> data = new ArrayList<>();

        SQLiteDatabase db = this.getReadableDatabase(secret);
        data = getKeysValues(db);
        db.close();
        return data;
    }
    private List<String> getTables(SQLiteDatabase db) {
        List<String> data = new ArrayList<>();

        String DATA_SELECT_QUERY = "SELECT * FROM sqlite_master WHERE TYPE ='table'";
        Cursor cursor = null;
        cursor = db.rawQuery(DATA_SELECT_QUERY, null);
        if (cursor.getCount() > 0) {
            try {
                if (cursor.moveToFirst()) {
                    do {

                        String key = cursor.getString(cursor.getColumnIndex("name"));

                        if(!"sqlite_sequence".equals(key)) {
                            data.add(key);
                        }
                    } while(cursor.moveToNext());
                }
            } catch (Exception e) {
                Log.d(TAG, "keys: Error while trying to get all keys from storage database");
            } finally {
                if (cursor != null && !cursor.isClosed()) {
                    cursor.close();
                }
            }
        } else {
            data = Collections.emptyList();
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
        return data;
    }
    private Boolean createTable (SQLiteDatabase db, String tableName, Boolean ifNotExists ) {
        boolean ret = false;
        String exist = ifNotExists ? "IF NOT EXISTS" : "";

        db.beginTransaction();
        try {
            String CREATE_STORAGE_TABLE = "CREATE TABLE " + exist + " " + tableName +
                    "(" +
                    COL_ID + " INTEGER PRIMARY KEY AUTOINCREMENT," + // Define a primary key
                    COL_NAME + " TEXT," +
                    COL_VALUE + " TEXT" +
                    ")";
            db.execSQL(CREATE_STORAGE_TABLE);
            db.setTransactionSuccessful();
            ret = true;
        } catch (Exception e) {
            Log.d(TAG, "createTable: Error while creating table: " + tableName );
        } finally {
            db.endTransaction();
            return ret;
        }
    }

    private Boolean createIndex(SQLiteDatabase db, String tableName, String colName, Boolean ifNotExists) {
        Boolean ret = false;
        String exist= ifNotExists ? "IF NOT EXISTS" : "";
        String idx  = "index_" + tableName + "_on_" + colName;
        String CREATE_INDEX_NAME = "CREATE INDEX " + exist + " " + idx +
                " ON " + tableName + " (" + colName + ");";
        db.beginTransaction();
        try {
            db.execSQL(CREATE_INDEX_NAME);
            db.setTransactionSuccessful();
            ret = true;
        } catch (Exception e) {
            Log.d(TAG, "createIndex: Error Index (idx) on table (tableName) could not be created." );
        } finally {
            db.endTransaction();
            return ret;
        }

    }

    private List<Data> getKeysValues(SQLiteDatabase db) {
        List<Data> data = new ArrayList<>();
        String DATA_SELECT_QUERY = "SELECT * FROM "+ tableName;
        Cursor cursor = null;
        cursor = db.rawQuery(DATA_SELECT_QUERY, null);
        if (cursor.getCount() > 0) {
            try {
                if (cursor.moveToFirst()) {
                    do {
                        Data newData = new Data();
                        newData.name = cursor.getString(cursor.getColumnIndex(COL_NAME));
                        newData.value = cursor.getString(cursor.getColumnIndex(COL_VALUE));
                        data.add(newData);
                    } while (cursor.moveToNext());
                }
            } catch (Exception e) {
                Log.d(TAG, "keysvalues: Error while trying to get all keys/values from storage database");
            } finally {
                if (cursor != null && !cursor.isClosed()) {
                    cursor.close();
                }
            }
        } else {
            data = Collections.emptyList();
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
        return data;
    }
    private boolean checkForTableExists(String table){
        Boolean ret =false;
        SQLiteDatabase db = this.getWritableDatabase(secret);
        String sql = "SELECT name FROM sqlite_master WHERE type='table' AND name='"+table+"'";
        Cursor mCursor = null;
        mCursor = db.rawQuery(sql, null);
        if (mCursor.getCount() > 0) {
            ret = true;
        }
        mCursor.close();
        return ret;
    }

}
