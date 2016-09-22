html = "<%= j render(partial: '/evidence/context_image', locals: { evidence: @evidence, allow_edit: true }) %>"
$('#context-image').html(html)