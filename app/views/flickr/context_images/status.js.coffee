html = "<%= j render(partial: 'flickr/status', locals: { item: @item }) %>"
div_id = '#' + $($.parseHTML(html)).attr('data-parent-div')
$(div_id).html(html)