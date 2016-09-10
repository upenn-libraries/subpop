html = "<%= j render(partial: '/thumbnails/show', locals: { parent: @parent, thumbnail: @thumbnail, source_photo: @source_photo, image_size: :small }) %>"
# in case there is a new Evidence, TitlePage, ContextImage, correct it
$.update_new_publishable_form(html)

for container_id in $.thumbnail_container_ids(html)
    do (container_id) ->
        selector = '#' + container_id
        $(selector).attr('data-thumbnail', <%= @thumbnail.id %>)
        $(selector).html(html)
        $(selector).addClass('processing')
        $.poll_thumbnail(selector)