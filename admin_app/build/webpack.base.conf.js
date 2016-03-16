var path = require('path')

module.exports = {
  entry: {
    app: './src/main.js'
  },
  output: {
    path: path.resolve(__dirname, '../dist/static'),
    publicPath: '/static/',
    filename: '[name].js'
  },
  resolve: {
    extensions: ['', '.js', '.vue'],
    alias: {
      'src': path.resolve(__dirname, '../src')
    }
  },
  resolveLoader: {
    root: path.join(__dirname, 'node_modules')
  },
  module: {
    loaders: [
      {
        test: /\.vue$/,
        loader: 'vue'
      },
      {
        test: /\.js$/,
        loader: 'babel!eslint',
        exclude: /node_modules/
      },
      {
        test: /\.json$/,
        loader: 'json'
      },
      {
        test: /\.(jpg|jpeg|gif|png|ico|svg)$/,
        loader:'file-loader?name=[path][name].[ext]&context=src'
      },
      {
        test: /\.css$/,
        include: [
          path.resolve(__dirname, '../src/static')
        ],
        loaders: ['style', 'css', 'sass']
      },
      {
        test   : /\.(png|ttf|eot|svg|woff(2)?)(\?[-a-z0-9]+)?$/,
        loader : 'file-loader'
      }
    ]
  },
  vue: {
    loaders: {
      js: 'babel!eslint'
    }
  },
  eslint: {
    formatter: require('eslint-friendly-formatter')
  }
}
