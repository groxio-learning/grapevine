const postcssImport = require('postcss-import');
const tailwindcss = require('tailwindcss')
const cssnano = require('cssnano')({
  preset: 'default',
});
const autoprefixer = require('autoprefixer')

const plugins =
  process.env.NODE_ENV === 'production'
    ? [postcssImport, tailwindcss, autoprefixer, cssnano]
    : [postcssImport, tailwindcss, autoprefixer]

module.exports = { plugins: plugins };
