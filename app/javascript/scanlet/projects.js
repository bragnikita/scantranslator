import ContextForm from '../context_forms/context-forms.js'
import Dropzone from 'dropzone'

Dropzone.autoDiscover = false;

$(document).on('turbolinks:load', function () {
    'use strict';


    const form = new ContextForm('#project-description-form');
    form.initComponents();


});