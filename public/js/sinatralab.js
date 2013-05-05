requirejs.config({
  baseUrl: 'js/sinatralab',
  paths: {
    'jquery': '../lib/jquery-1.9.1.min',
    'jquery.mobile': '../lib/jquery.mobile-1.3.1.min'
  },
  shim: {
    'jquery.mobile': {
      deps: ['jquery', 'sinatralab']
    }
  },
  config: {
    'controller': {
      initial_page: 'menu',
      cache_size: 10
    }
  }
});

define('sinatralab', ['require', 'jquery'], function(require, $) {
  var setup_deferred = $.Deferred(),
      setup_promise = setup_deferred.promise();
  require(['widgets/authbadge','pages/menu', 'pages/settings', 'pages/booksearch'], function() {
    setup_deferred.resolve();
  });
  $(document).on("mobileinit", function() {
    $('#welcome').on('pageshow', function() {
      $.mobile.loading('show', {text:'Initializing...', textvisible:true});
      setup_promise.done(function() {
        $.mobile.loading('hide');
        $.mobile.changePage(location.href);
      });
    });
  });
});
require(['jquery.mobile']);
