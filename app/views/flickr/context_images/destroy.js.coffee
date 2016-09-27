# display disabled un/publish book buttons and start polling
$('#publish-book-buttons').html("<%= j render(partial: '/flickr/books/publish_buttons', locals: { book: @item.book }) %>")
$('#publish-book-buttons').addClass('processing')
$.poll_publish_buttons('#publish-book-buttons')

html = "<%= j render(partial: 'flickr/status', locals: { item: @item }) %>"
div_id = '#' + $($.parseHTML(html)).attr('data-parent-div')
$.replace_html div_id, html
$(div_id).addClass('processing')
$.poll_publishable(div_id)