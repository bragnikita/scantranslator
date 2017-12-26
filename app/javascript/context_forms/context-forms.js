import './context-forms.scss'
import Dropzone from 'dropzone'

export default class ContextForm {



    constructor(form_selector, options) {
        this.form = form_selector;
        this.$form = $(form_selector);
        this.components = [];
        let options_from_form = {
            path: this.$form.data('submit-path') || this.$form.attr('action'),
            ajax: this.$form.data('ajax'),
        };

        if (location.pathname.match(/.+\/new[^\/]*$/)) {
            options_from_form.edit_mode = true
        }

        this.options = Object.assign(this.__defaultOptions(), options_from_form, options);
        if (this.options.ajax) {
            this.submitBtn = this.$form.find('input[type=submit]')
            this.submitBtn.click((e) => {
                e.preventDefault();
                this.submit();
            })
        }
    }

    initComponents() {
        this.components = [];
        this.$form.find('[data-editable]').each((index, component) => {
            const editable = $(component).data('editable');
            if (editable === "false") return;
            if (editable === "image") {
                this.components.push(new ImageComponent(component));
            } else {
                this.components.push(new TextComponent(component,{edit_only: this.options.edit_mode}));
            }
        });
    }

    submit() {
        const paramsArray = this.$form.serializeArray();
        const params = {};
        $.each(paramsArray, (i, a) => {
            params[a.name] = a.value;
        });
        for (let i = 0; i < this.components.length; ++i) {
            Object.assign(params, this.components[i].getValuesMap())
        }
        console.log(params)
        $.ajax(this.options.path, {
            type: 'post',
            dataType: 'json',
            data: params
        }).done((data) => {
            if (data.result === 0)
                console.log(data);
            else {
                this.__handleSubmitError(data.message);
            }
            if (data.goto) {
                window.location.href = data.goto
            }
        }).fail((q, status) => {
            this.__handleSubmitError(status)
        });
    }

    __handleSubmitError(errorMessage) {
        console.log('Error ', errorMessage);
        let errorsBlock = this.$form.find('.formErrors');
        errorsBlock.text(errorMessage || 'Error occurred').show();
    }

    __defaultOptions() {
        return {
            edit_mode: false
        }
    }


}

class EditableComponent {

    constructor(component) {
        let $component = $(component);
        $component.addClass('editable-component');


        let btn = $component.find('.btn-editable-edit');
        if (btn.length == 0) {
            btn = $("<div/>").addClass('btn-editable-edit fa fa-pencil-square-o');
            $component.append(btn)
        }
        this.$component = $component;
        this.$btn = btn;
    }

    showButton(show) {
        if (show)
            this.$btn.removeClass('hidden');
        else
            this.$btn.addClass('hidden');
    }

    getValuesMap() {
        const result = {};
        this.$component.find('input').each((i, c) => {
            result[c.name] = $(c).val();
        });
        return result;
    }

    edit_mode() {

    }

}

class TextComponent extends EditableComponent {

    constructor(component, options) {
        super(component);

        const $editor = this.$component.find('[data-display]');
        if ($editor.length == 0)
            return;
        const $presenter = this.$component.find($editor.data('display'));

        this.$editor = $editor;
        this.$presenter = $presenter;

        this.options = Object.assign({edit_only: false}, options || {});

        this.$btn.click(this.edit.bind(this));
        this.$editor.hide();
        if (!this.options.edit_only) {
            this.$editor.blur(this.commit.bind(this));
        }


        this.toEditor();
        if (this.options.edit_only) {
            this.edit_mode();
        }
    }

    edit_mode() {
        this.$btn.addClass('hidden');
        if (this.$presenter) {
            this.$presenter.hide();
            this.toEditor();
        }
        this.$editor.show()
    }

    toEditor() {
        let value = this.$presenter.text();
        if (this.$editor.is('textarea')) {
            this.$editor.text(value);
        } else {
            this.$editor.val(value);
        }
    }

    toPresenter() {
        let value = this.$editor.val() || this.$editor.text();
        this.$presenter.text(value);
    }

    edit() {
        this.edit_mode();
        this.$editor.focus();
    }

    commit() {
        if (this.options.edit_only)
            return;
        if (this.$presenter) {
            this.toPresenter();
        }
        this.display();
    }

    cancel() {
        this.display();
    }

    display() {
        this.showButton(true);
        this.$editor.hide();
        this.$presenter.show();
    }

    getValuesMap() {
        const result = {};
        this.$component.find('input, textarea').each((i, c) => {
            result[c.name] = $(c).val();
        });
        return result;
    }
}

class ImageComponent extends EditableComponent {

    constructor(component) {
        super(component);
        this.$btn.click(this.installImageUploader.bind(this));
    }

    installImageUploader() {
        this.showButton(false);

        let $editable_image = this.$component;
        $editable_image.addClass('editable-image');
        const upload_param = $editable_image.data('upload-param-name') || 'file';
        const form_param = $editable_image.data('form-param-name') || 'image_id';
        let url = $editable_image.data('upload-path');
        let $dropzone = $editable_image.find('.dropzone');
        if ($dropzone.length === 0) {
            $dropzone = $("<div class='dropzone'/>").appendTo($editable_image);
        }


        const dz = new Dropzone($dropzone[0], {
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
            if ($current_image.length === 0) {
                $current_image = $("<img class='current' />");
            }
            $current_image.attr('src', url);

            const object_id = resp.object_id;
            let id_input = $editable_image.find('input[type=hidden]');
            if (id_input.length === 0) {
                id_input = $("<input type='hidden'/>").attr('name', form_param).appendTo($editable_image)
            }
            id_input.val(object_id);

            $editable_image.attr('data-object-id', object_id);

            this.moveAwayDropZone();
        });
        dz.on('canceled', (f) => {
            this.moveAwayDropZone();
        });

        this.dz = dz;
        this.$dropzone = $dropzone;
    }

    moveAwayDropZone() {
        this.dz.destroy();
        this.$dropzone.remove();
        this.showButton(true)
    }
}
