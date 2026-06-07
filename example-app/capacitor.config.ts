import type { CapacitorConfig } from '@capacitor/cli';

import pkg from './package.json';

const config: CapacitorConfig = {
  "appId": "app.capgo.data.storage.sqlite",
  "appName": "Data Storage SQLite Example",
  "webDir": "dist",
  "plugins": {
    "SplashScreen": {
      "launchAutoHide": false
    },
    "CapacitorUpdater": {
      "appId": "app.capgo.data.storage.sqlite",
      "autoUpdate": true,
      "autoSplashscreen": true,
      "directUpdate": "always",
      "defaultChannel": "production",
      "version": pkg.version
    }
  }
};

export default config;
