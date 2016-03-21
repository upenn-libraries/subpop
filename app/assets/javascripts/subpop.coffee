ready = ->
    $('a[disabled=disabled]').on 'click', (event) =>
        event.preventDefault()
        return false

    $('.modal-link').on 'click', (event) ->
        $.get $(this).attr("href"), (data) ->
            $('#preview-modal-body').html($(data))
            $('#preview-modal').modal('show')

    $('[data-toggle="tooltip"]').tooltip()

$(document).ready(ready)