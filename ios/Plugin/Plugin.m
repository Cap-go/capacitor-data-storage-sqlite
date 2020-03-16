#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(CapacitorDataStorageSqlite, "CapacitorDataStorageSqlite",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(openStore, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setTable, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(set, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(get, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(remove, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clear, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(keys, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(values, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(keysvalues, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(iskey, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(deleteStore,CAPPluginReturnPromise);
)
