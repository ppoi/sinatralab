define(['jquery', 'controller'], function($, controller) {

var MenuPage = controller.extend_page();
MenuPage.prototype.setup_handlers = function(page) {
  $('#auth-form', page).on('submit', $.proxy(this.authenticate, this));
  $('#auth-go', page).click(function() {
    $('#auth-form').submit();
  });
  $(document).bind('lilacauth', $.proxy(this.auth_ok, this));
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
MenuPage.prototype.auth_ok = function(event, session) {
  $('#auth').popup('close');
  $('#username span.ui-btn-text').text(session.username);
};

window.lilac_authenticated = function(session) {
  $(document).trigger('lilacauth', session);
};

controller.register(/^(menu)$/, MenuPage);

});
