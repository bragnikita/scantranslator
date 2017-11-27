const webpack = require('webpack')
const { environment } = require('@rails/webpacker');

environment.plugins.set('CommonChunkVendor', new webpack.optimize.CommonsChunkPlugin({
    name: 'vendor',
    minChunks: (module) => {
        return module.context && module.context.indexOf('node_modules') !== -1;
    }
}));
environment.plugins.set('CommonChunkManifest', new webpack.optimize.CommonsChunkPlugin({
    name: 'manifest',
    minChunks: Infinity
}));
environment.plugins.set('ProvideJquery', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
}));

module.exports = environment;
