html = "<%= j render(partial: 'photos/small_photo', locals: { item: @parent }) %>"
div_id = '#' + $($.parseHTML(html)).attr('data-parent-div')
$(div_id).html(html)