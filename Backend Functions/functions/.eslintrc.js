module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "require-jsdoc": 0,
    "quotes": ["error", "double"],
    "linebreak-style": 0,
  },
  parserOptions: {
    ecmaVersion: 2018,
  },
};
