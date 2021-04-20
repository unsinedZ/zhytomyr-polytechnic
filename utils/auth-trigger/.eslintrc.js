module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
    commonjs: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  parserOptions: {
    ecmaVersion: 6,
  },
  rules: {
    quotes: ["error", "double"],
  },
};
