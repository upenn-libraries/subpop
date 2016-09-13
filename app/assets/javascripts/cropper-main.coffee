$ ->
    'use strict'

    $('#cropper-modal').on 'shown.bs.modal', ->
        $image = $('#image')
        $dataX = $('#dataX')
        $dataY = $('#dataY')
        $dataHeight = $('#dataHeight')
        $dataWidth = $('#dataWidth')
        $dataRotate = $('#dataRotate')
        $dataScaleX = $('#dataScaleX')
        $dataScaleY = $('#dataScaleY')
        options =
              autoCropArea: 1.0
              preview: '.img-preview'
              crop: (e) ->
                    $dataX.val Math.round(e.x)
                    $dataY.val Math.round(e.y)
                    $dataHeight.val Math.round(e.height)
                    $dataWidth.val Math.round(e.width)
                    $dataRotate.val e.rotate
                    $dataScaleX.val e.scaleX
                    $dataScaleY.val e.scaleY
                    return
        $image = $('#image')
        $image.cropper options
        # Buttons
        if !$.isFunction(document.createElement('canvas').getContext)
            $('button[data-method="getCroppedCanvas"]').prop 'disabled', true
        if typeof document.createElement('cropper').style.transition == 'undefined'
            $('button[data-method="rotate"]').prop 'disabled', true
            $('button[data-method="scale"]').prop 'disabled', true

        # Methods
        $('.docs-buttons').on 'click', '[data-method]', ->
            $this = $(this)
            data = $this.data()
            $target = undefined
            result = undefined
            if $this.prop('disabled') or $this.hasClass('disabled')
                return

            if $image.data('cropper') and data.method
                data = $.extend({}, data) # Clone a new one

                if typeof data.target != 'undefined'
                    $target = $(data.target)

                if typeof data.option == 'undefined' and $target
                    try
                        data.option = JSON.parse($target.val())
                    catch e
                        console.log e.message
                result = $image.cropper(data.method, data.option, data.secondOption)
                switch data.method
                    when 'scaleX', 'scaleY'
                        $(this).data 'option', -data.option
                    when 'getCroppedCanvas'
                        if result
                            # Set the data_url with the resulting canvas and submit the form.
                            $('input#photo_data_url').val result.toDataURL('image/jpeg')
                            $('form.new_photo, form.edit_photo').submit()
                            $('#cropper-modal').modal 'hide'

                if $.isPlainObject(result) and $target
                    try
                        $target.val JSON.stringify(result)
                    catch e
                        console.log e.message
            return

        # Keyboard
        $(document.body).on 'keydown', (e) ->
            if !$image.data('cropper') or @scrollTop > 300
                return

            switch e.which
                when 37
                    e.preventDefault()
                    $image.cropper 'move', -1, 0
                when 38
                    e.preventDefault()
                    $image.cropper 'move', 0, -1
                when 39
                    e.preventDefault()
                    $image.cropper 'move', 1, 0
                when 40
                    e.preventDefault()
                    $image.cropper 'move', 0, 1
            return

        # SubPOP-specific functions and buttons.
        #
        # Select the entire canvas, that is the entirety of the image that is
        # visible in the container window.
        selectCanvas = ->
            canvasData = $image.cropper('getCanvasData')
            cropBoxData = $image.cropper('getCropBoxData')
            $image.cropper 'setCropBoxData', canvasData
            return

        # Make the whole image as large as possible in the container window.
        zoomToContainer = ->
            containerData = $image.cropper('getContainerData')
            imageData = $image.cropper('getImageData')
            heightRatio = containerData.height / imageData.naturalHeight
            widthRatio = containerData.width / imageData.naturalWidth
            # zoom to the smaller ratio, works for images large or smaller than
            # container
            zoomToRatio = if heightRatio < widthRatio then heightRatio else widthRatio
            $image.cropper 'zoomTo', zoomToRatio
            # reset the canvas
            $image.cropper 'setCanvasData', $image.cropper('getImageData')
            return

        return
