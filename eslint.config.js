const ionic = require('@ionic/eslint-config/recommended');

module.exports = [
  {
    ignores: ['build', 'dist', 'www', 'lib', 'examples', 'example-app', 'docs', 'android', 'ios', 'scripts'],
  },
  ...ionic,
];
