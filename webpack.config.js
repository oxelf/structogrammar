const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');
module.exports = {
    plugins: [
        new MonacoWebpackPlugin({
            // available options are documented at https://github.com/microsoft/monaco-editor/blob/main/webpack-plugin/README.md#options
            languages: ['cpp', 'javascript','golang', 'cpp']
        })
    ]
};