$(document).on('turbolinks:load', function () {
    'use strict';

    $('.image-upload-zone').each(function (i, zone) {
        $(zone).dropzone({

            url: $(zone).data('upload-url'),
            paramName: $(zone).data('upload-param') || 'file',
            createImageThumbnails: true,
            autoProcessQueue: true

        })
    })


});