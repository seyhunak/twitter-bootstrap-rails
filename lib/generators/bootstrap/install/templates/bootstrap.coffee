$ ->
  $("body > .topbar").scrollSpy()
$ ->
  $(".tabs").tabs()
$ ->
  $(".pills").pills()
$ ->
  $("a[rel=twipsy]").twipsy live: true
$ ->
  $("a[rel=popover]").popover offset: 10
$ ->
  $(".topbar-wrapper").dropdown()
$ ->
  $(".alert-message").alert()
$ ->
  domModal = $(".modal").modal(
    backdrop: true
    closeOnEscape: true
  )
  $(".open-modal").click ->
    domModal.toggle()  
