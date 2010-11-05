var flash_message = function() {
  
  var init = function(element) {
    var self = $(element);
    if (self.is(":hidden")) {
      self.css("visibility","visible");
      self.slideDown(500);
      self.bind("click", function() {
        $(this).slideUp();
      });
    }
  }
  
  return {
    init: init
  }
}();

flash_message.init(".flash");