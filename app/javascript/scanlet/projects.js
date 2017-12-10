import ContextForm from '../context_forms/context-forms.js'
import Dropzone from 'dropzone'

Dropzone.autoDiscover = false;

$(document).on('turbolinks:load', function () {
    'use strict';

    function installImageUploader(selector) {
        let $editable_image = $(selector);
        $editable_image.addClass('editable-image');
        const upload_param = $editable_image.data('upload-param-name') || 'file';
        const form_param = $editable_image.data('form-param-name') || 'image_id';
        let url = $editable_image.data('upload-path');
        let $dropzone = $editable_image.find('.dropzone');
        if ($dropzone.length === 0) {
            $dropzone = $("<div class='dropzone'/>").appendTo($editable_image);
        }

        const dz = new Dropzone("#project-description .cover .dropzone", {
            url: url,
            paramName: upload_param,
            createImageThumbnails: true,
            autoProcessQueue: true,
            maxFiles: 1,
            clickable: $dropzone[0],
            acceptedFiles: 'image/*',
            params: {
                object_id: $editable_image.data('object-id') || ""
            }

        });

        dz.on("addedfile", (f) => {
            // project_cover.find('img.current').hide();
        });
        dz.on("success", (f, resp) => {
            const url = resp.object_url;

            let $current_image = $editable_image.find('img.current');
            if ($current_image.length ===0) {
                $current_image = $("<img class='current' />");
            }
            $current_image.attr('src', url);

            const object_id = resp.object_id;
            let id_input = project_cover.find('input[type=hidden]');
            if (id_input.length === 0) {
                id_input = $("<input type='hidden'/>").attr('name', form_param).appendTo(project_cover)
            }
            id_input.val(object_id);

            $editable_image.attr('data-object-id', object_id);

            moveAwayDropZone();
        });
        dz.on('canceled', (f) => {
            moveAwayDropZone();
        });
        function moveAwayDropZone() {
            dz.destroy();
            $dropzone.remove();
        }
    }

    const form = new ContextForm('#project-description-form');
    form.initComponents();

    const project_cover = $("#project-description").find(".cover");

    installImageUploader(project_cover);

    // const dz = new Dropzone("#project-description .cover .dropzone", {
    //     url: project_cover.data('upload-path'),
    //     paramName: $(project_cover).data('upload-param') || 'file',
    //     createImageThumbnails: true,
    //     autoProcessQueue: true,
    //     maxFiles: 1,
    //     clickable: "#project-description .cover .dropzone",
    //     acceptedFiles: 'image/*'
    //
    // });
    // dz.on("addedfile", (f) => {
    //     // project_cover.find('img.current').hide();
    // });
    // dz.on("success", (f, resp) => {
    //     let url = resp.object_url;
    //     let object_id = resp.object_id;
    //     project_cover.find('img.current').attr('src', url);
    //     let id_input = project_cover.find('input[type=hidden]');
    //     if (id_input.length === 0) {
    //         id_input = $("<input type='hidden' name='object_id'/>").appendTo(project_cover)
    //     }
    //     id_input.val(object_id);
    //     moveAwayDropZone();
    // });
    // dz.on('canceled', (f) => {
    //    moveAwayDropZone();
    // });
    //
    // function setUpDropZone() {
    //
    // }
    //
    // function moveAwayDropZone() {
    //     dz.destroy();
    //     $("#project-description .cover .dropzone").empty()
    // }

});