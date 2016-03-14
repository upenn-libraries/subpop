ready = ->
    $('a[disabled=disabled]').on 'click', (event) =>
        event.preventDefault()
        return false

$(document).ready(ready)