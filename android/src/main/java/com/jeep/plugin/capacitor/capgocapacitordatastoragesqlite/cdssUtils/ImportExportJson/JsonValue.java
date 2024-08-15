package com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.ImportExportJson;

import android.util.Log;
import com.getcapacitor.JSObject;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import org.json.JSONException;
import org.json.JSONObject;

public class JsonValue {

  private static final String TAG = "JsonValue";
  private static final List<String> keySchemaLevel = new ArrayList<String>(
    Arrays.asList("key", "value")
  );
  private String key = null;
  private String value = null;

  // Getter
  public String getKey() {
    return key;
  }

  public String getValue() {
    return value;
  }

  // Setter
  public void setKey(String newKey) {
    this.key = newKey;
  }

  public void setValue(String newValue) {
    this.value = newValue;
  }

  public ArrayList<String> getKeys() {
    ArrayList<String> retArray = new ArrayList<String>();
    if (getKey() != null && getKey().length() > 0) retArray.add("key");
    if (getValue() != null && getValue().length() > 0) retArray.add("value");
    return retArray;
  }

  public boolean isValue(JSONObject jsObj) {
    if (jsObj == null || jsObj.length() == 0) return false;
    Iterator<String> keys = jsObj.keys();
    while (keys.hasNext()) {
      String key = keys.next();
      if (!keySchemaLevel.contains(key)) return false;
      try {
        Object val = jsObj.get(key);

        if (key.equals("key")) {
          if (!(val instanceof String)) {
            return false;
          } else {
            key = (String) val;
          }
        }
        if (key.equals("value")) {
          if (!(val instanceof String)) {
            return false;
          } else {
            value = (String) val;
          }
        }
      } catch (JSONException e) {
        e.printStackTrace();
        return false;
      }
    }
    return true;
  }

  public void print() {
    String row = "";
    if (this.getKey() != null) row = "key: " + this.getKey();
    Log.d(TAG, row + " value: " + this.getValue());
  }

  public JSObject getValueAsJSObject() {
    JSObject retObj = new JSObject();
    if (this.key != null) retObj.put("key", this.key);
    retObj.put("value", this.value);
    return retObj;
  }
}
