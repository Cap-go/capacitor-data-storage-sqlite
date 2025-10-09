# Example App for `@capgo/capacitor-data-storage-sqlite`

This Vite project links directly to the local plugin source so you can exercise the native APIs while developing.

## Actions in this playground

- **Open store** – Opens (or creates) a store. Call this before other operations.
- **Set key/value** – Persists a key/value pair in the current store.
- **Get value** – Reads a value for the provided key.
- **List keys/values** – Returns all stored key/value pairs.
- **Clear store** – Removes all keys from the currently opened store.
- **Close store** – Closes the opened store.

## Getting started

```bash
npm install
npm start
```

Add native shells with `npx cap add ios` or `npx cap add android` from this folder to try behaviour on device or simulator.
