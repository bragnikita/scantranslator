import ContextForm from '../context_forms/context-forms.js'
import Dropzone from 'dropzone'

$(document).on('turbolinks:load', function () {
    'use strict';

    const form = new ContextForm('#project-description-form');
    form.initComponents();

    const project_cover = $("#project-description").find(".cover");
    project_cover.addClass('dropzone');

    const dz = new Dropzone("#project-description .cover", {
        url: "uploaded_images",
        paramName: $(project_cover).data('upload-param') || 'file',
        createImageThumbnails: true,
        autoProcessQueue: false,
        maxFiles: 2,
        clickable: "#project-description .cover, #project-description .cover .current",
        acceptedFiles: 'image/*'

    });
    dz.on("addedfile", (f) => {
        project_cover.find('img.current').hide();
    })

});