$(document).on('turbolinks:load', function () {
    'use strict';

    function template(initial) {
        let data = {
            msg: {},
            action: {
                main: {},
                cancel: {}
            }
        };
        data = Object.assign(data, initial || {});
        data.process = () => {
            return row_template(data)
        };
        return data;
    }

    function row_template(data) {
        //language=HTML
        data.msg = data.msg || {};
        let text = `
<div class="upload image item ${data.state}">
<div class="leftcol">
    <span class="preview">${data.preview}</span>
</div>        
<div class="rightcol">
    <div class="controls">
        <span class="btn btn-success main-action">${data.action.main.text}</span> 
        <span class="btn btn-danger cancel-action">${data.action.cancel.text}</span>
    </div>
    <div class="msgs ${data.msg.type}">${data.msg.text}</div>
</div>        
</div>
    `;
        let t = $(text);
        t('.main-action').click(data.action.main.click);
        t('.cancel-action').click(data.action.cancel.click);
        return t;
    }

    // Change this to the location of your server-side upload handler:
    const url = '/ext_images';
    const uploadButton = $('<button/>')
        .addClass('btn btn-primary')
        .prop('disabled', true)
        .text('Processing...')
        .on('click', function () {
            var $this = $(this),
                data = $this.data();
            $this
                .off('click')
                .text('Abort')
                .on('click', function () {
                    $this.remove();
                    data.abort();
                });
            data.submit().always(function () {
                $this.remove();
            });
        });
    $('#fileupload').fileupload({
        url: url,
        dataType: 'json',
        autoUpload: false,
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
        maxFileSize: 10 * 1024 * 1024,
        // Enable image resizing, except for Android and Opera,
        // which actually support image resizing, but fail to
        // send Blob objects via XHR requests:
        disableImageResize: /Android(?!.*Chrome)|Opera/
            .test(window.navigator.userAgent),
        previewMaxWidth: 400,
        previewMaxHeight: 200,
        previewCrop: false
    }).on('fileuploadadd', function (e, data) {
        data.context = $('<div/>').addClass('item').appendTo('#files');
        $.each(data.files, function (index, file) {
            let node = $('<div/>').addClass("content");
            let right = $('<div class="controls"/>').appendTo(node)
                .append($('<span/>').text(file.name));
            if (!index) {
                right
                    .append(uploadButton.clone(true).data(data))
                    .append($('<button/>').addClass('btn btn-danger').text('Remove').click((e) => {
                            data.abort();
                            data.context.remove();
                            data.context = null;
                        }
                    ));
            }

            node.appendTo(data.context);
        });
    }).on('fileuploadprocessalways', function (e, data) {
        var index = data.index,
            file = data.files[index],
            node = $(data.context.children()[index]);
        console.log(`processalways for ${file.name}`);
        if (file.preview) {
            node
                .prepend($('<div/>').addClass('preview').append(file.preview))
        }
        if (file.error) {
            node
                .append('<div class="error">')
                .append($('<span class="text-danger"/>').text(file.error));
        }
        if (index + 1 === data.files.length) {
            data.context.find('button.btn-primary')
                .text('Upload')
                .prop('disabled', !!data.files.error);
        }
    }).on('fileuploadprogressall', function (e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        $('#progress .progress-bar').css(
            'width',
            progress + '%'
        );
    }).on('fileuploaddone', function (e, data) {
        $.each(data.result.files, function (index, file) {
            if (file.url) {
                var link = $('<a>')
                    .attr('target', '_blank')
                    .prop('href', file.url);
                $(data.context.children()[index])
                    .wrap(link);
            } else if (file.error) {
                var error = $('<span class="text-danger"/>').text(file.error);
                console.log(`fileuploaddone (file.error) for ${file.name}`);
                $(data.context.children()[index])
                    .append('<br>')
                    .append(error);
            }
        });
    }).on('fileuploadfail', function (e, data) {
        $.each(data.files, function (index) {
            let error = $('<span class="text-danger"/>').text('File upload failed.');
            console.log(`fileuploadfail (file.error) for ${data.files[index]}`);
            $(data.context.children()[index])
                .append('<br>')
                .append(error);
        });
    }).prop('disabled', !$.support.fileInput)
        .parent().addClass($.support.fileInput ? undefined : 'disabled');
});

