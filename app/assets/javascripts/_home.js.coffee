# smooth scroll anchors
$ ->
  scrollTo = (selector, speed = Homophone.scrollSpeed)->
    $target = $(selector)
    $target = (if $target.length then $target else $("[name=" + selector.slice(1) + "]"))
    if $target.length
      $("html, body").animate
        scrollTop: $target.offset().top - Homophone.navbarHeight
      , speed, "swing"
      false

  closeNavbar = ->
    $(".dropdown.open").click()
    $(".navbar-toggle:not(.collapsed)").click()

  $("a[href*=#]:not([href=#])").click ->
    if window.location.pathname.replace(/^\//, "") is @pathname.replace(/^\//, "") and location.hostname is @hostname
      closeNavbar()
      scrollTo @hash

  scrollTo(window.location.hash, 0) if window.location.hash
