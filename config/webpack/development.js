const environment = require('./environment');

const result = environment.toWebpackConfig();
result.output.filename = '[name].js';
let aliases = result.resolve.alias || {};
let fileupload = {
    'load-image': 'blueimp-load-image/js/load-image.js',
    'load-image-meta': 'blueimp-load-image/js/load-image-meta.js',
    'load-image-exif': 'blueimp-load-image/js/load-image-exif.js',
    'load-image-scale': 'blueimp-load-image/js/load-image-scale.js',
    'canvas-to-blob': 'blueimp-canvas-to-blob/js/canvas-to-blob.js',
    'jquery-ui/ui/widget': 'blueimp-file-upload/js/vendor/jquery.ui.widget.js'
};
result.resolve.alias = Object.assign(aliases, fileupload);
module.exports = result;
