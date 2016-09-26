html = "<%= j render(partial: '/page_context/show', locals: { evidence: @evidence, context_image: @context_image, allow_edit: true }) %>"
$('#context-image').html(html)