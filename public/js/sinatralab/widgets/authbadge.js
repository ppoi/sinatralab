define(['module', 'jquery', 'jquery.mobile'], function(module, jQuery) {

(function($, undefined) {

$.widget('mobile.authbadge', $.mobile.widget, {
  options: {
    authenticated: false,
    username: 'giest',
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

  _open_loginform: function() {
    var popup = $(this.options.loginform_selector);

    if(!popup.length) {
      popup = $('<div id="auth">').append(
        $('<div data-role="content">').append(
          $('<form id="auth-form">').append(
            $('<label for="auth-username" class="ui-hidden-accessible">ユーザ名</label>'),
            $('<input id="auth-username" type="text" placeholder="ユーザ名">'),
            $('<img id="auth-go" src="image/sign-in-with-twitter-gray.png">')))
      ).appendTo($.mobile.pageContainer).popup();
    }
    popup.popup('open');
  }

});


//auto self-init widgets
$.mobile.document.bind("pagecreate create", function(e) {
  $.mobile.authbadge.prototype.enhanceWithin(e.target);
});

})(jQuery);

window.lilac_authenticated = function(session) {
  $(document).trigger('lilacauth', session);
};



});
