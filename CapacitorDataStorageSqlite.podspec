
  Pod::Spec.new do |s|
    s.name = 'CapacitorDataStorageSqlite'
    s.version = '1.1.1'
    s.summary = 'Capacitor Data Storage to SQLite for Ios,Android and IDB for Web'
    s.license = 'MIT'
    s.homepage = 'https://github.com/jepiqueau/capacitor-data-storage-sqlite.git'
    s.author = 'Jean Pierre Quéau'
    s.source = { :git => 'https://github.com/jepiqueau/capacitor-data-storage-sqlite.git', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency 'SQLite.swift'
  end