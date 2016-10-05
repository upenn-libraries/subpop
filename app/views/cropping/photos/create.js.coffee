html = "<%= j render(partial: 'photos/small_photo', locals: { item: @parent }) %>"
div_id = '#' + $($.parseHTML(html)).attr('data-parent-div')
$.replace_html div_id, html