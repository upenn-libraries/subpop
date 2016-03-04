ready = ->
    show_hide_page_number = ->
        if $('select#evidence_location_in_book')
            location_code = $('select#evidence_location_in_book').val()
            if location_code == 'page_number'
                $('#evidence_location_in_book_page').closest('div.form-group').show(1000)
            else
                $('#evidence_location_in_book_page').closest('div.form-group').hide()

    show_hide_format_other = ->
        if $('select#evidence_format')
            format_code = $('select#evidence_format').val()
            if format_code == 'other'
                $('#evidence_format_other').closest('div.form-group').show(1000)
            else
                $('#evidence_format_other').closest('div.form-group').hide()

    manage_other_format = ->
        # if needed, clear format_other
        unless $('#evidence_format').val() == 'other'
            $('#evidence_format_other').val('')

    $('#evidence_location_in_book').change ->
        show_hide_page_number()

    $('#evidence_format').change ->
        show_hide_format_other()

    $(document.body).on 'click', '.remove_fields', (event) ->
        $(this).prev('input[type=hidden]').val('1')
        $(this).closest('fieldset').hide()
        event.preventDefault()

    $(document.body).on 'click', '.add_fields', (event) ->
        time = new Date().getTime()
        regexp = new RegExp($(this).data('id'), 'g')
        $(this).before($(this).data('fields').replace(regexp, time))
        event.preventDefault()

    $('form').on 'submit', (event) ->
        manage_other_format()

    show_hide_page_number()
    show_hide_format_other()

$(document).ready(ready)
