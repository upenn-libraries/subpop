# display disabled un/publish book buttons and start polling
$('#publish-book-buttons').html("<%= j render(partial: '/flickr/publish_book_buttons', locals: { book: @book }) %>")
$('#publish-book-buttons').addClass('processing')
$.poll_publish_book_buttons('#publish-book-buttons')

# reload all the images and start polling the ones that are porcessing
$('#publishables-list').html("<%= j render(partial: '/flickr/publishables_list', locals: { publishables: @book.publishables }) %>")
$.poll_all_publishables()