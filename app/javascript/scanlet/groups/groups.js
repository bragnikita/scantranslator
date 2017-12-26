// import ImageUploaders from 'common/upload/multiple_images_upload';
import ImageUploaders from "../../common/upload/multiple_images_upload";

$(document).on('turbolinks:load', function () {
    'use strict';
    const scope = $('[data-scope=scanlet-groups-edit]');
    if (scope.length === 0)
        return;

    const group_id = scope.find('input[name=group_id]').val();

    let dialog = ImageUploaders.multiple_images_dialog({title: 'My image uploaders'})
    dialog.on('apply', (e, uploads) => {
        let url = '/scanlet/translations';
        $.ajax(url, {
            method: 'POST',
            data: {
                group_id: group_id,
                image_ids: _.map(uploads, (upload) => {
                    return upload.image_id
                })
            },
            dataType: 'json'
        }).done((data, status) => {
            let url = `/scanlet/groups/${group_id}/translations?view=pages`;
            $.get(url).done((data, status) => {
                scope.find('.images_list').html(data)
            })
        });

    });


});