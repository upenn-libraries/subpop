# redisplay un/publish book buttons
$('#publish-book-buttons').html("<%= j render(partial: '/flickr/books/publish_buttons', locals: { book: @book }) %>")
# redisplay the list of publishables
$('#publishables-list').html("<%= j render(partial: '/flickr/publishables_list', locals: { publishables: @book.publishables }) %>")
# resplay the photo queue
$('#photo-queue').html("<%= j render(partial: 'photos/index', locals: { book: @book, photos: @book.queued_photos }) %>")
