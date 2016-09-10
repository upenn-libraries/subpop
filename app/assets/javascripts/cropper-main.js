// This code is taken from the cropper demo:
//
//    https://github.com/fengyuanchen/cropper/blob/master/demo/js/main.js
//
// It's been adopted with minor change and the addition of couple of subpop-
// specific functions, note below.
//
// Image upload and download functions have been removed.
//
// Each method is attached to a button which defines its function in a @data-
// method attribute and any arguments in a @data-option attribute. The methods
// are then invoked by the code below.
var ready;
ready = function () {

  $(document).on('shown.bs.modal', '#myModal', function() {
    alert("myModal shown.")
  });
  // $(function() {
    'use strict';

    var console = window.console || { log: function () {} };
    var $image = $('#image');
  // var $chload = $('#download');
  var $dataX = $('#dataX');
  var $dataY = $('#dataY');
  var $dataHeight = $('#dataHeight');
  var $dataWidth = $('#dataWidth');
  var $dataRotate = $('#dataRotate');
  var $dataScaleX = $('#dataScaleX');
  var $dataScaleY = $('#dataScaleY');
  var options = {
        // aspectRatio: 16 / 9,
        autoCropArea: 1.0,
        preview: '.img-preview',
        crop: function (e) {
          $dataX.val(Math.round(e.x));
          $dataY.val(Math.round(e.y));
          $dataHeight.val(Math.round(e.height));
          $dataWidth.val(Math.round(e.width));
          $dataRotate.val(e.rotate);
          $dataScaleX.val(e.scaleX);
          $dataScaleY.val(e.scaleY);
        }
      };

  // Tooltip
  $('[data-toggle="tooltip"]').tooltip();

  $('#cropper-modal').on('shown.bs.modal', function() {
    $image = $('#image');
    $image.cropper(options);
    // Buttons
    if (!$.isFunction(document.createElement('canvas').getContext)) {
      $('button[data-method="getCroppedCanvas"]').prop('disabled', true);
    }

    if (typeof document.createElement('cropper').style.transition === 'undefined') {
      $('button[data-method="rotate"]').prop('disabled', true);
      $('button[data-method="scale"]').prop('disabled', true);
    }

    // Options
    $('.docs-toggles').on('change', 'input', function () {
      var $this = $(this);
      var name = $this.attr('name');
      var type = $this.prop('type');
      var cropBoxData;
      var canvasData;

      if (!$image.data('cropper')) {
        return;
      }

      if (type === 'checkbox') {
        options[name] = $this.prop('checked');
        cropBoxData = $image.cropper('getCropBoxData');
        canvasData = $image.cropper('getCanvasData');

        options.built = function () {
          $image.cropper('setCropBoxData', cropBoxData);
          $image.cropper('setCanvasData', canvasData);
        };
      } else if (type === 'radio') {
        options[name] = $this.val();
      }

      $image.cropper('destroy').cropper(options);
    });

    // Methods
    $('.docs-buttons').on('click', '[data-method]', function () {
      var $this = $(this);
      var data = $this.data();
      var $target;
      var result;

      if ($this.prop('disabled') || $this.hasClass('disabled')) {
        return;
      }

      if ($image.data('cropper') && data.method) {
        data = $.extend({}, data); // Clone a new one

        if (typeof data.target !== 'undefined') {
          $target = $(data.target);

          if (typeof data.option === 'undefined') {
            try {
              data.option = JSON.parse($target.val());
            } catch (e) {
              console.log(e.message);
            }
          }
        }

        result = $image.cropper(data.method, data.option, data.secondOption);

        switch (data.method) {
          case 'scaleX':
          case 'scaleY':
          $(this).data('option', -data.option);
          break;

          case 'getCroppedCanvas':
          if (result) {
            // Set the data_url with the resulting canvas and submit the form.
            $('input#photo_data_url').val(result.toDataURL('image/jpeg'));
            $('form.new_photo, form.edit_photo').submit();
            $('#cropper-modal').modal('hide');
                      }
          break;
        }

        if ($.isPlainObject(result) && $target) {
          try {
            $target.val(JSON.stringify(result));
          } catch (e) {
            console.log(e.message);
          }
        }

      }
    });


    // Keyboard
    $(document.body).on('keydown', function (e) {

      if (!$image.data('cropper') || this.scrollTop > 300) {
        return;
      }

      switch (e.which) {
        case 37:
        e.preventDefault();
        $image.cropper('move', -1, 0);
        break;

        case 38:
        e.preventDefault();
        $image.cropper('move', 0, -1);
        break;

        case 39:
        e.preventDefault();
        $image.cropper('move', 1, 0);
        break;

        case 40:
        e.preventDefault();
        $image.cropper('move', 0, 1);
        break;
      }

    });

    // SubPOP-specific functions and buttons.
    //
    // Select the entire canvas, that is the entirety of the image that is
    // visible in the container window.
    var selectCanvas = function() {
      var canvasData  = $image.cropper('getCanvasData');
      var cropBoxData = $image.cropper('getCropBoxData');
      $image.cropper('setCropBoxData', canvasData);
    };

    // Make the whole image as large as possible in the container window.
    var zoomToContainer = function() {
      var containerData = $image.cropper('getContainerData');
      var imageData     = $image.cropper('getImageData');
      var heightRatio   = containerData.height / imageData.naturalHeight;
      var widthRatio    = containerData.width / imageData.naturalWidth;
      // zoom to the smaller ratio, works for images large or smaller than
      // container
      var zoomToRatio   = heightRatio < widthRatio ? heightRatio : widthRatio;

      $image.cropper('zoomTo', zoomToRatio);
      // reset the canvas
      $image.cropper('setCanvasData', $image.cropper('getImageData'));
    };

    $('.subpop-buttons').on('click', '[data-method]', function(){
      var $this = $(this);
      var data = $this.data();
      eval(data.method)();
    });

  });

// });

};



$(document).ready(ready);
// $(document).on('page:load', ready);