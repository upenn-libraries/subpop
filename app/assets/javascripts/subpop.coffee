$ ->
    $(document).on 'click', 'a[disabled="disabled"]', (event) ->
        event.preventDefault()


    $(document).on 'click', '.modal-link', (event) ->
        modal_id = $(this).attr('data-modal-id')
        modal_body_id = modal_id + '-body'
        $.get $(this).attr("href"), (data) ->
            $('#' + modal_body_id).html($(data))
            if (/cropper/i).test(modal_id)
                $('#image').hide()
            # Restoring modal('show') to callback. This is not now causing
            # dubplicate events. Sadly, I haven't figured out the reason for
            # the change to the desired behavior. Note that if duplicate
            # events return, then the cause will need to be investigated.
            $('#' + modal_id).modal('show')


    $(document).on 'submit', 'form#link_to_context_image', (event) ->
        $(this).closest('.modal').modal('hide')
        return true

    $(document).on 'subpop.processing', '.thumb-container', ->
        $thumb = $(this).find '.thumb'




    $('[data-toggle="tooltip"]').tooltip(container: 'body', trigger: 'hover')

    $(document).on 'click', 'a', (event) ->
        $(this).tooltip('hide')

    stop_polling_process = (interval,url,selector) ->
        $(selector).removeClass('processing')
        clearInterval(interval)
        delete $.polled_urls[url] unless $.polled_urls is undefined
        $(selector).trigger 'subpop.processed'

    is_polling_url = (url) ->
        return false if $.polled_urls is undefined
        $.polled_urls[url] is true

    mark_url_polled = (url) ->
        $.polled_urls = {} if $.polled_urls is undefined
        $.polled_urls[url] = true

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
        # Don't run if we're already polling this url.
        return if is_polling_url(url)
        # mark this url as being polled
        mark_url_polled url
        delay           = 1000 # milliseconds
        timeout_seconds = 1000
        max_intervals   = (delay * 1000) / timeout_seconds

        $(selector).trigger 'subpop.processing'

        count = 0
        interval = setInterval(
            -> (
                $.ajax (
                    url: url + '.json'
                    dataType: 'json'
                    success: (data, status, jqXHR) ->
                        count += 1
                        if not data.processing
                            $.get(url)
                            stop_polling_process(interval,url,selector)
                        # break after sixty tries
                        if count > max_intervals
                            alert("Image processing never finished for: " + url)
                            stop_polling_process(interval,url,selector)
                        return
                    error: (jqXHR, status, error) ->
                        alert("Unexpected error: " + error)
                        stop_polling_process(interval,url,selector)
                        return
                    )
                )
            delay)
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
        url       = '/flickr/' + item_type + '/' + item_id + '/status'
        poll_process(url,div_id)

    $.poll_publishable = (div_id) ->
        $div = $(div_id)
        item_id   = $div.attr('data-item')
        item_type = $div.attr('data-item-type')
        url       = '/flickr/' + item_type + '/' + item_id + '/status'
        poll_process(url,div_id)

    $.poll_thumbnail = (div_id) ->
        $div         = $(div_id).find('.thumb')
        parent_type  = $div.attr('data-parent-type')
        parent_id    = $div.attr('data-parent')
        thumbnail_id = $div.attr('data-thumbnail')
        url          = '/' + parent_type + '/' + parent_id + '/thumbnails/' + thumbnail_id
        poll_process(url,div_id)

    $.poll_all_publishables = ->
        $('.publishable-status.processing').each ->
            item_id   = $(this).attr('data-item')
            item_type = $(this).attr('data-item-type')
            div_id    = '#' + $(this).attr('id')
            url       = '/flickr/' + item_type + '/' + item_id + '/status'
            poll_process(url,div_id)

    $.poll_publish_buttons = (div_id) ->
        if $(div_id).hasClass('processing')
            book_id = $(div_id).attr('data-book')
            url = '/flickr/books/' + book_id + '/status'
            poll_process(url,div_id)

    # If there's a new Publishable form (form#new_evidence, etd.) on the page,
    # we have to change the photo_id (input#evidence_photo_id, etc.). This
    # will probably only ever Evidence, but we make the code general.
    #
    # Note that edited Publishables already have an assigned photo, so there's
    # no photo_id form field to update.
    $.update_new_publishable_form = (thumb_html) ->
        possible_ids    = [
            'new_evidence', 'new_title_page', 'new_context_image'
        ]

        form_id = null
        for id in possible_ids
            do (id) ->
                s = 'form#' + id
                # alert($(s)[0].outerHTML)
                if $('form#' + id).length
                    form_id = id

        # return unless we have a new publishable form
        return unless form_id?

        $thumb_div      = $($.parseHTML(thumb_html))
        source_photo_id = $thumb_div.attr('data-source-photo')
        thumbnail_id    = $thumb_div.attr('data-thumbnail')

        # nothing to change if no source photo, or photo == source photo
        return unless source_photo_id?
        return if source_photo_id is thumbnail_id

        parent_name     = form_id.replace(/^new_/, '')
        $("form##{form_id} input##{parent_name}_photo_id").val(thumbnail_id)

    $.thumb_container_ids = (html, inner_klass) ->
        $new_div        = $($.parseHTML(html))
        parent_type     = $new_div.attr('data-parent-type')
        parent_id       = $new_div.attr('data-parent')
        source_photo_id = $new_div.attr('data-source-photo')
        thumbnail_id    = $new_div.attr('data-thumbnail')

        thumbnail_id    = source_photo_id if source_photo_id

        selector        = inner_klass
        selector        = '.' + selector unless selector.match(/^\./)
        container_sel   = selector + '-container'
        selector       += "[data-parent-type=#{parent_type}]"
        selector       += "[data-parent=#{parent_id}]"
        selector       += "[data-thumbnail=#{thumbnail_id}]"
        divs            = $(selector).closest(container_sel)
        $(div).attr('id') for div in divs

    $.set_unique_ids = ->
        $('.thumb-container').uniqueId()
        $('.edit-photo-container').uniqueId()

    $.set_unique_ids()

    # $(document).ready(ready)