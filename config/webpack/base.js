// const { webpackConfig } = require('@rails/webpacker')

// module.exports = webpackConfig

const { webpackConfig, merge } = require('@rails/webpacker')
const webpack = require('webpack');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const plugins = [
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        jquery: 'jquery'
    }),
    new MiniCssExtractPlugin({
        filename: "[name].css",
        chunkFilename: "[id].css",
    }),
]

module.exports = merge(
    webpackConfig,
    {
        module: {
            rules: []
        },
        plugins: plugins,
    }
)

const scssConfigIndex = webpackConfig.module.rules.findIndex((config) => ".scss".match(config.test))
webpackConfig.module.rules.splice(scssConfigIndex, 1)
