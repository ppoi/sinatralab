define(['module', 'jquery', 'session', 'jquery.mobile'], function(module, jQuery, session) {

(function($, undefined) {

$.widget('mobile.authbadge', $.mobile.widget, {
  options: {
    authenticated: false,
    default_profile_image: 'image/twitter-bird-dark-bgs.png',
    account_page: module.config.account_page || '#settings',
    initSelector: ":jqmData(role='authbadge')"
  },

  _create: function() {
    var account_page = this.options.account_page;
    this.element.addClass('authbadge ui-btn-left').on('click', function() {
      $.mobile.changePage(account_page);
    }).append($('<img>'));
    this.reflesh();
  },

  reflesh: function() {
    var auth_info = session.get(),
        profile_image = auth_info ? auth_info.profile_image : this.options.default_profile_image;
    $('img', this.element).attr('src', profile_image);
  }
});

$.mobile.document.bind("pagecreate create", function(e) {
  //auto self-init widgets
  $.mobile.authbadge.prototype.enhanceWithin(e.target);
}).bind('lilacauthenticated lilaclogouted', function(event, auth_info) {
  $(":jqmData(role='authbadge')").authbadge('reflesh');
});


})(jQuery);


});
