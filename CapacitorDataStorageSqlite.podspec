
  Pod::Spec.new do |s|
    s.name = 'CapacitorDataStorageSqlite'
    s.version = '2.2.0'
    s.summary = 'Capacitor Data Storage SQLite Plugin'
    s.license = 'MIT'
    s.homepage = 'https://github.com/jepiqueau/jeep/tree/master/capacitor/capacitor-data-storage-sqlite'
    s.author = 'Jean Pierre Quéau'
    s.source = { :git => 'https://github.com/jepiqueau/jeep/tree/master/capacitor/capacitor-data-storage-sqlite', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency 'SQLCipher'
  end