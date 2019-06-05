const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  test: /\.less$/,
    use: [{ loader: MiniCssExtractPlugin.loader },
          'css-loader',
          'less-loader'],
};
