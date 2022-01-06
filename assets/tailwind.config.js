module.exports = {
  mode: 'jit',
  content: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {}
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
