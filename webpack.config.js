var webpack = require('webpack');

module.exports = {
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
        rules: [
          {test: /\.coffee$/, use: "coffee-loader"},
          {test: /\.scss$/, use: "file-loader?name=css/[name].css!extract!css!sass"},
          {test: /\.html$/, use: "raw-loader"},
        ]
    }
};
