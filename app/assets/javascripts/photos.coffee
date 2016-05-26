jQuery ->
    $(document).on 'submit', 'form:has(select.image-use)', (event) ->
        if $(this).find('select.image-use').val() is ''
            alert('Please select a use for the image')
            false

    $(document).on 'change', 'select.image-use', (event) ->
        book_id = $(this.form).find("input[name='book_id']").val()
        photo_id = $(this.form).find("input[name='photo_id']").val()

        $(this.form).find('input[name="evidence[photo_id]"]').remove()
        $(this.form).find('input[name="evidence[book_id]"]').remove()
        $(this.form).find('input[name="evidence[format]"]').remove()
        $(this.form).find('input[name="photo[in_queue]"]').remove()


        if $(this).val() == 'title_page'
            # /books/4/add_title_page/9
            $(this.form).attr('action', '/books/' + book_id + '/add_title_page/' + photo_id)
            $(this.form).attr('method', 'post')
            $(this.form).attr('data-remote', false)
            $(this.form).submit()
        else if $(this).val() == 'unqueue'
            $(this.form).attr('action', '/books/' + book_id + '/photos/' + photo_id)
            $(this.form).attr('data-remote', true)
            $(this.form).attr('method', 'patch')
            $(this.form).append('<input type="hidden" name="photo[in_queue]" value="' + false + '">')
            $(this.form).submit()
        else
            $(this.form).attr('action', '/books/' + book_id + '/evidence/new')
            $(this.form).attr('method', 'get')
            $(this.form).attr('data-remote', false)
            $(this.form).append('<input type="hidden" name="evidence[photo_id]" value="' + photo_id + '">')
            $(this.form).append('<input type="hidden" name="evidence[book_id]" value="' + book_id + '">')
            $(this.form).append('<input type="hidden" name="evidence[format]" value="' + $(this).val() + '">')
            $(this.form).submit()

    stop_polling_image = (interval,selector) ->
        $(selector).removeClass('processing')
        clearInterval(interval)

    $('.queued-photo.processing').each ->
        book_id  = $(this).attr('data-book')
        photo_id = $(this).attr('data-photo')
        div_id   = '#queued-photo-' + photo_id
        count = 0
        url = '/books/' + book_id + '/photos/' + photo_id
        interval = setInterval(
            -> (
                $.ajax (
                    url: url
                    dataType: 'json'
                    success: (data, status, jqXHR) ->
                        count += 1
                        if not data.image_processing
                            $.get(url)
                            stop_polling_image(interval,div_id)
                        # break after sixty tries
                        if count > 60
                            alert("Image processing never finished for photo: " + photo_id)
                            stop_polling_image(interval,div_id)
                        return
                    error: (jqXHR, status, error) ->
                        alert("Unexpected error: " + error)
                        stop_polling_image(interval,div_id)
                        return
                    )
                )
            1000)
        undefined
