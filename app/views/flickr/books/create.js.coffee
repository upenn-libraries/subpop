# display disabled un/publish book buttons and start polling
$('#publish-book-buttons').html("<%= j render(partial: '/flickr/books/publish_buttons', locals: { book: @item }) %>")
$('#publish-book-buttons').addClass('processing')
$.poll_publish_buttons('#publish-book-buttons')

# reload all the images and start polling the ones that are processing
$('#publishables-list').html("<%= j render(partial: '/flickr/publishables_list', locals: { publishables: @item.publishables }) %>")
$.poll_all_publishables()