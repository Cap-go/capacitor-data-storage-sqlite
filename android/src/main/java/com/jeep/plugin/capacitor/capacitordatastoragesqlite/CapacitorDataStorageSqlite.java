package com.jeep.plugin.capacitor.capacitordatastoragesqlite;

import android.content.Context;
import com.getcapacitor.JSObject;
import com.jeep.plugin.capacitor.capacitordatastoragesqlite.cdssUtils.Data;
import com.jeep.plugin.capacitor.capacitordatastoragesqlite.cdssUtils.StorageDatabaseHelper;
import java.io.File;
import java.util.List;

public class CapacitorDataStorageSqlite {

    private StorageDatabaseHelper mDb;
    private Context context;

    public CapacitorDataStorageSqlite(Context context) {
        this.context = context;
    }

    /**
     * Echo
     *
     * @param value
     * @return String
     */
    public String echo(String value) {
        return value;
    }

    public void openStore(String dbName, String tableName, Boolean encrypted, String inMode, int version) throws Exception {
        try {
            mDb = new StorageDatabaseHelper(context, dbName + "SQLite.db", tableName, encrypted, inMode, version);
            if (mDb != null) {
                mDb.open();
                if (mDb.isOpen) {
                    return;
                } else {
                    throw new Exception("mDb is not opened");
                }
            } else {
                throw new Exception("mDb is null");
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    public void closeStore(String dbName) throws Exception {
        String database = dbName + "SQLite.db";
        if (mDb != null && mDb.isOpen && mDb.getStoreName().equals(database)) {
            try {
                mDb.close();
                return;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb " + dbName + " is not opened or null");
        }
    }

    public boolean isStoreOpen(String dbName) throws Exception {
        String database = dbName + "SQLite.db";
        if (mDb != null && mDb.getStoreName().equals(database)) {
            return mDb.isOpen;
        } else {
            throw new Exception("mDb " + dbName + " is not the current one or null");
        }
    }

    public void set(String key, String value) throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                Data data = new Data();
                data.name = key;
                data.value = value;
                mDb.set(data);
                return;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public String get(String key) throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                Data data = mDb.get(key);
                if (data.id == null) {
                    return "";
                } else {
                    return data.value;
                }
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public void remove(String name) throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                mDb.remove(name);
                return;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public void clear() throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                mDb.clear();
                return;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public boolean iskey(String name) throws Exception {
        boolean ret = false;
        if (mDb != null && mDb.isOpen) {
            try {
                ret = mDb.iskey(name);
                return ret;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public String[] keys() throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                List<String> resKeys = mDb.keys();
                String[] keyArray = resKeys.toArray(new String[resKeys.size()]);
                return keyArray;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public String[] values() throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                List<String> resValues = mDb.values();
                String[] valueArray = resValues.toArray(new String[resValues.size()]);
                return valueArray;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public String[] filtervalues(String filter) throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                List<String> resValues = mDb.filtervalues(filter);
                String[] valueArray = resValues.toArray(new String[resValues.size()]);
                return valueArray;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public JSObject[] keysvalues() throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                List<Data> resKeysValues = mDb.keysvalues();
                JSObject[] jsObjArray = new JSObject[resKeysValues.size()];

                for (int i = 0; i < resKeysValues.size(); i++) {
                    JSObject res = new JSObject();
                    res.put("key", resKeysValues.get(i).name);
                    res.put("value", resKeysValues.get(i).value);
                    jsObjArray[i] = res;
                }
                return jsObjArray;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public void setTable(String table) throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                mDb.setTable(table, true);
                return;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public boolean isTable(String table) throws Exception {
        boolean ret = false;
        if (mDb != null && mDb.isOpen) {
            try {
                ret = mDb.isTable(table);
                return ret;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public String[] tables() throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                List<String> resTables = mDb.tables();
                String[] tableArray = resTables.toArray(new String[resTables.size()]);
                return tableArray;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public void deleteTable(String table) throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                mDb.deleteTable(table);
                return;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public void deleteStore(String dbName) throws Exception {
        try {
            context.deleteDatabase(dbName + "SQLite.db");
            context.deleteFile(dbName + "SQLite.db");
            File databaseFile = context.getDatabasePath(dbName + "SQLite.db");
            if (databaseFile.exists()) {
                throw new Exception("failed to delete the store");
            } else {
                return;
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    public boolean isStoreExists(String dbName) throws Exception {
        boolean ret = false;
        try {
            File databaseFile = context.getDatabasePath(dbName + "SQLite.db");
            if (databaseFile.exists()) ret = true;
            return ret;
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }
}
