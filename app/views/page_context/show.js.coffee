html = "<%= j render(partial: '/page_context/show', locals: { evidence: @evidence, context_image: @context_image, allow_edit: true }) %>"
$.replace_html '#context-image', html
$.set_unique_ids()
