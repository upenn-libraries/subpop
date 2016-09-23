html = "<%= j render(partial: '/page_context/show', locals: { evidence: @evidence, allow_edit: true }) %>"
$('#context-image').html(html)