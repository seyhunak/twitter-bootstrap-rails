// Bootstrap 5 has no jQuery dependency. Tooltips and popovers are opt-in, so
// initialize the elements marked up with data-bs-toggle here.
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(function (el) {
    new bootstrap.Tooltip(el);
  });

  document.querySelectorAll('[data-bs-toggle="popover"]').forEach(function (el) {
    new bootstrap.Popover(el);
  });
});
