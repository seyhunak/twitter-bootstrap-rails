initTooltips = ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

jQuery -> initTooltips()

$(document).on 'page:load', initTooltips

