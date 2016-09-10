html = "<%= j render(partial: '/thumbnails/show', locals: { parent: @parent, thumbnail: @thumbnail, image_size: :small }) %>"
for container_id in $.thumbnail_container_ids(html)
    do (container_id) ->
        selector = '#' + container_id
        $(selector).html(html)