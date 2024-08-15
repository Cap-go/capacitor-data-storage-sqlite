package com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils.ImportExportJson;

import android.util.Log;
import com.getcapacitor.JSObject;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class JsonTable {

  private static final String TAG = "JsonTable";
  private static final List<String> keyTableLevel = new ArrayList<String>(
    Arrays.asList("name", "values")
  );

  private String name = "";
  private ArrayList<JsonValue> values = new ArrayList<JsonValue>();

  // Getter
  public String getName() {
    return name;
  }

  public ArrayList<JsonValue> getValues() {
    return values;
  }

  // Setter
  public void setName(String newName) {
    this.name = newName;
  }

  public void setValues(ArrayList<JsonValue> newValues) {
    this.values = newValues;
  }

  public ArrayList<String> getKeys() {
    ArrayList<String> retArray = new ArrayList<String>();
    if (getName().length() > 0) retArray.add("names");
    if (getValues().size() > 0) retArray.add("values");
    return retArray;
  }

  public boolean isTable(JSONObject jsObj) {
    if (jsObj == null || jsObj.length() == 0) return false;
    Iterator<String> keys = jsObj.keys();
    while (keys.hasNext()) {
      String key = keys.next();
      if (!keyTableLevel.contains(key)) return false;
      try {
        Object value = jsObj.get(key);
        if (key.equals("name")) {
          if (!(value instanceof String)) {
            return false;
          } else {
            name = (String) value;
          }
        }
        if (key.equals("values")) {
          if (!(value instanceof JSONArray) && !(value instanceof ArrayList)) {
            return false;
          } else {
            values = new ArrayList<JsonValue>();
            JSONArray arr = jsObj.getJSONArray(key);
            for (int i = 0; i < arr.length(); i++) {
              JSONObject row = arr.getJSONObject(i);
              JsonValue arrRow = new JsonValue();
              arrRow.setKey(row.getString("key"));
              arrRow.setValue(row.getString("value"));
              values.add(arrRow);
            }
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
    Log.d(TAG, "name: " + this.getName());
    Log.d(TAG, "number of Values: " + this.getValues().size());
    for (JsonValue row : this.getValues()) {
      Log.d(TAG, "row: " + row);
    }
  }

  public JSObject getTableAsJSObject() {
    JSObject retObj = new JSObject();
    retObj.put("name", getName());
    JSONArray JSValues = new JSONArray();
    if (this.values.size() > 0) {
      if (this.values.size() > 0) {
        for (JsonValue jVal : this.values) {
          JSValues.put(jVal.getValueAsJSObject());
        }
        retObj.put("values", JSValues);
      }
      retObj.put("values", JSValues);
    }

    return retObj;
  }
}
