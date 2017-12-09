import './context-forms.scss'

export default class ContextForm {

    constructor(form_selector) {
        this.form = form_selector;
        this.$form = $(form_selector);
        this.components = [];
    }

    initComponents() {
        this.components = [];
        this.$form.find('[data-editable=true]').each((index, component) => {
            this.components.push(new EditableComponent(component));
            console.log(component, 'registred')
        })

    }

}

class EditableComponent {

    constructor(component) {
        let $component = $(component);
        $component.addClass('editable-component');
        const $editor = $component.find('[data-display]');
        if ($editor.length == 0)
            return;
        const $presenter = $component.find($editor.data('display'));

        this.$component = $component;
        this.$editor = $editor;
        this.$presenter = $presenter;

        let btn = $component.find('.btn-editable-edit');
        if (btn.length == 0) {
            btn = $("<div/>").addClass('btn-editable-edit fa fa-pencil-square-o');
            $component.append(btn)
        }
        this.$btn = btn;
        btn.click(this.edit.bind(this));

        $editor.hide();
        $editor.blur(this.commit.bind(this));


    }

    edit() {
        this.$btn.addClass('hidden');
        if (this.$presenter) {
            this.$presenter.hide();
            let value = this.$presenter.text();
            if (this.$editor.is('textarea')) {
                this.$editor.text(value);
            } else {
                this.$editor.val(value);
            }
        }
        this.$editor.show().focus();
    }

    commit() {
        if (this.$presenter) {
            let value = this.$editor.val() || this.$editor.text();
            this.$presenter.text(value);
        }
        this.display();
    }

    cancel() {
        this.display();
    }

    display() {
        this.$btn.removeClass('hidden');
        this.$editor.hide();
        this.$presenter.show();
    }

}