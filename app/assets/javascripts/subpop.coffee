$ ->
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

    # Poll a processing job (image derivative generation, publishing to Flickr,
    # removing from Flickr) until done and then call a get. Arguments:
    #
    #    `selector`  for a div; it should have a class of 'processing' while
    #                the processing is occuring; when polling stops the
    #               'processing' class is is removed from the element
    #
    #     `url`      the URL to poll: should return JSON during the polling and then
    #                respond to an http get request takes approprate action to
    #                complete processing; see below for details
    #
    # The `url` should point to a resource that returns a JSON object with a
    # boolean `processing` attribute that returns true as long as processing
    # is running. The same URL should respond to a `$.get`  and return a
    # partial which will replace the content of the <div>.
    #
    # Example:
    #
    #  `selector': `#publishable-evidence-75`
    #
    #  `url`: `'/flickr/status/evidence/75`
    #
    # The status action of the Flickr controller returns both JSON and a partial
    # depending on the AJAX request. JSON is created via `status.jbuilder.coffee`:
    #
    #       json.merge! @item.attributes
    #       json.processing @item.processing?
    #
    # `$.get` is responded to by `status.js.coffee`, which replaces the content of
    # `$.#publishing-<ID>` with un updated status partial:
    #
    #     $('#publishable-' + <%= @item.id %>).html("<%= j \
    #           render(partial: 'flickr/status', locals: { item: @item }) %>")
    #
    # It replaces the content of the <div> with
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

    $('.publishable-status.processing').each ->
        item_id   = $(this).attr('data-item')
        item_type = $(this).attr('data-item-type')
        div_id    = '#' + $(this).attr('id')
        url       = '/flickr/status/' + item_type + '/' + item
        poll_process(url,div_id)

    $.poll_publishable = (div_id) ->
        $div = $(div_id)
        item_id   = $div.attr('data-item')
        item_type = $div.attr('data-item-type')
        url       = '/flickr/status/' + item_type + '/' + item_id
        poll_process(url,div_id)


    # $(document).ready(ready)