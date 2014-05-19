//= require jquery
//= require fancybox

$ ->
    $(".asset_manager_iframe").fancybox
        type     : 'iframe'
        width    : '100%'
        height   : '100%'
        autoSize : false
        helpers :
            title :
                type : 'outside'

