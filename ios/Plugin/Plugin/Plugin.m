#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(CapacitorDataStorageSqlite, "CapacitorDataStorageSqlite",
           CAP_PLUGIN_METHOD(saveData, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getData, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(removeData, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(removeAllData, CAPPluginReturnPromise);
)
