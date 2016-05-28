$('#publishables-list').html("<%= j render(partial: '/flickr/publishables_list', locals: { publishables: @book.publishables }) %>")
$.poll_all_publishables()