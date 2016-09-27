html = "<%= j render(partial: 'flickr/status', locals: { item: @item }) %>"
div_id = '#' + $($.parseHTML(html)).attr('data-parent-div')
$.replace_html div_id, html