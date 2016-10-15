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

    manage_location_in_book_page = ->
        # if needed, clear location_in_book_page
        unless $('#evidence_location_in_book').val() == 'page_number'
            $('#evidence_location_in_book_page').val('')

    show_flash = (type,message) ->
        params = $.param({ type: type, message: message })
        url = '/flash/show?' + params
        $.get url

    # add the error explanation to the given $div
    add_error_div = ($div, data) ->
        if data.errors
            # build and add the error count
            $alert_div = $('<div class="error_explanation"></div>')
                .append('<div class="alert alert-danger"></div>')
            $alert_div
            .find('.alert')
            .html(data.error_count_message)

            # add each error message
            $alert_div
            .append('<ul></ul>')
            $.each(data.error_messages, (idx, msg) ->
                $alert_div.find('ul')
                .append("<li>" + msg)
                )

            $div.append($alert_div)

    tag_error_inputs = (selector, model, errors) ->
        $.each errors, (field) ->
            input_id = model + '_' + field

            # wrap each input and associate label
            $(selector)
            .find('#' + input_id)
            .wrap('<div class="field_with_errors"></div>')
            .closest('.form-group')
            .find('label[for="' + input_id + '"]')
            .wrap('<div class="field_with_errors"></div>')

    clear_errors = (selector) ->
        # clear the error-div in the selector's scope
        $(selector).find('.error-div').empty()
        # remove every div.field_with_errors
        $(selector).find('.field_with_errors').children().unwrap()


    $('#evidence_location_in_book').change ->
        show_hide_page_number()

    $('#evidence_format').change ->
        show_hide_format_other()

    ### $(document.body).on 'click', '.remove-fields', (event)

    We assume that the clicked element is contained by a 'fieldset' unless the
    'data-parent-css-class' attribute has been set. 'data-parent-css-class' if provided MUST NOT have a prefixed '.'

    ###
    $(document.body).on 'click', '.remove-fields', (event) ->
        if $(this).attr('data-field-container-class')
            parent_selector = '.' + $(this).attr('data-field-container-class')
        else
            parent_selector = 'fieldset'

        $(this).closest(parent_selector).find('input[name$="[_destroy]"]').val('1')
        $(this).closest(parent_selector).hide()
        event.preventDefault()

    $(document.body).on 'click', '.add_fields', (event) ->
        time = new Date().getTime()
        regexp = new RegExp($(this).data('id'), 'g')
        $(this).before($(this).data('fields').replace(regexp, time))
        event.preventDefault()

    set_searching_feedback = (searchField, nameField) ->
        # At present, we're only using searchField, but accept nameField for
        # consistency and parallelism with `set_name_selected_feedback`. We
        # may want to do something with nameField later.
        $.remove_feedback searchField
        $.set_feedback searchField, 'warning', 'warning-sign'
        $.set_help_block searchField, 'WARNING: No name selected. Please select or create a name.'

    set_name_selected_feedback = (searchField, nameField) ->
        $.remove_feedback searchField
        $.set_feedback nameField, 'success', 'ok'
        $.remove_help_block searchField

    $(document.body).on 'keydown', '.name-search', ->
        $(this).autocomplete
            source: '/names'
            response: (event, ui) ->
                # There may be a better way to get this, but the 'term' property
                # is on the request obect, which we don't have access to here.
                searchField = $(this)
                searchTerm = searchField.val()
                nameField = $(searchField.attr('data-display-element'))
                exactMatch = false

                set_searching_feedback searchField, nameField

                # Add a "Create: <searchTerm>" option if the term isn't in the
                # returned list of names
                for item in ui.content
                    if !exactMatch
                        exactMatch = item.label.toLowerCase() == searchTerm.toLowerCase()
                if !exactMatch
                    ui.content.unshift({
                        label: "\u00BB Create: '" + searchTerm + "'",
                        value: 'CREATE',
                        id: 'CREATE'
                        });

            select: (event, ui) ->
                event.preventDefault()
                searchField = $(this)
                idField     = $($(this).attr('data-id-element'))
                nameField   = $($(this).attr('data-display-element'))
                if (ui.item.value == 'CREATE')
                    # Grab the new name the user has entered in the search box
                    newName = ui.item.label.substring(ui.item.label.indexOf("'") + 1, ui.item.label.lastIndexOf("'"))
                    # retrieve the new/names partial and set the modal content with it;
                    # set the name input to the newName
                    $.get '/names/new', (data) ->
                        $('#name-modal-body').html($(data))
                        $('#name_name').val(newName)
                        $('#name-modal').modal('show')
                        $('#name-modal #new_name').submit ->
                            clear_errors('#name-modal')
                            # don't submit the form, use ajax
                            $.ajax(
                                url: $(this).attr('action')
                                type: 'POST'
                                data: $(this).serialize()
                                dataType: 'json'
                                success:  (data, status, jqXHR) ->
                                    # new name was created, set the ID field and the name field
                                    # for the provenance agent
                                    if idField
                                        idField.val(data.id)
                                    searchField.val(data.name)
                                    show_flash('success', 'Created name: ' + data.name)
                                    nameField.val(data.name)
                                    set_name_selected_feedback searchField, nameField
                                    $('#name-modal').modal('hide')
                                error: (data, status, jqXHR) ->
                                    if data.status == 422
                                        json = data.responseJSON
                                        # 422: error saving the name, display the error messages
                                        add_error_div($('#name-modal .error-div'), json.name)
                                        tag_error_inputs('#name-modal #new_name', json.name.model, json.name.errors)
                                    else
                                        alert("Unexpected error: " + status)
                                )
                            false
                else
                    idField.val(ui.item.value)
                    $(this).val(ui.item.label)
                    nameField.val(ui.item.label)
                    set_name_selected_feedback this, nameField
            focus: (event, ui) ->
                event.preventDefault()

    $(document.body).on 'shown.bs.modal', '.modal', ->
        $(this).find("[autofocus]:first").focus()

    $('#evidence_content_type_ids').multiselect()

    $(document).on 'change', '#evidence_format', (event) ->
        $('#evidence-format-heading').text($('#evidence_format option:selected').text())

    $('form#new_evidence, form[id^=edit_evidence]').on 'submit', (event) ->
        manage_other_format()
        manage_location_in_book_page()

    show_hide_page_number()
    show_hide_format_other()

$(document).ready(ready)