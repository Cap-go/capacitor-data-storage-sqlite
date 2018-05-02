import { WebPlugin } from '@capacitor/core';
export declare class CapacitorDataStorageIdbWeb extends WebPlugin {
    constructor();
    echo(options: {
        value: string;
    }): Promise<void>;
}
declare const MyPlugin: CapacitorDataStorageIdbWeb;
export { MyPlugin };
