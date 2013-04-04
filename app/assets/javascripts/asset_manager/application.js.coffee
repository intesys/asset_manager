#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require bootstrap
#= require chosen-jquery
#= require ias/jquery.ias

$ ->
  $(document).ready ->
    if $('body').hasClass('assets select')
      #window_height = $(window).height()
      ## Altezze dx
      #new_height_dx = window_height - 70
      #$('.assets-container-drag, #sortable2').height(new_height_dx + 'px')

      # Ias
      $.ias
        container: "#sortable1.connectedSortable"
        item: ".resource.asset"
        pagination: ".assets-navigation"
        next: "a[rel=next]"
        loader: '<img src="/assets/ias/loader.gif" alt="Loading..." />'
      ##$('#sortable1.connectedSortable').infinitescroll
      ##  navSelector : ".sx .assets-navigation"
      ##  nextSelector : ".sx .assets-navigation .next a"
      ##  itemSelector : ".sx .resource.asset"
      ##  debug : true
      ##  loading :
      ##    img : '/assets/loader.gif'
      ##    msgText : ''
      ##    speed : 'slow'
      ##    finishedMsg: "<em>Finish.</em>"

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
      #$form_search_select.change ->
      #  $form_search.submit()

      $form_search.submit ->
        $(this).addClass('loading')
        $("#sortable2 .resource.asset").each ->
          $form_search.append('<input type="hidden" name="ids[]" value="' + $(this).attr('data-id') + '" />')

        #data = $form_search.serialize();
        #$("#sortable2 .resource.asset").each ->
        #  data += '&ids[]=' + $(this).attr('data-id')
        #data = $form_search.serialize();
        #$("#sortable2 .resource.asset").each ->
        #  data += '&ids[]=' + $(this).attr('data-id')
        #$.ajax
        #  url: $form_search.attr('action')
        #  data: data
        #  dataType: 'script'
        #  beforeSend: ->
        #    $form_search.addClass('loading')
        #  success: (response)->
        #    #$(window).scrollTop('-200px')
        #    $form_search.removeClass('loading')
        #return false

      # Sortable
      $("#sortable1, #sortable2").sortable
        connectWith: ".connectedSortable"
      .disableSelection();
      $("#sortable2").bind "sortreceive", (event, ui)->
        if $(this).find(".resource.asset").length > param_max
          $(ui.sender).sortable('cancel')
          alert "Limite massimo superato"

      # Actions
      $('button.cancel').click ->
        closeModal()
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

      endSelection = (xhtml, ids) ->
        # Original href
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
        # Close modal
        closeModal()

      closeModal = ->
        parent.$.fancybox.close()
