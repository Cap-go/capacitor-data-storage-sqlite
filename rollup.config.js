import nodeResolve from '@rollup/plugin-node-resolve';

export default {
  input: 'dist/esm/index.js',
  external: ['jeep-localforage'],
  output: {
    file: 'dist/plugin.js',
    format: 'iife',
    name: 'capacitorPlugin',
    globals: {
      '@capacitor/core': 'capacitorExports',
      'jeep-localforage': 'LocalForage',
    },
    sourcemap: true,
  },
  plugins: [
    nodeResolve({
      // allowlist of dependencies to bundle in
      // @see https://github.com/rollup/plugins/tree/master/packages/node-resolve#resolveonly
      resolveOnly: ['lodash'],
    }),
  ],
};
