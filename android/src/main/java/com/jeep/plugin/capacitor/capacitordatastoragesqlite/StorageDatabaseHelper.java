//
//  StorageDatabaseHelper.java
//  Plugin
//
//  Created by  Quéau Jean Pierre on 04/05/2018.
//  Copyright © 2018 Max Lynch. All rights reserved.
//
package com.jeep.plugin.capacitor.capacitordatastoragesqlite;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


public class StorageDatabaseHelper extends SQLiteOpenHelper {
    private static final String TAG = "StorageDatabaseHelper";
    private static StorageDatabaseHelper sInstance;
    // Database Info
//    private static final String DATABASE_NAME = "storageSQLite.db";
//    private static final int DATABASE_VERSION = 1;

    // Table Names
//    private static final String TABLE_STORAGE = "storage_table";
    private String tableName;
    private final String dbName;
    private final int dbVersion;

    // Storage Table Columns
    private static final String COL_ID = "id";
    private static final String COL_NAME = "name";
    private static final String COL_VALUE = "value";
/*
    public static synchronized StorageDatabaseHelper getInstance(Context context, String _dbName, String _tableName, int _vNumber) {
        // Use the application context, which will ensure that you
        // don't accidentally leak an Activity's context.
        // See this article for more information: http://bit.ly/6LRzfx
        if (sInstance == null) {
            sInstance = new StorageDatabaseHelper(context.getApplicationContext(),_dbName,_tableName,_vNumber);
        }
        return sInstance;
    }
*/
    /**
     * Constructor should be private to prevent direct instantiation.
     * Make a call to the static method "getInstance()" instead.
     */
    //private StorageDatabaseHelper(Context context,String _dbName, String _tableName,int _vNumber) {
    StorageDatabaseHelper(Context context, String _dbName, String _tableName, int _vNumber) {
        super(context, _dbName, null, _vNumber);
        dbName = _dbName;
        tableName = _tableName;
        dbVersion = _vNumber;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        Log.d(TAG, "onCreate: "+ tableName);
        createTable(db,tableName);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        if (oldVersion != newVersion) {
            dropAllTables(db);
            onCreate(db);
        }
    }
    public boolean setTable(String _tableName) {
        SQLiteDatabase db = getWritableDatabase();
        boolean ret = createTable(db,_tableName);
        Log.d(TAG, "setTable: "+ tableName);
        return ret;

    }
    // Insert a data into the database
    public boolean set(Data data) {
        boolean ret = false;
        // Create and/or open the database for writing
        SQLiteDatabase db = getWritableDatabase();
        // Check if data.name does not exist otherwise update it
        Data res = this.get(data.name);
        if (res.id != null) {
            // exists so update it
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
                return ret;
            }
        }
    }

    // update data value into the database
    public boolean update(Data data) {
        boolean ret = false;
        SQLiteDatabase db = getWritableDatabase();
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
            return ret;
        }

    }

    // delete a data into the database
    public boolean remove(String name) {
        boolean ret = false;
        SQLiteDatabase db = getWritableDatabase();
        // wrap our delete in a transaction.
        db.beginTransaction();
        try {
            db.delete(tableName, COL_NAME + "= '" + name +"'",
                    null);
            db.setTransactionSuccessful();
            ret = true;
        } catch (Exception e) {
            Log.d(TAG, "remove: Error while trying to delete " + name);
        } finally {
            db.endTransaction();
            return ret;
        }
    }

    // delete a all data into the database
    public boolean clear() {
        boolean ret = false;
        SQLiteDatabase db = getWritableDatabase();
        // wrap our delete in a transaction.
        ContentValues values = new ContentValues();
        values.put("SEQ", 0);
        db.beginTransaction();
        try {
            db.delete(tableName, null, null);
            // set back the key primary index to 0
            db.update("SQLITE_SEQUENCE", values, "NAME = ?",
                    new String[] { String.valueOf(tableName) });
            db.setTransactionSuccessful();
            ret = true;
        } catch (Exception e) {
            Log.d(TAG, "Clear: Error while trying to delete all data");
        } finally {
            db.endTransaction();
            return ret;
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
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.rawQuery(DATA_SELECT_QUERY, null);
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
        return data;
    }

    // get All Keys
    public List<String> keys() {
        List<String> data = new ArrayList<>();

        String DATA_SELECT_QUERY = "SELECT * FROM "+ tableName;
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.rawQuery(DATA_SELECT_QUERY, null);
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
            data = Collections.EMPTY_LIST;
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
        return data;
    }

    // get All Values
    public List<String> values() {
        List<String> data = new ArrayList<>();

        String DATA_SELECT_QUERY = "SELECT * FROM "+ tableName;
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.rawQuery(DATA_SELECT_QUERY, null);
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
            data = Collections.EMPTY_LIST;
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
        return data;
    }

    // get All Data
    public List<Data> keysvalues() {
        List<Data> data = new ArrayList<>();

        String DATA_SELECT_QUERY = "SELECT * FROM "+ tableName;
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.rawQuery(DATA_SELECT_QUERY, null);
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
            data = Collections.EMPTY_LIST;
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
        return data;
    }
    private boolean dropAllTables(SQLiteDatabase db) {
        boolean ret = false;
        List<String> tables = new ArrayList<String>();
        Cursor cursor = db.rawQuery("SELECT * FROM sqlite_master WHERE type='table';", null);
        cursor.moveToFirst();
        while (!cursor.isAfterLast()) {
            String tableName = cursor.getString(1);
            if (!tableName.equals("android_metadata") &&
                    !tableName.equals("sqlite_sequence"))
                tables.add(tableName);
            cursor.moveToNext();
        }
        cursor.close();
        try {
            for(String tableName:tables) {
                db.execSQL("DROP TABLE IF EXISTS " + tableName);
            }
        } catch (Exception e) {
            Log.d(TAG, "Error: dropAllTables failed: ",e);
        } finally {
            ret = true;
        }
        return ret;
    }
    private boolean createTable(SQLiteDatabase db, String _tableName) {

        String CREATE_STORAGE_TABLE = "CREATE TABLE IF NOT EXISTS " + _tableName +
                "(" +
                COL_ID + " INTEGER PRIMARY KEY AUTOINCREMENT," + // Define a primary key
                COL_NAME + " TEXT," +
                COL_VALUE + " TEXT" +
                ")";
        String CREATE_INDEX_NAME = "CREATE INDEX IF NOT EXISTS idx_"+_tableName+"_name on " + _tableName +
                " (" + COL_NAME  + ")";
        Log.d(TAG, "onsetTable: "+ _tableName);
        db.beginTransaction();
        try {
            db.execSQL(CREATE_STORAGE_TABLE);
            db.execSQL(CREATE_INDEX_NAME);
            Log.d(TAG, "onCreate: name: database created");
            db.setTransactionSuccessful();
        } catch (Exception e) {
            Log.d(TAG, "set: Error while trying to add a table to database");
            return false;
        } finally {
            db.endTransaction();
            tableName = _tableName;
            return true;
        }
    }
}
