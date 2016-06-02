# redisplay un/publish book buttons
$('#publish-book-buttons').html("<%= j render(partial: '/flickr/publish_book_buttons', locals: { book: @book }) %>")
# redisplay list of publishables
$('#publishables-list').html("<%= j render(partial: '/flickr/publishables_list', locals: { publishables: @book.publishables }) %>")
# resplay the photo queue
$('#photo-queue').html("<%= j render(partial: 'photos/index', locals: { book: @book, photos: @book.queued_photos }) %>")
# reload the title page sidebar div
$('#title-pages').html("<%= j render(partial: '/books/small_title_page_photos', locals: { book: @book }) %>")
