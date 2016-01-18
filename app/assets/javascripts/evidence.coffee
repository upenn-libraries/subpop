ready = ->
    show_hide_page_number = ->
        if $('select#evidence_location_in_book')
            location_code = $('select#evidence_location_in_book').val()
            if location_code == 'page_number'
                $('#evidence_location_in_book_page').closest('div.form-group').show(1000)
            else
                $('#evidence_location_in_book_page').closest('div.form-group').hide()

    $('#evidence_location_in_book').change ->
        show_hide_page_number()

    $(document.body).on 'click', '.remove_fields', (event) ->
        $(this).prev('input[type=hidden]').val('1')
        $(this).closest('fieldset').hide()
        event.preventDefault()

    $(document.body).on 'click', '.add_fields', (event) ->
        time = new Date().getTime()
        regexp = new RegExp($(this).data('id'), 'g')
        $(this).before($(this).data('fields').replace(regexp, time))
        event.preventDefault()

    show_hide_page_number()

$(document).ready(ready)
