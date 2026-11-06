# Consumer rules for @capgo/capacitor-data-storage-sqlite
# Merged into app R8 configs when this AAR is a dependency.

# Capacitor bridges JS to Java by reflection on the plugin class; keep the whole entry class.
-keep class com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.CapgoCapacitorDataStorageSqlitePlugin { *; }

# SQLCipher ships native code loaded via System.loadLibrary("sqlcipher"); keep JNI methods on Zetetic classes.
-keepclasseswithmembernames class net.zetetic.database.sqlcipher.** {
    native <methods>;
}
