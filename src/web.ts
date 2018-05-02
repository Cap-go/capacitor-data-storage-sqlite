import { WebPlugin } from '@capacitor/core';

export class CapacitorDataStorageIdbWeb extends WebPlugin {
  constructor() {
    super({
      name: 'CapacitorDataStorageIdb',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }) {
    console.log('ECHO', options);
    return Promise.resolve();
  }
}

const MyPlugin = new CapacitorDataStorageIdbWeb();

export { MyPlugin };
