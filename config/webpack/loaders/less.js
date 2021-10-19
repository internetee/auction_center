const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const path = require('path');

// module.exports = {
//   test: /\.less$/,
//   use: [
//     MiniCssExtractPlugin.loader,
//     'css-loader',
//     {
//       loader: 'less-loader',
//       options: {
//         lessOptions: {
//           paths: [path.resolve(__dirname, 'app/javascript/src/semantic-ui/')],
//           sourceMap: false,
//         },
//       },
//     },
//   ],
// };

module.exports = {
    plugins: [new MiniCssExtractPlugin()],
    module: {
        rules: [
            {
                test: /\.less$/,
                use: [MiniCssExtractPlugin.loader,
                    "css-loader",
                    {
                        loader: 'less-loader',
                        options: {
                            lessOptions: {
                                paths: [path.resolve(__dirname, 'app/javascript/src/semantic-ui/')],
                                sourceMap: false,
                            },
                        },
                    },
                ],
            },
        ],
    },
};
