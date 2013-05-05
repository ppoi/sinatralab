define(['jquery', 'controller'], function($, controller) {

var MenuPage = controller.extend_page();
controller.register(/^(menu)$/, MenuPage);

});
