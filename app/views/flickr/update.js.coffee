# display disabled un/publish book buttons and start polling
$('#publish-book-buttons').html("<%= j render(partial: '/flickr/publish_book_buttons', locals: { book: @item.book }) %>")
$('#publish-book-buttons').addClass('processing')
$.poll_publish_book_buttons('#publish-book-buttons')

html = "<%= j render(partial: 'flickr/status', locals: { item: @item }) %>"
div_id = '#' + $($.parseHTML(html)).attr('data-parent-div')
$(div_id).html(html)
$(div_id).addClass('processing')
$.poll_publishable(div_id)