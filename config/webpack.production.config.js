const webpack = require('webpack');
const path = require('path');
const settings = require('./config.js')
const compressionPlugin = require('compression-webpack-plugin')
const closureCompilerPlugin = require('webpack-closure-compiler');

module.exports = {
  entry: [
    './javascript/bme280-web'
  ],
  module: {
    loaders: [
      { test: /\.js?$/, loader: 'babel-loader', exclude: /node_modules/ },
      { test: /\.s?css$/, loader: 'style-loader!css-loader!sass-loader' },
      { test: /\.vue$/, loader: 'vue-loader', options: { loaders: { 'scss': 'vue-style-loader!css-loader!sass-loader', 'sass': 'vue-style-loader!css-loader!sass-loader?indentedSyntax'} } },
      { test: /\.(jpg|jpeg|png|gif|svg|eot|ttf|woff|woff2)$/, loader: 'file-loader?name=[name].[hash].[ext]' }
    ]
  },
  resolve: {
    extensions: [ '.js' ]
  },
  output: {
    path: path.resolve(__dirname, '../public'),
    filename: '[name].js'
  },
  devtool: 'cheap-eval-source-map',
  devServer: {
      clientLogLevel: 'none',
    contentBase: './public',
    headers: { 'Access-Control-Allow-Origin': '*' }
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify('production')
      }
    }),
    new closureCompilerPlugin(),
    new compressionPlugin({
      asset: '[path].gz',
      algorithm: 'gzip',
      test: /\.js$/
    })
  ]
};
