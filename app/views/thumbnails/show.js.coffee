html = "<%= j render(partial: '/thumbnails/show', locals: { parent: @parent, thumbnail: @thumbnail, source_photo: @source_photo, image_size: :small }) %>"
# in case there is a new Evidence, TitlePage, ContextImage, correct it
$.update_new_publishable_form(html)

for container_id in $.thumb_container_ids(html, 'thumb')
    do (container_id) ->
        selector = '#' + container_id
        $(selector).html(html)
        $.fire_subpop_event selector, html