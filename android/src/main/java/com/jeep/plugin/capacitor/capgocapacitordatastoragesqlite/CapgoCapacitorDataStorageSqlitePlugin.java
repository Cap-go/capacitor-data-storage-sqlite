package com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite;

import android.content.Context;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "CapgoCapacitorDataStorageSqlite")
public class CapgoCapacitorDataStorageSqlitePlugin extends Plugin {

  private CapgoCapacitorDataStorageSqlite implementation;
  private RetHandler rHandler = new RetHandler();
  private Context context;

  /**
   * Load Method
   * Load the context
   */
  public void load() {
    context = getContext();
    implementation = new CapgoCapacitorDataStorageSqlite(context);
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
        String msg =
          "OpenStore: Error inMode must be in ['encryption','secret'," +
          "'newsecret']";
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
  public void closeStore(PluginCall call) {
    if (!call.getData().has("database")) {
      rHandler.retResult(call, false, "closeStore: Must provide a database");
      return;
    }
    String dbName = call.getString("database");
    try {
      implementation.closeStore(dbName);
      rHandler.retResult(call, null, null);
      return;
    } catch (Exception e) {
      String msg = "Close: " + e.getMessage();
      rHandler.retResult(call, null, msg);
      return;
    }
  }

  @PluginMethod
  public void isStoreOpen(PluginCall call) {
    boolean ret = false;
    if (!call.getData().has("database")) {
      rHandler.retResult(call, false, "IsStoreOpen: Must provide a database");
      return;
    }
    String dbName = call.getString("database");
    try {
      ret = implementation.isStoreOpen(dbName);
      rHandler.retResult(call, ret, null);
      return;
    } catch (Exception e) {
      String msg = "IsStoreOpen: " + e.getMessage();
      rHandler.retResult(call, false, msg);
      return;
    }
  }

  @PluginMethod
  public void isStoreExists(PluginCall call) {
    boolean ret = false;
    if (!call.getData().has("database")) {
      rHandler.retResult(call, false, "IsStoreExists: Must provide a database");
      return;
    }
    String dbName = call.getString("database");
    try {
      ret = implementation.isStoreExists(dbName);
      rHandler.retResult(call, ret, null);
      return;
    } catch (Exception e) {
      String msg = "IsStoreExists: " + e.getMessage();
      rHandler.retResult(call, false, msg);
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
      rHandler.retJSObject(
        call,
        new JSObject(),
        "Filtervalues: Must provide a filter"
      );
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
      String msg = "Tables: " + e.getMessage();
      rHandler.retJSObject(call, new JSObject(), msg);
      return;
    }
  }

  @PluginMethod
  public void deleteTable(PluginCall call) {
    if (!call.getData().has("table")) {
      rHandler.retResult(call, null, "DeleteTable: Must provide a table");
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

  @PluginMethod
  public void deleteStore(PluginCall call) {
    if (!call.getData().has("database")) {
      rHandler.retResult(call, null, "DeleteStore: Must provide a database");
      return;
    }
    String dbName = call.getString("database");
    try {
      implementation.deleteStore(dbName);
      rHandler.retResult(call, null, null);
      return;
    } catch (Exception e) {
      String msg = "DeleteStore: " + e.getMessage();
      rHandler.retResult(call, null, msg);
      return;
    }
  }

  /**
   * IsJsonValid
   * Check the validity of a given Json object
   * @param call
   */
  @PluginMethod
  public void isJsonValid(PluginCall call) {
    if (!call.getData().has("jsonstring")) {
      String msg = "IsJsonValid: Must provide a Stringify Json Object";
      rHandler.retResult(call, false, msg);
      return;
    }
    String parsingData = call.getString("jsonstring");
    try {
      Boolean res = implementation.isJsonValid(parsingData);
      rHandler.retResult(call, res, null);
      return;
    } catch (Exception e) {
      String msg = "isJsonValid: " + e.getMessage();
      rHandler.retResult(call, false, msg);
      return;
    }
  }

  /**
   * ImportFromJson Method
   * Import from a given Json object
   * @param call
   */
  @PluginMethod
  public void importFromJson(PluginCall call) {
    JSObject retRes = new JSObject();
    retRes.put("changes", Integer.valueOf(-1));
    if (!call.getData().has("jsonstring")) {
      String msg = "ImportFromJson: Must provide a Stringify Json Object";
      rHandler.retChanges(call, retRes, msg);
      return;
    }
    String parsingData = call.getString("jsonstring");
    try {
      JSObject res = implementation.importFromJson(parsingData);
      rHandler.retChanges(call, res, null);
      return;
    } catch (Exception e) {
      String msg = "ImportFromJson: " + e.getMessage();
      rHandler.retChanges(call, retRes, msg);
      return;
    }
  }

  /**
   * ExportToJson Method
   * Export the database to Json Object
   * @param call
   */
  @PluginMethod
  public void exportToJson(PluginCall call) {
    JSObject retObj = new JSObject();

    try {
      JSObject res = implementation.exportToJson();
      rHandler.retJsonObject(call, res, null);
      return;
    } catch (Exception e) {
      String msg = "ExportToJson: " + e.getMessage();
      rHandler.retJsonObject(call, retObj, msg);
      return;
    }
  }
}
