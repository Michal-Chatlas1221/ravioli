var webpack = require('webpack');

module.exports = {
  entry: {
    app: [
      'babel-polyfill',
      './index.js'
    ]
  },
  output: {
    path: './',
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: "babel",
        query:
        {
          presets:['es2015']
        }
      }
    ]
  }
};