import 'folders.scss'
class Folder {
    constructor(id) {
        this.id = id;
        this.folder_errors = this._find('.error');
        this._bind();
    }

    _bind() {
        let self = this;
        self._find('[name=create-folder]').click((e) => {
            let folder_name = self._by_name('folder-name').val();
            if (folder_name) {
                $.ajax('/folders', {
                    method: 'POST',
                    dataType: 'html',
                    data: {name: folder_name, parent: self.id}
                }).done((data, status, jq) => {
                    self._by_name('folders-list').replaceWith(data)
                }).fail((jq, status, error) => {
                    console.log(`Status: ${status}, error: ${error}`);
                    console.log(`Response: ${jq.responseJSON}`)
                })
            }
        });
        self._find('.images-list').on('click', '.delete-button', (e)=> {
            const id = $(e.target).closest('[data-scope-id]').attr('data-scope-id');
            if (!id) {
                return
            }
            $.ajax(`/ext_images/${id}`, {
                method: 'DELETE',
                dataType: 'json'
            }).done((data,st,jq)=> {
                if (data.result == 0) {
                    let to_remove = $(e.target).closest('.image_preview_row');
                    to_remove.parent().append($('<span/>').addClass('text-danger').text('Moved to Trash'));
                    to_remove.remove();
                } else {
                    console.log('Failed to delete image' + id)
                }
            })
        })
    }

    _find(selector) {
        return $('body').find(selector)
    }

    _by_name(name) {
        return this._find(`[name=${name}]`);
    }
}

const folder = { current: null }

$(document).on('turbolinks:load', ()=> {

    if ($('body').attr('data-scope') === 'folders') {
        let f = new Folder($('input[name=scope-object]').val());
        console.log(`Folder found for ${f.id}`);
        folder.current = f;
    }
});


export {folder};
