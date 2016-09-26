html = "<%= j render(partial: '/page_context/show', locals: { evidence: @evidence, context_image: @context_image, allow_edit: true }) %>"
$('#context-image').html(html)

if $('form#new_evidence')
    $('form#new_evidence').append('<input type="hidden" name="evidence[context_image_id]" value="' + <%= @context_image.id %> + '">')