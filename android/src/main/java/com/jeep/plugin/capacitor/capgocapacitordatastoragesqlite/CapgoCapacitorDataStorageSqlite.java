package com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import com.getcapacitor.JSObject;
import com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.Data;
import com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.ImportExportJson.JsonStore;
import com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.ImportExportJson.JsonTable;
import com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.ImportExportJson.JsonValue;
import com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.StorageDatabaseHelper;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class CapgoCapacitorDataStorageSqlite {

    private static final String SQLITE_SUFFIX = "SQLite.db";
    private static final Handler MAIN_HANDLER = new Handler(Looper.getMainLooper());
    private static final List<DataStorageChangeListener> dataStorageChangeListeners = new ArrayList<>();

    public interface DataStorageChangeListener {
        void onDataStorageChange(DataStorageChange change);
    }

    public static class DataStorageChange {

        private final String database;
        private final String table;
        private final String key;
        private final String value;
        private final boolean deleted;

        public DataStorageChange(String database, String table, String key, String value, boolean deleted) {
            this.database = database;
            this.table = table;
            this.key = key;
            this.value = value;
            this.deleted = deleted;
        }

        public String getDatabase() {
            return database;
        }

        public String getTable() {
            return table;
        }

        public String getKey() {
            return key;
        }

        public String getValue() {
            return value;
        }

        public boolean isDeleted() {
            return deleted;
        }

        public JSObject toJSObject() {
            JSObject ret = new JSObject();
            ret.put("database", database);
            ret.put("table", table);
            ret.put("key", key);
            if (value != null) {
                ret.put("value", value);
            }
            if (deleted) {
                ret.put("deleted", true);
            }
            return ret;
        }
    }

    public static synchronized void addChangeListener(DataStorageChangeListener listener) {
        if (listener == null) {
            return;
        }
        removeChangeListener(listener);
        dataStorageChangeListeners.add(listener);
    }

    public static synchronized void removeChangeListener(DataStorageChangeListener listener) {
        dataStorageChangeListeners.removeIf((value) -> value == listener);
    }

    private static void notifyDataStorageChange(DataStorageChange change) {
        List<DataStorageChange> changes = new ArrayList<>();
        changes.add(change);
        notifyDataStorageChanges(changes);
    }

    private static void notifyDataStorageChanges(List<DataStorageChange> changes) {
        if (changes.isEmpty()) {
            return;
        }
        MAIN_HANDLER.post(() -> {
            List<DataStorageChangeListener> snapshot = new ArrayList<>();
            synchronized (CapgoCapacitorDataStorageSqlite.class) {
                snapshot.addAll(dataStorageChangeListeners);
            }
            for (DataStorageChange change : changes) {
                for (DataStorageChangeListener listener : snapshot) {
                    listener.onDataStorageChange(change);
                }
            }
        });
    }

    private StorageDatabaseHelper mDb;
    private Context context;

    public CapgoCapacitorDataStorageSqlite(Context context) {
        this.context = context;
    }

    private String getCurrentDatabaseName() {
        if (mDb == null) {
            return "";
        }
        String storeName = mDb.getStoreName();
        if (storeName.endsWith(SQLITE_SUFFIX)) {
            return storeName.substring(0, storeName.length() - SQLITE_SUFFIX.length());
        }
        return storeName;
    }

    private String getCurrentTableName() {
        return mDb != null ? mDb.getTableName() : "";
    }

    private DataStorageChange createCurrentDataStorageChange(String key, String value, boolean deleted) {
        return new DataStorageChange(getCurrentDatabaseName(), getCurrentTableName(), key, value, deleted);
    }

    private void notifyCurrentDataStorageChange(String key, String value, boolean deleted) {
        notifyDataStorageChange(createCurrentDataStorageChange(key, value, deleted));
    }

    private List<DataStorageChange> createCurrentDataStorageChanges(List<String> keys, String value, boolean deleted) {
        List<DataStorageChange> changes = new ArrayList<>();
        for (String key : keys) {
            changes.add(createCurrentDataStorageChange(key, value, deleted));
        }
        return changes;
    }

    public void openStore(String dbName, String tableName, Boolean encrypted, String inMode, int version, String autoVacuum)
        throws Exception {
        try {
            mDb = new StorageDatabaseHelper(context, dbName + "SQLite.db", tableName, encrypted, inMode, version, autoVacuum);
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
                notifyCurrentDataStorageChange(key, value, false);
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
                boolean existed = mDb.iskey(name);
                mDb.remove(name);
                if (existed) {
                    notifyCurrentDataStorageChange(name, null, true);
                }
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
                List<DataStorageChange> changes = createCurrentDataStorageChanges(mDb.keys(), null, true);
                mDb.clear();
                notifyDataStorageChanges(changes);
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
                List<DataStorageChange> changes = mDb.getTableName().equals(table)
                    ? createCurrentDataStorageChanges(mDb.keys(), null, true)
                    : new ArrayList<>();
                mDb.deleteTable(table);
                notifyDataStorageChanges(changes);
                return;
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("mDb is not opened or null");
        }
    }

    public void vacuum() throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                mDb.vacuum();
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

    public Boolean isJsonValid(String parsingData) throws Exception {
        try {
            JSObject jsonObject = new JSObject(parsingData);
            JsonStore jsonSQL = new JsonStore();
            Boolean isValid = jsonSQL.isJsonStore(jsonObject);
            return isValid;
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    public JSObject importFromJson(String parsingData) throws Exception {
        try {
            JSObject retObj = new JSObject();
            JSObject jsonObject = new JSObject(parsingData);
            JsonStore jsonSQL = new JsonStore();
            Boolean isValid = jsonSQL.isJsonStore(jsonObject);
            if (!isValid) {
                String msg = "Stringify Json Object not Valid";
                throw new Exception(msg);
            }
            int totalChanges = 0;
            String dbName = jsonSQL.getDatabase();
            Boolean encrypted = jsonSQL.getEncrypted();
            String inMode = "";
            if (encrypted) {
                inMode = "secret";
            }
            ArrayList<JsonTable> tables = jsonSQL.getTables();
            for (JsonTable table : tables) {
                // open the database
                mDb = new StorageDatabaseHelper(context, dbName + "SQLite.db", table.getName(), encrypted, inMode, 1, null);
                if (mDb != null) {
                    mDb.open();
                    if (mDb.isOpen) {
                        int changes = mDb.importFromJson(table.getValues());
                        mDb.close();
                        if (changes < 1) {
                            throw new Exception("changes < 1");
                        } else {
                            totalChanges += changes;
                            List<DataStorageChange> importedChanges = new ArrayList<>();
                            for (JsonValue value : table.getValues()) {
                                importedChanges.add(
                                    new DataStorageChange(dbName, table.getName(), value.getKey(), value.getValue(), false)
                                );
                            }
                            notifyDataStorageChanges(importedChanges);
                        }
                    } else {
                        throw new Exception("mDb is not opened");
                    }
                } else {
                    throw new Exception("mDb is null");
                }
            }
            retObj.put("changes", totalChanges);
            return retObj;
        } catch (Exception e) {
            String msg = "importFromJson : " + e.getMessage();
            throw new Exception(msg);
        }
    }

    public JSObject exportToJson() throws Exception {
        if (mDb != null && mDb.isOpen) {
            try {
                JSObject ret = mDb.exportToJson();
                JsonStore jsonSQL = new JsonStore();
                Boolean isValid = jsonSQL.isJsonStore(ret);
                if (isValid) {
                    return ret;
                } else {
                    String msg = "ExportToJson: return Obj is not a JsonStore Obj";
                    throw new Exception(msg);
                }
            } catch (Exception e) {
                String msg = "ExportToJson " + e.getMessage();
                throw new Exception(msg);
            }
        } else {
            String msg = "mDb is not opened or null ";
            throw new Exception(msg);
        }
    }
}
