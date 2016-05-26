ready = ->

    $(document).on 'click', 'a[disabled="disabled"]', (event) ->
        event.preventDefault()

    $(document).on 'click', '.modal-link', (event) ->
        $.get $(this).attr("href"), (data) ->
            $('#preview-modal-body').html($(data))
            $('#preview-modal').modal('show')

    $('[data-toggle="tooltip"]').tooltip()

    stop_polling_process = (interval,selector) ->
        $(selector).removeClass('processing')
        clearInterval(interval)

    poll_process = (url,selector) ->
        count = 0
        interval = setInterval(
            -> (
                $.ajax (
                    url: url
                    dataType: 'json'
                    success: (data, status, jqXHR) ->
                        count += 1
                        if not data.processing
                            $.get(url)
                            stop_polling_process(interval,selector)
                        # break after sixty tries
                        if count > 60
                            alert("Image processing never finished for: " + url)
                            stop_polling_process(interval,selector)
                        return
                    error: (jqXHR, status, error) ->
                        alert("Unexpected error: " + error)
                        stop_polling_process(interval,selector)
                        return
                    )
                )
            1000)
        return

    $('.queued-photo.processing').each ->
        book_id  = $(this).attr('data-book')
        photo_id = $(this).attr('data-photo')
        div_id   = '#queued-photo-' + photo_id
        url      = '/books/' + book_id + '/photos/' + photo_id
        poll_process(url,div_id)

$(document).ready(ready)