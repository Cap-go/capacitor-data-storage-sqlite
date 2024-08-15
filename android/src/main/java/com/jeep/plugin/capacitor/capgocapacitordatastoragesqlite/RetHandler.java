package com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite;

import android.util.Log;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.PluginCall;

public class RetHandler {

  private static final String TAG = RetHandler.class.getName();

  /**
   * RetResult Method
   * Create and return the capSQLiteResult object
   *
   * @param call
   * @param res
   * @param message
   */
  public void retResult(PluginCall call, Boolean res, String message) {
    JSObject ret = new JSObject();
    if (message != null) {
      ret.put("message", message);
      Log.v(TAG, "*** ERROR " + message);
      call.reject(message);
      return;
    }
    if (res != null) {
      ret.put("result", res);
      call.resolve(ret);
      return;
    } else {
      call.resolve();
      return;
    }
  }

  /**
   * RetValue Method
   * Create and return a value
   * @param call
   * @param res
   * @param message
   */
  public void retValue(PluginCall call, String res, String message) {
    JSObject ret = new JSObject();
    if (message != null) {
      ret.put("message", message);
      Log.v(TAG, "*** ERROR " + message);
      call.reject(message);
      return;
    } else {
      ret.put("value", res);
      call.resolve(ret);
      return;
    }
  }

  /**
   * RetJSObject Method
   * Create and return the capSQLiteJson object
   * @param call
   * @param res
   * @param message
   */
  public void retJSObject(PluginCall call, JSObject res, String message) {
    if (message != null) {
      call.reject(message);
      return;
    } else {
      call.resolve(res);
      return;
    }
  }

  /**
   * RetChanges Method
   * Create and return the capSQLiteChanges object
   * @param call
   * @param res
   * @param message
   */
  public void retChanges(PluginCall call, JSObject res, String message) {
    JSObject ret = new JSObject();
    if (message != null) {
      ret.put("message", message);
      Log.v(TAG, "*** ERROR " + message);
      call.reject(message);
      return;
    } else {
      ret.put("changes", res);
      call.resolve(ret);
      return;
    }
  }

  /**
   * RetJSObject Method
   * Create and return the capSQLiteJson object
   * @param call
   * @param res
   * @param message
   */
  public void retJsonObject(PluginCall call, JSObject res, String message) {
    JSObject ret = new JSObject();
    if (message != null) {
      ret.put("message", message);
      Log.v(TAG, "*** ERROR " + message);
      call.reject(message);
      return;
    } else {
      ret.put("export", res);
      call.resolve(ret);
      return;
    }
  }
}
