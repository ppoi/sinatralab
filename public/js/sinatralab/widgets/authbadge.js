define(['module', 'jquery', 'jquery.mobile'], function(module, jQuery) {

(function($, undefined) {

$.widget('mobile.authbadge', $.mobile.widget, {
  options: {
    authenticated: false,
    profile_image_url: 'image/twitter-bird-dark-bgs.png',
    loginform_selector: '#auth',
    initSelector: ":jqmData(role='authbadge')"
  },

  _create: function() {
    this.element.addClass('authbadge ui-btn-left').append(
      $('<img>').attr('src', this.options.profile_image_url)
    ).on('click', $.proxy(function() {
      this._open_loginform();
    }, this));
  },

  _create_loginform: function() {
    var authform = $('<form id="auth-form">'),
        button = $('<img id="auth-go" src="image/sign-in-with-twitter-gray.png">'),
        popup = $('<div id="auth" data-role="popup">').append(
          $('<div class="ui-content">').append(authform.append(button))
        ).appendTo($.mobile.pageContainer);
    authform.on('submit', handle_authform_submit);
    button.on('click', function() {authform.submit();});
    return popup.popup();
  },

  _open_loginform: function() {
    var popup = $(this.options.loginform_selector);

    if(!popup.length) {
      popup = this._create_loginform();
    }
    popup.popup('open');
  }

});

function handle_authform_submit(event) {
  var username = $('#auth-username').val();
  window.open('/auth/twitter', 'lilac-auth');
  return false;
};

$.mobile.document.bind("pagecreate create", function(e) {
  //auto self-init widgets
  $.mobile.authbadge.prototype.enhanceWithin(e.target);
}).bind('lilacauthenticated', function(event, session) {
  $(":jqmData(role='authbadge') img").attr('src', session.profile_image_url);
  $('#auth').popup('close');
});


})(jQuery);


window.lilac_authenticated = function(session) {
  $.mobile.document.trigger('lilacauthenticated', session);
};


});
