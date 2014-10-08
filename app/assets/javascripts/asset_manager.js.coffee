#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require bootstrap2/bootstrap
#= require asset_manager/chosen-rails/chosen-jquery
#= require ias/jquery.ias
#= require fancybox
#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl
#= require cocoon

$ ->
  $(window).load ->
    if $('body').hasClass('assets select')
      setTimeout ->
        $('form#search').find('select').chosen()
      , 100

  $(document).ready ->

    # Overlay gallery
    $('a.overlay').fancybox
      maxWidth: 800
      maxHeight: 600
      fitToView: false
      width: '70%'
      height: '70%'
      autoSize: false
      closeClick: false
      openEffect: 'none'
      closeEffect: 'none'
      type: 'image'

    # Fast upload
    $quickUpload = $('#quick_upload')
    if $quickUpload.length
      $quickUpload.find('.link-upload').click ->
        $quickUpload.toggleClass('open')
      $quickUpload.find('form').fileupload
        dataType: "script"
        add: (e, data) ->
          $('#quick_upload .progress').remove()
          file = data.files[0]
          data.context = $(tmpl("template-upload", file))
          $('#quick_upload .well').append(data.context)
          data.submit()
        progress: (e, data) ->
          if data.context
            progress = parseInt(data.loaded / data.total * 100, 10)
            data.context.find('.bar').css('width', progress + '%')

    if $('body').hasClass('assets select')
      # Ias - Infinite scroll
      $.ias
        container: "#sortable1.connectedSortable"
        item: ".resource.asset"
        pagination: ".assets-navigation"
        next: "a[rel=next]"
        loader: '<img src="/assets/ias/loader.gif" alt="Loading..." />'

      # Params
      param_max = parseInt($('.param-max').html())
      param_multiple = $('.param-multiple').html()
      param_field = $('.param-field').html()
      param_locale = $('.param-locale').html()
      param_field_name = $('.param-field-name').html()
      param_save = $('.param-save').html() == 'true'
      param_resource_id = $('.param-resource-id').html()
      $form_search = $('form#search')
      dinamyc_assets_field_id = "#dinamyc_assets_" + param_field
      dinamyc_assets_field_id += "_" + param_locale if param_locale
      dinamyc_assets_field_id += param_resource_id if param_save
      $dinamyc_assets_field = parent.$(dinamyc_assets_field_id)
      param_update_url = $dinamyc_assets_field.attr('data-update-url')

      # Submit form
      $form_search.submit ->
        $(this).addClass('loading')
        $("#sortable2 .resource.asset").each ->
          $form_search.append('<input type="hidden" name="ids[]" value="' + $(this).attr('data-id') + '" />')

      # Sortable - Drag and Drop
      $("#sortable1, #sortable2").sortable
        connectWith: ".connectedSortable"
      .disableSelection()
      $("#sortable2").bind "sortreceive", (event, ui)->
        if $(this).find(".resource.asset").length > param_max
          $(ui.sender).sortable('cancel')
          alert "Limite massimo superato"

      # Action Cancel
      $('button.cancel').click ->
        closeModal()

      # Action Select
      $('button.select').click ->
        ids = []
        $("#sortable2 .resource.asset:lt(" + param_max + ")").each ->
          ids.push($(this).attr('data-id'))
        if (ids.length == 0)
          if param_save
            saveSelection('', [])
          else
            endSelection('', [])
        else
          $.ajax
            url: "/asset_manager/managed_assets/preview"
            data: { ids: ids }
            dataType: "html"
            success: (result)->
              if param_save
                saveSelection(result, ids)
              else
                endSelection(result, ids)

      # Save Selection
      saveSelection = (xhtml, ids) ->
        data = {}
        if (param_multiple == 'true')
          value = if (ids.length > 0) then ids else 'no'
        else
          value = if (ids.length > 0) then ids[0] else 'no'
        #data[param_field_name] = if (param_multiple == true) then ids else ids[0]
        data[param_field_name] = value
        $.ajax
          url: param_update_url
          type: 'PUT'
          data: data
          dataType: "html"
          #success: (result)->
          #  alert result
        $dinamyc_assets_field.html(xhtml)
        closeModal()

      # End Selection
      endSelection = (xhtml, ids) ->
        $link_select = $dinamyc_assets_field.siblings("a")
        original_href = $link_select.attr('data-href')
        if ids.length > 0
          $.each ids, (key, value) ->
            xhtml += '<input type="hidden" name="' + param_field_name + '" value="' + value + '" />'
          $.each ids, (key, value) ->
            original_href += '&ids[]=' + value
        else
          xhtml += '<input type="hidden" name="' + param_field_name + '" value="" />' + $dinamyc_assets_field.attr('no_items_label')
          original_href += '&ids[]=no'
        $dinamyc_assets_field.html(xhtml)
        $link_select.attr('href', original_href)
        closeModal()

      # Close Modal
      closeModal = ->
        parent.$.fancybox.close()
