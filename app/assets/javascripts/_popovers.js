window.Popover = function ($el, options) {
  options || (options = {});

  this.ajaxURI = options.ajaxURI;
  this.$el = $el;
  this.shown = false;

  this.bindListeners();
}

Popover.settings = {
  trigger: "manual",
  html: true,
  placement: "auto top",
  container: "#body-content",
  "original-title": "",
  "title": ""
}

Popover.hoverEvent = "mouseover";
Popover.unhoverEvent = "mouseout";

Popover.prototype.show = function () {
  if (this.shown) {
    return;
  }

  this.$el.popover("show");
  this.shown = true;
}

Popover.prototype.hide = function () {
  if (!this.shown) {
    return;
  }

  this.$el.popover("hide");
  this.shown = false;
}

Popover.prototype.bindListeners = function () {
  var self = this;

  self.$el.popover(Popover.settings);

  if (self.ajaxURI) {
    self.bindAJAXListener();
  }
  else {
    self.bindNormalListener();
  }

  if (Popover.unhoverEvent) {
    self.$el.on(Popover.unhoverEvent, function (_event) {
      self.hide();
    });
  }
}

Popover.prototype.bindAJAXListener = function () {
  var self = this;

  if (Popover.hoverEvent) {
    self.$el.one(Popover.hoverEvent, function (_event) {
      self.show();

      $.get(self.ajaxURI, function (content) {
        self.setContent(content);
        self.bindNormalListener();
      });
    });
  }
}

Popover.prototype.bindNormalListener = function () {
  var self = this;

  if (Popover.hoverEvent) {
    self.$el.on(Popover.hoverEvent, function (_event) {
      self.show();
    });
  }
}

Popover.prototype.setContent = function (content) {
  var wasShown = this.shown;
  this.shown = false;
  this.$el.attr("data-content", content);
  this.$el.popover("destroy").popover(Popover.settings);
  if (wasShown) {
    this.show();
  }
}


$(function () {
  $("[data-toggle=popover]").each(function () {
    var $popover = $(this)
      , options = {
          ajaxURI: $popover.data("ajax") || undefined
        };

    new Popover($popover, options);
  });
});
