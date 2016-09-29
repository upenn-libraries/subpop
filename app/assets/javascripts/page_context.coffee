$ ->
    $(document).on 'replaced.html.subpop', '.thumb-container', ->
        $thumb = $(this).find '.thumb'
        if $thumb.attr('data-parent-type') is 'evidence'
            if $thumb.attr('data-parent') is 'new'
                derivative_id = $thumb.attr('data-thumbnail')
                url = '/page_context/find/' + derivative_id + '.js'
            else
                url = '/page_context/' + $thumb.attr('data-parent') + '.js'
            $.get url

    $(document).on 'submit', 'form#link_to_context_image', (event) ->
        $(this).closest('.modal').modal('hide')
        return true