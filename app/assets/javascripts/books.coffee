jQuery ->
    $('select.image-use').change ->
        $(this.form).find("input[name='format']").val($(this).val())
        book_id = $(this.form).find("input[name='book_id']").val()
        photo_id = $(this.form).find("input[name='photo_id']").val()

        if $(this).val() == 'title_page'
            # /books/4/add_title_page/9
            $(this.form).attr('action', '/books/' + book_id + '/add_title_page/' + photo_id)
        else
            $(this.form).append('<input type="hidden" name="evidence[photo_id]">')
            $(this.form).attr('action', '/books/' + book_id + '/evidence/new')
            $(this.form).attr('method', 'get')
