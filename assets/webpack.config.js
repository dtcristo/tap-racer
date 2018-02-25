const webpack = require('webpack');
const autoprefixer = require('autoprefixer');

const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const isDevelopment = process.env.NODE_ENV === 'development';
const isProduction = process.env.NODE_ENV === 'production';

module.exports = {
  entry: {
    app: './js/app.js'
  },
  output: {
    filename: 'js/[name].js',
    path: __dirname + '/../priv/static/'
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [ /elm-stuff/, /node_modules/ ],
        use: {
          loader: 'elm-webpack-loader',
          options: {
            cwd: __dirname,
            debug: isDevelopment,
            warn: true
          }
        }
      },
      {
        test: /\.(scss|sass|css)$/,
        use: ExtractTextPlugin.extract({
          use: [
            { loader: 'css-loader',
              options: { minimize: isProduction }
            },
            {
              loader: 'postcss-loader',
              options: { plugins: [ autoprefixer ] }
            },
            { loader: 'sass-loader' }
          ]
        })
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin({ filename: 'css/[name].css' }),
    new CopyWebpackPlugin([
      { from: './static/' },
      { from: './vendor/' }
    ]),
  ]
};

// Production specific configuration
if (isProduction) {
  module.exports.plugins.push(
    new webpack.optimize.ModuleConcatenationPlugin(),
    new webpack.optimize.UglifyJsPlugin()
  );
}
