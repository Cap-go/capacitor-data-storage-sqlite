//
//  StorageDatabaseHelper.java
//  Plugin
//
//  Created by  Quéau Jean Pierre on 04/05/2018.
//  Copyright © 2018 Max Lynch. All rights reserved.
//
package com.jeep.plugin.capacitor;
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
    private static final String DATABASE_NAME = "storageSQLite.db";
    private static final int DATABASE_VERSION = 1;

    // Table Names
    private static final String TABLE_STORAGE = "storage_table";

    // Storage Table Columns
    private static final String COL_ID = "id";
    private static final String COL_NAME = "name";
    private static final String COL_VALUE = "value";

    public static synchronized StorageDatabaseHelper getInstance(Context context) {
        // Use the application context, which will ensure that you
        // don't accidentally leak an Activity's context.
        // See this article for more information: http://bit.ly/6LRzfx
        if (sInstance == null) {
            sInstance = new StorageDatabaseHelper(context.getApplicationContext());
        }
        return sInstance;
    }

    /**
     * Constructor should be private to prevent direct instantiation.
     * Make a call to the static method "getInstance()" instead.
     */
    private StorageDatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        String CREATE_STORAGE_TABLE = "CREATE TABLE IF NOT EXISTS " + TABLE_STORAGE +
                "(" +
                COL_ID + " INTEGER PRIMARY KEY AUTOINCREMENT," + // Define a primary key
                COL_NAME + " TEXT," +
                COL_VALUE + " TEXT" +
                ")";
        String CREATE_INDEX_NAME = "CREATE INDEX tag_name on " + TABLE_STORAGE +
                " (" + COL_NAME  + ")";
        db.execSQL(CREATE_STORAGE_TABLE);
        db.execSQL(CREATE_INDEX_NAME);
        Log.d(TAG, "onCreate: name: database created");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        if (oldVersion != newVersion) {
            db.execSQL("DROP TABLE IF EXISTS " + TABLE_STORAGE);
            onCreate(db);
        }
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
                db.insertOrThrow(TABLE_STORAGE, null, values);
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
            db.update(TABLE_STORAGE, values, COL_NAME + " = ?",
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
            db.delete(TABLE_STORAGE, COL_NAME + "= '" + name +"'",
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
            db.delete(TABLE_STORAGE, null, null);
            // set back the key primary index to 0
            db.update("SQLITE_SEQUENCE", values, "NAME = ?",
                    new String[] { String.valueOf(TABLE_STORAGE) });
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

        String DATA_SELECT_QUERY = "SELECT * FROM "+ TABLE_STORAGE +
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

        String DATA_SELECT_QUERY = "SELECT * FROM "+ TABLE_STORAGE;
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

        String DATA_SELECT_QUERY = "SELECT * FROM "+ TABLE_STORAGE;
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

        String DATA_SELECT_QUERY = "SELECT * FROM "+ TABLE_STORAGE;
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

}
