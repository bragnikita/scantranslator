import ContextForm from '../context_forms/context-forms.js'

$(document).on('turbolinks:load', function () {
    'use strict';

    const form = new ContextForm('#project-description-form');
    form.initComponents();


});