define(['jquery'], function($) {

function Session() {
  this.data = null;
  $(document).bind('lilacauthenticated', $.proxy(this.handle_authenticated, this))
      .bind('lilaclogouted', $.proxy(this.handle_logout, this));
};
Session.prototype.get = function() {
  return this.data;
};
Session.prototype.authenticate = function() {
  window.open('/auth/twitter', 'lilac-auth');
};
Session.prototype.logout = function() {
  $.ajax('/auth/logout', {
  }).done(function(data, textStatus, jqXHR) {
    $.mobile.document.trigger('lilaclogouted');
  }).fail(function(jqXHR, textStatus, errorThrown) {
    window.alert(errorThrown);
  });
};
Session.prototype.handle_authenticated = function(event, auth_info) {
  this.data = auth_info;
};
Session.prototype.handle_logout = function(event) {
  this.data = null;
};
Session.prototype.initialize = function() {
  var deferred = $.Deferred();
  $.ajax('/auth/status', {
    dataType: 'json'
  }).done($.proxy(function(data, textStatus, jqXHR) {
    this.data = data;
    deferred.resolve();
  }, this)).fail(function(jqXHR, textStatus, errorThrown) {
    window.alert(errotThrown);
    deferred.reject();
  });
  return deferred.promise();
};


window.trigger_lilacauthenticated = function(auth_info) {
  $.mobile.document.trigger('lilacauthenticated', auth_info);
};

return new Session();
});
