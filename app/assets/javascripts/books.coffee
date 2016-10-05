$ ->
    $(document).on 'change', 'form#filter_by_user select', (event) ->
        $(this).closest('form').submit()