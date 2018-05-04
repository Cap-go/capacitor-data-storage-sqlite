package com.jeep.plugin;

import android.app.Activity;
import android.content.Context;


import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.jeep.plugin.StorageDatabaseHelper;
import com.jeep.plugin.Data;

@NativePlugin()
public class CapacitorDataStorageSqlite extends Plugin {
    private StorageDatabaseHelper mDb;
    private  Context context;

    public void load() {
        // Get singleton instance of database
        context = getContext();
        mDb = StorageDatabaseHelper.getInstance(context);
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

}
