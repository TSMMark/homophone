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

  // Compile 2D-array into query string.
  ShareButton.makeQueryString = function (array) {
    return array.map(function (keyValue) {
      return encodeURIComponent(keyValue[0]) + "=" +
             encodeURIComponent(keyValue[1]);
    }).join("&");
  }

  ShareButton.prototype.bindListeners = function () {
    var self = this;
    self.$el.on(self.options.trigger, function (event) {
      self.trigger(event);
    });
  }

  ShareButton.prototype.trigger = function (event) {
    if (ShareButton.VALID_SOCIALS.indexOf(this.options.social) === -1) {
      return;
    }

    // TODO: analytics
    var methodName = "trigger" + this.options.social.capitalize();

    this[methodName].call(this, event);
  }

  ShareButton.prototype.triggerFacebook = function (event) {
    event.preventDefault();
    var self = this;

    window.console && console.log("triggerFacebook", this.options);
    FB.ui({
      method: "feed",
      link: this.options.url
    },
    function (response) {
      if (response && !response.error_code) {
        self.successfulShare();
      } else {
        self.unsuccessfulShare();
      }
    });
  }

  ShareButton.prototype.triggerTwitter = function (event) {
    event.preventDefault();
    var base = "https://twitter.com/intent/tweet"
      , params = []
      , intentURL
      , text = "I had no idea this word was a #homophone. " + 
               "You learn something new every day.";

    window.console && console.log("triggerTwitter", this.options);

    params.push(["url", this.options.url]);
    params.push(["text", text]);

    params = ShareButton.makeQueryString(params);

    intentURL = base + "?" + params;
    this.$el.attr("href", intentURL);
  }

  ShareButton.prototype.triggerEmail = function (_event) {
    var subject = "Hey, did you know about this?"
      , body = "I had no idea this word was a homophone. " + 
               "You learn something new every day.\n\n" + 
               this.options.url
      , params = []
      , mailtoURL;

    window.console && console.log("triggerEmail", this.options);

    params.push(["subject", subject]);
    params.push(["body", body]);

    params = ShareButton.makeQueryString(params);

    mailtoURL = "mailto:?" + params;

    this.$el.attr({
      href: mailtoURL,
      target: "_blank"
    });
  }

  ShareButton.prototype.successfulShare = function () {
    // TODO: analytics
    alert("Thank you for sharing!");
  }

  ShareButton.prototype.unsuccessfulShare = function () {
  }
}();
