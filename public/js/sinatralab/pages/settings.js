define(['jquery', 'controller'], function($, controller) {

var SettingsPage = controller.extend_page();
SettingsPage.prototype.setup_handlers = function(page) {
  $.mobile.document.on('lilacauthenticated', function(event, session) {
    $('#settings-username').text(session.username);
  });
};

controller.register(/^(settings)$/, SettingsPage);


});
