
  Pod::Spec.new do |s|
    s.name = 'CapacitorDataStorageSqlite'
    s.version = '0.0.1'
    s.summary = 'Capacitor data storage on SQLite plugin'
    s.license = 'MIT'
    s.homepage = 'https://github.com/jepiqueau/capacitor-data-storage-sqlite.git'
    s.author = 'Jean Pierre Quéau'
    s.source = { :git => 'https://github.com/jepiqueau/capacitor-data-storage-sqlite.git', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '10.0'
    s.dependency 'Capacitor'
  end