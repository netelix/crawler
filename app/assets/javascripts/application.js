// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require jquery3
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require turbolinks
//= require clickable.js
//= require ajax_modal.js
//= require descriptions.js
//= require element_on_screen.js
//= require deferred_images.js

//$.fancybox.defaults.hash = false;

(function () {
  var scrollPosition;
  document.addEventListener(
    "turbolinks:load",
    function () {
      if (scrollPosition) {
        window.scrollTo(0, scrollPosition[1]);
        scrollPosition = null;
      }
    },
    false
  );

  Turbolinks.reload = function () {
    scrollPosition = [window.scrollX, window.scrollY];
    Turbolinks.visit(window.location, { action: "replace" });
  };
})();
