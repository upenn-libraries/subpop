html = "<%= j render(partial: 'flickr/status', locals: { item: @item }) %>"
div_id = '#' + $($.parseHTML(html)).attr('data-parent-div')
$(div_id).html(html)
$(div_id).addClass('processing')
$.poll_publishable(div_id)