import Dropzone from 'dropzone'

let miup_template = require('./multiple_images_upload.handlebars');

function multiple_images_uploader(options) {

    const title = options.title || 'Upload images';
    let modal = miup_template({
        title: title
    });
    const $modal = $(modal);

    const dropzone = new Dropzone($modal.find('.dropzone')[0], {
        url: options.url || '/uploads/common_images',
        paramName: 'file',
        createImageThumbnails: true,
        autoProcessQueue: true,
        maxFiles: 20,
        acceptedFiles: 'image/*'
    });
    $modal.data('dropzone', dropzone);

    const bus = jQuery($modal);

    const files_collection = [];

    let counter = 0;
    dropzone.on('addedfile', (file) => {
        file.index = counter++;
    });


    dropzone.on('success', (file, response) => {
        files_collection[file.index]={
            file: file,
            index: file.index,
            image_id: response.object_id,
            image_url: response.object_url
        };
        bus.trigger('image_uploaded', [file, file.upload.uuid, response]);
    });
    dropzone.on('error', (file, msg, xhr) => {
        bus.trigger('error', [file, message, xhr ? xhr.responseText : null])
    });


    $modal.find('.save').click((e) => {
        bus.trigger('apply', [_.compact(files_collection)]);
        $modal.modal('hide');
    });

    $modal.on('show.bs.modal', () => {

    });
    $modal.on('hidden.bs.modal', () => {
        dropzone.removeAllFiles();
        files_collection.splice(0, files_collection.length);
        counter = 0;
    });

    $modal.appendTo('body');
    return Object.assign(bus, {
        modal: $modal,
        dropzone: dropzone
    })
}

const ImageUploaders = {
    multiple_images_dialog: multiple_images_uploader
};
export default ImageUploaders;