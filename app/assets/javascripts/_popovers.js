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
Popover.unhoverInterval = 150;

Popover.prototype.show = function () {
  this.stopUnhoverInterval();

  if (this.shown) {
    return;
  }

  this.$el.popover("show");
  this.shown = true;
}

Popover.prototype.hide = function () {
  this.stopUnhoverInterval();

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

  self.$el.on(Popover.unhoverEvent, function (_event) {
    self.startUnhoverInterval()
  });
}

Popover.prototype.startUnhoverInterval = function () {
  var self = this;

  self.stopUnhoverInterval();

  self._unhoverInterval = setInterval(function () {
    self.checkUnhover();
  }, Popover.unhoverInterval);
}

Popover.prototype.stopUnhoverInterval = function () {
  return clearInterval(this._unhoverInterval);
}

Popover.prototype.checkUnhover = function () {
  var $hoveredPopoverContent = $(".popover:hover");

  if (!$hoveredPopoverContent.length && !this.$el.is(":hover")) {
    this.hide();
  }
}

Popover.prototype.bindAJAXListener = function () {
  var self = this;

  self.$el.one(Popover.hoverEvent, function (_event) {
    self.show();

    $.get(self.ajaxURI, function (content) {
      self.setContent(content);
      self.bindNormalListener();
    });
  });
}

Popover.prototype.bindNormalListener = function () {
  var self = this;

  self.$el.on(Popover.hoverEvent, function (_event) {
    self.show();
  });
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
