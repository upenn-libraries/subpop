ready = ->

    $(document).on 'click', 'a[disabled="disabled"]', (event) ->
        event.preventDefault()

    $(document).on 'click', '.modal-link', (event) ->
        $.get $(this).attr("href"), (data) ->
            $('#preview-modal-body').html($(data))
            $('#preview-modal').modal('show')

    $('[data-toggle="tooltip"]').tooltip()

$(document).ready(ready)