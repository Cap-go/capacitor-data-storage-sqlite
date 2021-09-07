/**
 * IsJsonSQLite
 * @param obj
 */
export const isJsonStore = (obj: any): boolean => {
  const keyFirstLevel: string[] = ['database', 'encrypted', 'tables'];
  if (
    obj == null ||
    (Object.keys(obj).length === 0 && obj.constructor === Object)
  )
    return false;
  for (const key of Object.keys(obj)) {
    if (keyFirstLevel.indexOf(key) === -1) return false;
    if (key === 'database' && typeof obj[key] != 'string') return false;
    if (key === 'encrypted' && typeof obj[key] != 'boolean') return false;
    if (key === 'tables' && typeof obj[key] != 'object') return false;
    if (key === 'tables') {
      for (const oKey of obj[key]) {
        const retTable: boolean = isTable(oKey);
        if (!retTable) return false;
      }
    }
  }
  return true;
};
/**
 * IsTable
 * @param obj
 */
export const isTable = (obj: any): boolean => {
  const keyTableLevel: string[] = ['name', 'values'];
  if (
    obj == null ||
    (Object.keys(obj).length === 0 && obj.constructor === Object)
  ) {
    return false;
  }
  for (const key of Object.keys(obj)) {
    if (keyTableLevel.indexOf(key) === -1) return false;
    if (key === 'name' && typeof obj[key] != 'string') return false;
    if (key === 'values' && typeof obj[key] != 'object') return false;
    if (key === 'values') {
      for (const oKey of obj[key]) {
        const retValue: boolean = isValue(oKey);
        console.log(`$$$ retValue ${retValue} `);
        if (!retValue) return false;
      }
    }
  }
  return true;
};
/**
 * IsValue
 * @param obj
 */
export const isValue = (obj: any): boolean => {
  const keyTableLevel: string[] = ['key', 'value'];
  if (
    obj == null ||
    (Object.keys(obj).length === 0 && obj.constructor === Object)
  ) {
    return false;
  }
  for (const key of Object.keys(obj)) {
    if (keyTableLevel.indexOf(key) === -1) return false;
    if (key === 'key' && typeof obj[key] != 'string') return false;
    if (key === 'value' && typeof obj[key] != 'string') return false;
  }
  return true;
};
