var ShareButton;

!function () {
  // options:
  //   social: facebook, twitter, email
  //   type: word_set
  //   url: (url to share - current url if blank)
  //   id: (id of word_set)
  //   trigger: click
  ShareButton = function ($el, options) {
    options || (options = {});
    options.trigger || (options.trigger = "click");
    options.type || (options.type = "word_set");
    options.url || (options.url = window.location.href);

    this.$el = $el;
    this.options = options;

    this.bindListeners();
  }

  ShareButton.VALID_SOCIALS = ["facebook", "twitter", "email"];

  ShareButton.prototype.bindListeners = function () {
    var self = this;
    self.$el.on(self.options.trigger, function (event) {
      event.preventDefault();
      self.trigger();
    });
  }

  ShareButton.prototype.trigger = function () {
    if (ShareButton.VALID_SOCIALS.indexOf(this.options.social) === -1) {
      return;
    }

    var methodName = "trigger" + this.options.social.capitalize();

    this[methodName].call(this);
  }

  ShareButton.prototype.triggerFacebook = function () {
    var self = this;

    window.console && console.log("triggerFacebook", this.options);
    FB.ui({
      method: "feed",
      href: this.options.url
    },
    function(response) {
      if (response && !response.error_code) {
        self.successfulShare();
      } else {
        self.unsuccessfulShare();
      }
    });
  }

  ShareButton.prototype.triggerTwitter = function () {
    window.console && console.log("triggerTwitter", this.options);
  }

  ShareButton.prototype.triggerEmail = function () {
    window.console && console.log("triggerEmail", this.options);
  }

  ShareButton.prototype.successfulShare = function () {
    alert("Thank you for sharing!");
  }

  ShareButton.prototype.unsuccessfulShare = function () {
    alert("Please reconsider sharing");
  }
}();
