define(['module', 'jquery', 'session', 'jquery.mobile'], function(module, jQuery, session) {

(function($, undefined) {

$.widget('mobile.authbadge', $.mobile.widget, {
  options: {
    authenticated: false,
    profile_image_url: 'image/twitter-bird-dark-bgs.png',
    account_page: module.config.account_page || '#settings',
    initSelector: ":jqmData(role='authbadge')"
  },

  _create: function() {
    var auth_info = session.get(),
        profile_image_url = auth_info ? auth_info.profile_image_url : this.options.profile_image_url,
        account_page = this.options.account_page
    this.element.addClass('authbadge ui-btn-left').append(
      $('<img>').attr('src', profile_image_url)
    ).on('click', $.proxy(function() {
      $.mobile.changePage(account_page);
    }, this));
  },

});

$.mobile.document.bind("pagecreate create", function(e) {
  //auto self-init widgets
  $.mobile.authbadge.prototype.enhanceWithin(e.target);
}).bind('lilacauthenticated', function(event, session) {
  $(":jqmData(role='authbadge') img").attr('src', session.profile_image_url);
});


})(jQuery);


});
