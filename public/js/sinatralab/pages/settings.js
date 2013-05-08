define(['jquery', 'controller', 'session'], function($, controller, session) {

var SettingsPage = controller.extend_page();
SettingsPage.prototype.setup_handlers = function(page) {
  $.mobile.document.on('lilacauthenticated', $.proxy(this.handle_lilacauthenticated, this))
      .on('lilaclogout', $.proxy(this.handle_lilaclogout, this));
};
SettingsPage.prototype.handle_pagebeforecreate = function(event) {
  this.signin_button = $('<img src="image/sign-in-with-twitter-gray.png"/>');
  this.signout_button = $('<button>サインアウト</button>');
  this.apply_session_state();
};
SettingsPage.prototype.handle_lilacauthenticated = function(event, auth_info) {
  this.apply_session_state(auth_info);
};
SettingsPage.prototype.handle_lilaclogout = function(event) {
  this.apply_session_state();
};
SettingsPage.prototype.apply_session_state = function(auth_info) {
  auth_info = auth_info || session.get();
  if(auth_info) {
    this.signin_button.off();
    $('#settings-profile-image').attr('src', auth_info.profile_image_url);
    $('#settings-username').text(auth_info.username);
    $('#settings-nickname').text('@' + auth_info.nickname);
    $('#account-session-button').append(this.signout_button);
    this.signout_button.on('click', $.proxy(session.logout, session));
  }
  else {
    this.signout_button.off();
    $('#settings-profile-image').attr('src', 'image/twitter-bird-dark-bgs.png');
    $('#settings-username').text('Guest');
    $('#settings-nickname').text('未ログイン');
    $('#account-session-button').append(this.signin_button);
    this.signin_button.on('click', $.proxy(session.authenticate, session));
  }

};

controller.register(/^(settings)$/, SettingsPage);


});
