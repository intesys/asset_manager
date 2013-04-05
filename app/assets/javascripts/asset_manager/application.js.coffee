#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require bootstrap
#= require chosen-jquery
#= require ias/jquery.ias

$ ->
  $(document).ready ->
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
      param_field_name = $('.param-field-name').html()
      $form_search = $('form#search')
      $form_search_select = $form_search.find('select')
      $dinamyc_assets_field = parent.$("#dinamyc_assets_" + param_field)

      # Form chosen and submit
      $form_search_select.chosen()

      # Submit form
      $form_search.submit ->
        $(this).addClass('loading')
        $("#sortable2 .resource.asset").each ->
          $form_search.append('<input type="hidden" name="ids[]" value="' + $(this).attr('data-id') + '" />')

      # Sortable - Drag and Drop
      $("#sortable1, #sortable2").sortable
        connectWith: ".connectedSortable"
      .disableSelection();
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
          endSelection('', [])
        else
          $.ajax
            url: "/asset_manager/assets/preview"
            data: {ids: ids}
            dataType: "html"
            success: (result)->
              endSelection(result, ids)

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
        $link_select.attr('href', original_href);
        closeModal()

      # Close Modal
      closeModal = ->
        parent.$.fancybox.close()
