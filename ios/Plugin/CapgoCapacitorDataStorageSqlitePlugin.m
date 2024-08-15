#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(CapgoCapacitorDataStorageSqlitePlugin, "CapgoCapacitorDataStorageSqlite",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(openStore, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(closeStore, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(isStoreOpen, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(isStoreExists, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setTable, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(set, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(get, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(remove, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clear, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(keys, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(values, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(filtervalues, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(keysvalues, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(iskey, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(deleteStore,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(isTable,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(tables,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(deleteTable,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(isJsonValid,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(importFromJson,CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(exportToJson,CAPPluginReturnPromise);
)
