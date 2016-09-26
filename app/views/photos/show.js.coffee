queued_photo_id = '#queued-photo-' + <%= @photo.id %>
$(queued_photo_id).html("<%= j render(partial: 'photos/queued_photo', locals: { photo: @photo, book: @book }) %>")
$.set_unique_ids()