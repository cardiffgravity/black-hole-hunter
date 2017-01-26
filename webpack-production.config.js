var webpack = require('webpack');

module.exports = {
    debug: true,
    entry: {
        splash: './coffee/splash.coffee',
        game: './coffee/game.coffee',
        lost: './coffee/lost.coffee',
        complete: './coffee/complete.coffee'
    },
    output: {
        path: __dirname,
        filename: './js/[name].js'
    },
    module: {
        loaders: [{
          test: /\.coffee$/,
          loader: "coffee"
        },{
          test: /\.scss$/,
          loader: "file-loader?name=css/[name].css!extract!css!sass"
        },{
          test: /\.html$/,
          loader: "null!raw"
        },{
          test: /\.json$/,
          loader: "json"
        }]
    },
    plugins: [
      new webpack.optimize.UglifyJsPlugin()]
};
