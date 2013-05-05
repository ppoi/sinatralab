define(['jquery', 'controller'], function($, controller) {

var BooksearchPage = controller.extend_page();

controller.register(/^(booksearch)$/, BooksearchPage);

});
