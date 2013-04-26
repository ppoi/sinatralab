define(['jquery', 'controller'], function($, controller) {

var MenuPage = controller.extend_page();
MenuPage.prototype.setup_handlers = function(page) {
  $('#auth-form', page).on('submit', $.proxy(this.authenticate, this));
  $('#auth-go', page).click(function() {
    $('#auth-form').submit();
  });
};
MenuPage.prototype.authenticate = function() {
  var username = $('#auth-username').val(),
      auth_deferred = $.Deferred(),
      authwnd = window.open('/auth/twitter?username=' + username, 'lilac-auth');
  window.hoge = function() {
    alert('hoge');
  };
  return false;
};

controller.register(/^(menu)$/, MenuPage);

});
