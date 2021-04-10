package com.jeep.plugin.capacitor.capacitordatastoragesqlite;

import android.content.Context;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "CapacitorDataStorageSqlite")
public class CapacitorDataStorageSqlitePlugin extends Plugin {

    private CapacitorDataStorageSqlite implementation;
    private RetHandler rHandler = new RetHandler();
    private Context context;

    /**
     * Load Method
     * Load the context
     */
    public void load() {
        context = getContext();
        implementation = new CapacitorDataStorageSqlite(context);
    }

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod
    public void openStore(PluginCall call) {
        String dbName = call.getString("database", "storage");
        String tableName = call.getString("table", "storage_table");
        Boolean encrypted = call.getBoolean("encrypted", false);
        String secret = null;
        String newsecret = null;
        String inMode = null;

        if (encrypted) {
            inMode = call.getString("mode", "no-encryption");
            if (
                !inMode.equals("no-encryption") &&
                !inMode.equals("encryption") &&
                !inMode.equals("secret") &&
                !inMode.equals("newsecret") &&
                !inMode.equals("wrongsecret")
            ) {
                String msg = "OpenStore: Error inMode must be in ['encryption','secret'," + "'newsecret']";
                rHandler.retResult(call, null, msg);
                return;
            }
        } else {
            inMode = "no-encryption";
        }
        try {
            implementation.openStore(dbName, tableName, encrypted, inMode, 1);
            rHandler.retResult(call, null, null);
            return;
        } catch (Exception e) {
            String msg = "OpenStore: " + e.getMessage();
            rHandler.retResult(call, null, msg);
            return;
        }
    }

    @PluginMethod
    public void close(PluginCall call) {
        try {
            implementation.close();
            rHandler.retResult(call, null, null);
            return;
        } catch (Exception e) {
            String msg = "Close: " + e.getMessage();
            rHandler.retResult(call, null, msg);
            return;
        }
    }

    @PluginMethod
    public void set(PluginCall call) {
        if (!call.getData().has("key")) {
            rHandler.retResult(call, null, "Set: Must provide a key");
            return;
        }
        String key = call.getString("key");
        if (!call.getData().has("value")) {
            rHandler.retResult(call, null, "Set: Must provide a value");
            return;
        }
        String value = call.getString("value");
        try {
            implementation.set(key, value);
            rHandler.retResult(call, null, null);
            return;
        } catch (Exception e) {
            String msg = "Set: " + e.getMessage();
            rHandler.retResult(call, null, msg);
            return;
        }
    }

    @PluginMethod
    public void get(PluginCall call) {
        if (!call.getData().has("key")) {
            rHandler.retValue(call, null, "Get: Must provide a key");
            return;
        }
        String key = call.getString("key");
        try {
            String value = implementation.get(key);
            rHandler.retValue(call, value, null);
            return;
        } catch (Exception e) {
            String msg = "Get: " + e.getMessage();
            rHandler.retValue(call, null, msg);
            return;
        }
    }

    @PluginMethod
    public void remove(PluginCall call) {
        if (!call.getData().has("key")) {
            rHandler.retResult(call, null, "Remove: Must provide a key");
            return;
        }
        String key = call.getString("key");
        try {
            implementation.remove(key);
            rHandler.retResult(call, null, null);
            return;
        } catch (Exception e) {
            String msg = "Remove: " + e.getMessage();
            rHandler.retResult(call, null, msg);
            return;
        }
    }

    @PluginMethod
    public void clear(PluginCall call) {
        try {
            implementation.clear();
            rHandler.retResult(call, null, null);
            return;
        } catch (Exception e) {
            String msg = "Clear: " + e.getMessage();
            rHandler.retResult(call, null, msg);
            return;
        }
    }

    @PluginMethod
    public void iskey(PluginCall call) {
        boolean ret = false;
        if (!call.getData().has("key")) {
            rHandler.retResult(call, false, "Iskey: Must provide a key");
            return;
        }
        String key = call.getString("key");
        try {
            ret = implementation.iskey(key);
            rHandler.retResult(call, ret, null);
            return;
        } catch (Exception e) {
            String msg = "Iskey: " + e.getMessage();
            rHandler.retResult(call, false, msg);
            return;
        }
    }

    @PluginMethod
    public void keys(PluginCall call) {
        try {
            String[] keyArray = implementation.keys();
            JSObject ret = new JSObject();
            ret.put("keys", new JSArray(keyArray));
            rHandler.retJSObject(call, ret, null);
            return;
        } catch (Exception e) {
            String msg = "Keys: " + e.getMessage();
            rHandler.retJSObject(call, new JSObject(), msg);
            return;
        }
    }

    @PluginMethod
    public void values(PluginCall call) {
        try {
            String[] valueArray = implementation.values();
            JSObject ret = new JSObject();
            ret.put("values", new JSArray(valueArray));
            rHandler.retJSObject(call, ret, null);
            return;
        } catch (Exception e) {
            String msg = "Values: " + e.getMessage();
            rHandler.retJSObject(call, new JSObject(), msg);
            return;
        }
    }

    @PluginMethod
    public void keysvalues(PluginCall call) {
        try {
            JSObject[] jsObjArray = implementation.keysvalues();
            JSObject ret = new JSObject();
            ret.put("keysvalues", new JSArray(jsObjArray));
            rHandler.retJSObject(call, ret, null);
            return;
        } catch (Exception e) {
            String msg = "KeysValues: " + e.getMessage();
            rHandler.retJSObject(call, new JSObject(), msg);
            return;
        }
    }

    @PluginMethod
    public void filtervalues(PluginCall call) {
        if (!call.getData().has("filter")) {
            rHandler.retJSObject(call, new JSObject(), "Filtervalues: Must provide a filter");
            return;
        }
        String filter = call.getString("filter");
        try {
            String[] valueArray = implementation.filtervalues(filter);
            JSObject ret = new JSObject();
            ret.put("values", new JSArray(valueArray));
            rHandler.retJSObject(call, ret, null);
            return;
        } catch (Exception e) {
            String msg = "Filtervalues: " + e.getMessage();
            rHandler.retJSObject(call, new JSObject(), msg);
            return;
        }
    }

    @PluginMethod
    public void setTable(PluginCall call) {
        if (!call.getData().has("table")) {
            rHandler.retResult(call, false, "SetTable: Must provide a table");
            return;
        }
        String table = call.getString("table");
        try {
            implementation.setTable(table);
            rHandler.retResult(call, null, null);
            return;
        } catch (Exception e) {
            String msg = "SetTable: " + e.getMessage();
            rHandler.retResult(call, null, msg);
            return;
        }
    }

    @PluginMethod
    public void isTable(PluginCall call) {
        boolean ret = false;
        if (!call.getData().has("table")) {
            rHandler.retResult(call, false, "IsTable: Must provide a table");
            return;
        }
        String table = call.getString("table");
        try {
            ret = implementation.isTable(table);
            rHandler.retResult(call, ret, null);
            return;
        } catch (Exception e) {
            String msg = "IsTable: " + e.getMessage();
            rHandler.retResult(call, false, msg);
            return;
        }
    }

    @PluginMethod
    public void tables(PluginCall call) {
        try {
            String[] tableArray = implementation.tables();
            JSObject ret = new JSObject();
            ret.put("tables", new JSArray(tableArray));
            rHandler.retJSObject(call, ret, null);
            return;
        } catch (Exception e) {
            String msg = "Keys: " + e.getMessage();
            rHandler.retJSObject(call, new JSObject(), msg);
            return;
        }
    }

    @PluginMethod
    public void deleteTable(PluginCall call) {
        if (!call.getData().has("table")) {
            rHandler.retResult(call, null, "Remove: Must provide a table");
            return;
        }
        String table = call.getString("table");
        try {
            implementation.deleteTable(table);
            rHandler.retResult(call, null, null);
            return;
        } catch (Exception e) {
            String msg = "DeleteTable: " + e.getMessage();
            rHandler.retResult(call, null, msg);
            return;
        }
    }
}
