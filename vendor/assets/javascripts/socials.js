window.fbAsyncInit = function() {
  FB.init({
    appId      : window.FB_APP_ID,
    xfbml      : true,
    version    : 'v2.1'
  });
};

!function(d, s) {

  var addScript = function(id, src){
    var js, jss = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s);js.id = id;
    js.src = src;
    jss.parentNode.insertBefore(js, jss);
  }

  addScript('facebook-jssdk',
            '//connect.facebook.net/en_US/sdk.js');

  addScript('twitter-jssdk',
            '//platform.twitter.com/widgets.js');

}(document, 'script');
