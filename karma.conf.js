// Karma configuration
// Generated on Thu Sep 27 2018 09:51:11 GMT+0300 (EEST)

const webpackConfig = require('./config/webpack/test.js');
module.exports = function(config) {
    config.set({

        // base path that will be used to resolve all patterns (eg. files, exclude)
        basePath: '',


        // frameworks to use
        // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
        frameworks: ['qunit'],

        plugins: ['karma-qunit',
                  'karma-coverage',
                  'karma-chrome-launcher',
                  'karma-jquery',
                  'karma-webpack'],


        // list of files / patterns to load in the browser
        files: [
            { pattern: 'test/javascript/*_test.js', watched: false },
        ],


        // list of files / patterns to exclude
        exclude: [
        ],


        // preprocess matching files before serving them to the browser
        // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
        preprocessors: {
            'test/javascript/**/*_test.js' : ["webpack"],
            'test/javascript/*_test.js' : ["webpack"]
        },

        // Webpack configuration
        webpack: webpackConfig,


        // test results reporter to use
        // possible values: 'dots', 'progress'
        // available reporters: https://npmjs.org/browse/keyword/karma-reporter
        reporters: ['progress'],


        // web server port
        port: 9876,


        // enable / disable colors in the output (reporters and logs)
        colors: true,


        // level of logging
        // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        logLevel: config.LOG_INFO,


        // enable / disable watching file and executing tests whenever any file changes
        autoWatch: true,


        // start these browsers
        // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
        browsers: ['ChromeCustom'],
        customLaunchers: {
            ChromeCustom: {
                base: "ChromeHeadless",
                flags: ["--no-sandbox"]
            }
        },


        // Continuous Integration mode
        // if true, Karma captures browsers, runs the tests and exits
        singleRun: true,

        // Concurrency level
        // how many browser should be started simultaneous
        concurrency: Infinity
    });
};
