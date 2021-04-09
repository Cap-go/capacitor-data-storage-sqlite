import { WebPlugin } from '@capacitor/core';
export class CapacitorDataStorageSqliteWeb extends WebPlugin {
    async echo(options) {
        console.log('ECHO', options);
        const ret = {};
        ret.value = options.value ? options.value : '';
        return ret;
    }
    async openStore(options) {
        console.log('openStore', options);
        throw new Error('Method not implemented.');
    }
    async setTable(options) {
        console.log('setTable', options);
        throw new Error('Method not implemented.');
    }
    async set(options) {
        console.log('set', options);
        throw new Error('Method not implemented.');
    }
    async get(options) {
        console.log('get', options);
        throw new Error('Method not implemented.');
    }
    async remove(options) {
        console.log('remove', options);
        throw new Error('Method not implemented.');
    }
    async clear() {
        throw new Error('Method not implemented.');
    }
    async iskey(options) {
        console.log('iskey', options);
        throw new Error('Method not implemented.');
    }
    async keys() {
        throw new Error('Method not implemented.');
    }
    async values() {
        throw new Error('Method not implemented.');
    }
    async filtervalues(options) {
        console.log('filtervalues', options);
        throw new Error('Method not implemented.');
    }
    async keysvalues() {
        throw new Error('Method not implemented.');
    }
    async deleteStore(options) {
        console.log('deleteStore', options);
        throw new Error('Method not implemented.');
    }
}
//# sourceMappingURL=web.js.map