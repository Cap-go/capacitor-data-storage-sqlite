package com.jeep.plugin.capacitor;

import android.content.Context;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import java.util.List;
import org.json.JSONException;
import java.io.File;

import com.jeep.plugin.capacitor.cdssUtils.StorageDatabaseHelper;
import com.jeep.plugin.capacitor.cdssUtils.Data;
import com.jeep.plugin.capacitor.cdssUtils.Global;

@NativePlugin()
public class CapacitorDataStorageSqlite extends Plugin {
    private StorageDatabaseHelper mDb;
    private Global globalData = new Global();

    private  Context context;

    public void load() {
        // Get singleton instance of database
        context = getContext();
//        mDb = StorageDatabaseHelper.getInstance(context);
    }

    @PluginMethod()
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", value);
        call.success(ret);
    }
    @PluginMethod()
    public void openStore(PluginCall call) {

        String dbName = null;
        String tableName = null;
        Boolean encrypted = null;
        String secret = null;
        String newsecret = null;
        String inMode = null;
        JSObject ret = new JSObject();


        dbName = call.getString("database");
        if (dbName == null) {
            dbName = "storage";
        }
        tableName = call.getString("table");
        if (tableName == null) {
            tableName = "storage_table";
        }
        encrypted = call.getBoolean("encrypted", false);
        if (encrypted) {
            inMode = call.getString("mode","no-encryption");
            if (!inMode.equals("no-encryption") && !inMode.equals("encryption") &&
                    !inMode.equals("secret") && !inMode.equals("newsecret") &&
                    !inMode.equals("wrongsecret")) {
                ret.put("result", false);
                ret.put("message", "OpenStore: Error inMode must be in ['encryption','secret','newsecret']");
                call.resolve(ret);
            }
            if (inMode.equals("encryption")  || inMode.equals("secret")) {
                secret = globalData.secret;

            } else if (inMode.equals("newsecret")) {
                secret = globalData.secret;
                newsecret = globalData.newsecret;
                globalData.secret = newsecret;
            } else if (inMode.equals("wrongsecret")) {
                // for test purpose only
                secret = "wrongsecret";
                inMode = "secret";
            } else {
                secret = "";
                newsecret = "";
            }

        } else {
            inMode = "no-encryption";
        }

//        mDb = StorageDatabaseHelper.getInstance(context,dbName+"SQLite.db",tableName,1);

        mDb = new StorageDatabaseHelper(context,dbName+"SQLite.db",tableName,encrypted,
                inMode,secret,newsecret,1);
        if (!mDb.isOpen) {
            ret.put("result", false);
        } else {
            ret.put("result", true);
        }
        call.resolve(ret);
    }
    @PluginMethod()
    public void setTable(PluginCall call) {
        String tableName = null;
        String message = "";
        boolean res = false;
        tableName = call.getString("table");
        if (tableName == null) {
            call.reject("Must provide a table name");
            return;
        }
        if(mDb != null) {
            res = mDb.setTable(tableName);
            if (!res) {
                message = "failed in adding table";
            }
        } else {
            message = "Must open a store first";
        }
        JSObject ret = new JSObject();
        ret.put("result",res);
        ret.put("message",message);
        call.resolve(ret);
    }

    @PluginMethod()
    public void set(PluginCall call) {
        String key = call.getString("key");
        if (key == null) {
            call.reject("Must provide key");
            return;
        }
        String value = call.getString("value");
        Data data = new Data();
        data.name = key;
        data.value = value;
        Boolean res = mDb.set(data);
        JSObject ret = new JSObject();
        ret.put("result",res);
        call.resolve(ret);
    }

    @PluginMethod()
    public void get(PluginCall call) {
        String key = call.getString("key");
        if (key == null) {
            call.reject("Must provide key");
            return;
        }
        Data data = mDb.get(key);

        JSObject ret = new JSObject();
        ret.put("value", data.id == null ? JSObject.NULL : data.value);
        call.resolve(ret);
    }

    @PluginMethod()
    public void iskey(PluginCall call) {
        String key = call.getString("key");
        if (key == null) {
            call.reject("Must provide key");
            return;
        }
        boolean res = mDb.iskey(key);

        JSObject ret = new JSObject();
        ret.put("result",res);
        call.resolve(ret);
    }

    @PluginMethod()
    public void remove(PluginCall call) {
        String key = call.getString("key");
        if (key == null) {
            call.reject("Must provide key");
            return;
        }
        boolean res = mDb.remove(key);

        JSObject ret = new JSObject();
        ret.put("result",res);
        call.resolve(ret);
    }

    @PluginMethod()
    public void clear(PluginCall call) {
        boolean res = mDb.clear();

        JSObject ret = new JSObject();
        ret.put("result",res);
        call.resolve(ret);
    }

    @PluginMethod()
    public void keys(PluginCall call) {
        List<String> resKeys = mDb.keys();
        String[] keyArray = resKeys.toArray(new String[resKeys.size()]);

        JSObject ret = new JSObject();
        try {
            ret.put("keys", new JSArray(keyArray));
        } catch (JSONException ex) {
            call.reject("Unable to create key array.");
            return;
        }
        call.resolve(ret);
    }

    @PluginMethod()
    public void values(PluginCall call) {
        List<String> resValues = mDb.values();
        String[] valueArray = resValues.toArray(new String[resValues.size()]);

        JSObject ret = new JSObject();
        try {
            ret.put("values", new JSArray(valueArray));
        } catch (JSONException ex) {
            call.reject("Unable to create value array.");
            return;
        }
        call.resolve(ret);
    }

    @PluginMethod()
    public void keysvalues(PluginCall call) {
        List<Data> resKeysValues = mDb.keysvalues();
        JSObject[] jsObjArray = new JSObject[resKeysValues.size()] ;

        for (int i = 0; i < resKeysValues.size(); i++) {
            JSObject res = new JSObject();
            res.put("key",resKeysValues.get(i).name);
            res.put("value",resKeysValues.get(i).value);
            jsObjArray[i] = res;
        }

        JSObject ret = new JSObject();
        try {
            ret.put("keysvalues", new JSArray(jsObjArray));
        } catch (JSONException ex) {
            call.reject("Unable to create key/value array.");
            return;
        }
        call.resolve(ret);
    }
    @PluginMethod()
    public void deleteStore(PluginCall call) {
        String dbName = null;
        dbName = call.getString("database");
        if (dbName == null) {
            dbName = "storage";
        }
        JSObject ret = new JSObject();

        context.deleteDatabase(dbName + "SQLite.db");
        context.deleteFile(dbName + "SQLite.db");
        File databaseFile = context.getDatabasePath(dbName + "SQLite.db");
        if (databaseFile.exists()) {
            ret.put("result",false);
        } else {
            ret.put("result",true);
        }
        call.resolve(ret);
    }

}
