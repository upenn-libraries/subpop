$ ->
    #--------------------------------------------------------------------------
    # Global functions
    #--------------------------------------------------------------------------
    ###

    Function to set unique IDs on `.thumb-container` and `.edit-photo-
    container` divs.

    ###
    $.set_unique_ids = ->
        $('.thumb-container').uniqueId()
        $('.edit-photo-container').uniqueId()

    ###
    ---------------------------------------------------------------------------
    # EVENTS                                                                  #
    ---------------------------------------------------------------------------

    Fire `event` on `selector`.

    There are three custom events:

        `processing.subpop`    - fired on `selector` when polling/processing
                                 begins

        `processed.subpop`     - fired on `selector` at the end of
                                 `stop_polling_process`

        `replaced.html.subpop` - should be fired when the content of a div is
                                 replaced

    ###
    $.fire_subpop_event = (selector, event_name) ->
        $(selector).trigger event_name

    ###

    Replace html of `selector` with `html` and fire the `replaced.html.subpop`
    event.

    ###
    $.replace_html = (selector, html) ->
        $(selector).html(html)
        $.fire_subpop_event selector, 'replaced.html.subpop'

    #--------------------------------------------------------------------------
    # Miscellaneous
    #--------------------------------------------------------------------------
    $(document).on 'click', 'a[disabled="disabled"]', (event) ->
        event.preventDefault()

    $(document).on 'click', 'a', (event) ->
        $(this).tooltip('hide')

    $('[data-toggle="tooltip"]').tooltip(container: 'body', trigger: 'hover')

    #--------------------------------------------------------------------------
    # Modals
    #--------------------------------------------------------------------------
    $(document).on 'click', '.modal-link', (event) ->
        modal_id = $(this).attr('data-modal-id')
        modal_body_id = modal_id + '-body'
        $.get $(this).attr("href"), (data) ->
            $('#' + modal_body_id).html($(data))
            if (/cropper/i).test(modal_id)
                $('#image').hide()
            # Returning modal('show') to callback. This is not now causing
            # dubplicate events. Sadly, I haven't figured out the reason for
            # the change to the desired behavior. Note that if duplicate
            # events return, then the cause will need to be investigated.
            $('#' + modal_id).modal('show')

    # In modals, have links with 'dismiss-modal' dismiss the modal on click
    # event; that is, override default 'Cancel' behavior that would normally
    # just load the page that already lies behind the modal.
    $(document).on 'shown.bs.modal', '.modal', (event) ->
        $(this).find('.dismiss-modal').attr('data-dismiss', 'modal')

    ###
    #--------------------------------------------------------------------------
    # Polling
    #--------------------------------------------------------------------------

    Functions to handle page display for long running backgroupd jobs, like
    the generation of image derivatives and jobs that that interact with the
    Flickr API. See the documentation for `poll_process` for details.
    ###

    ###
    -- stop_polling_process
    When invoked:

      - removes 'processing' class from 'selector',
      - clears the interval,
      - deletes 'url' from the $.polled_urls array
      - fires the 'processed.subpop' event on 'selector'

    ###
    stop_polling_process = (interval,url,selector) ->
        $(selector).removeClass('processing')
        clearInterval(interval)
        delete $.polled_urls[url] unless $.polled_urls is undefined
        $.fire_subpop_event selector, 'processed.subpop'

    is_polling_url = (url) ->
        return false if $.polled_urls is undefined
        $.polled_urls[url] is true

    mark_url_polled = (url) ->
        $.polled_urls = {} if $.polled_urls is undefined
        $.polled_urls[url] = true

    ###

    Poll a processing job (image derivative generation, publishing to Flickr,
    removing from Flickr) until done and then call a get. Arguments:

       `selector`  for a div; it should have a class of 'processing' while
                   the processing is occuring; when polling stops the
                  'processing' class is is removed from the element

        `url`      the URL to poll: should return JSON during the polling and then
                   respond to an http get request takes approprate action to
                   complete processing; see below for details

    The `url` should point to a resource that returns a JSON object with a
    boolean `processing` attribute that returns true as long as processing is
    running. The same URL should respond to a `$.get`  and return a partial
    which will replace the content of the <div>.

    Example:

     `selector': `publishable-evidence-75`

     `url`: `'/flickr/status/evidence/75`

    The status action of the Flickr controller returns both JSON and a partial
    depending on the AJAX request. JSON is created via `status.jbuilder.coffee`:

          json.merge! @item.attributes
          json.processing @item.processing?

    `$.get` is responded to by `status.js.coffee`, which replaces the content
    of publishing-<ID>` with un updated status partial:

        $('publishable-' + <%= @item.id %>).html("<%= j \
              render(partial: 'flickr/status', locals: { item: @item }) %>")

    Note that all polled `url`s are added to the  list of polled URL's
    (`$.polled_urls`). Before polling begins, this list is checked. Polling is
    not started on any `url` already in the list.

    ###
    poll_process = (url,selector) ->
        # Don't run if we're already polling this url.
        return if is_polling_url(url)
        # mark this url as being polled
        mark_url_polled url
        delay           = 1000 # milliseconds
        timeout_seconds = 1000
        max_intervals   = (delay * 1000) / timeout_seconds

        $.fire_subpop_event(selector, 'processing.subpop')

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

    ###
    #--------------------------------------------------------------------------
    # Content specific polling functions
    #--------------------------------------------------------------------------

    These global functions commence polling for specific types of content.
    They are made global so that they can be called from external js code
    (especially `<action>.js` files returned by various controllers).

    ###
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

    ###

    If there's a new Publishable form (formnew_evidence, etd.) on the page,
    we have to change the photo_id (inputevidence_photo_id, etc.). This
    will probably only ever apply to Evidence, but we make the code general.

    Note that edited Publishables already have an assigned photo, so there's
    no photo_id form field to update.

    ###
    $.update_new_publishable_form = (thumb_html) ->
        possible_ids    = [
            'new_evidence', 'new_title_page', 'new_context_image'
        ]

        form_id = null
        for id in possible_ids
            do (id) ->
                s = 'form#' + id
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

    ###

    Return an array of IDs for thumbnail-related div `*-container` IDs in
    order to replace the divs' content dynamically.

    For example:

    <div class="thumbnail">
      <div class="thumb-container" id="ui-id-1">
        <div class="thumb" data-parent="23" data-parent-type="evidence" data-thumbnail="190">
          <a target="_blank" data-toggle="tooltip" rel="noopener noreferrer"
              title="Click to open in new window."
              href="/system/development/photos/images/000/000/190/original/BS_185_178204.jpg?1474661760">
            <img class="img-responsive center-block"
                src="/system/development/photos/images/000/000/190/small/BS_185_178204.jpg?1474661760"
                alt="Bs 185 178204" />
          </a>
        </div> <!-- /.thumb -->
      </div> <!-- /.thumb-container -->
    <div> <!-- /.thumbnail -->

    The `inner_klass` is used to find the container by its class by appending
    `-container`. At present there are two types of containers: `div.thumb-
    container` with a nested `div.thumb`, and similarly nested `div.edit-
    photo-container` and `div.edit-photo`.

    When a thumbnail image is replaced by a new one, the corresponding `edit-
    photo` link is updated with the new photo ID.

    The container div is located by finding the *existing* inner `div.thumb`
    or `div .edit-photo` using the values provided by the *new* incoming `div`
    in the `html` argument.

    The incoming attributes are:

    - `data-parent-type`   - `book`, `evidence`, `title-page`

    - `data-parent`        - ID of the parent object, a number or `new` for
                             a newly created evidence record

    - `data-source-photo`  - used only for a new image, the ID of the source
                             thumbnail

    - `data-thumbnail`     - ID of the incoming thumbnail

    The selector for the existing div uses these attributes: `data-parent-
    type`, `data-parent`, `data-thumbnai`.

    ###
    $.thumb_container_ids = (html, inner_klass) ->
        $new_div        = $($.parseHTML(html))
        parent_type     = $new_div.attr('data-parent-type')
        parent_id       = $new_div.attr('data-parent')
        source_photo_id = $new_div.attr('data-source-photo')
        thumbnail_id    = $new_div.attr('data-thumbnail')

        thumbnail_id    = source_photo_id if source_photo_id

        selector        = inner_klass
        selector        = '.' + selector unless selector.match(/^\./)
        selector       += "[data-parent-type=#{parent_type}]"
        selector       += "[data-parent=#{parent_id}]"
        selector       += "[data-thumbnail=#{thumbnail_id}]"

        container_sel   = inner_klass + '-container'
        container_sel   = '.' + container_sel unless container_sel.match(/^\./)
        divs            = $(selector).closest(container_sel)
        $(div).attr('id') for div in divs

    ###

    On page load, start displaying processing details for any queud photo
    being processed.

    ###
    $('.queued-photo.processing').each ->
        book_id  = $(this).attr('data-book')
        photo_id = $(this).attr('data-photo')
        div_id   = '#queued-photo-' + photo_id
        url      = '/books/' + book_id + '/photos/' + photo_id
        # alert('Polling ' + url + ',' + div_id)
        poll_process(url,div_id)


    ###

    On page load, start displaying processing details for any publishable
    being processed.

    ###
    $('.publishable-status.processing').each ->
        item_id   = $(this).attr('data-item')
        item_type = $(this).attr('data-item-type')
        div_id    = '#' + $(this).attr('id')
        url       = '/flickr/' + item_type + '/' + item_id + '/status'
        poll_process(url,div_id)

    # On page load, set unique IDs
    $.set_unique_ids()
