$ ->
  $("[data-infinite-inputs]").each ->
    $this = $(this)
    $clone = $this.find("[data-infinite-inputs-row]:first").clone()
    $clone.find("input").val("")

    appendInput = ->
      $this.append($clone.clone())
      bindLastInput()

    bindLastInput = ->
      $this.find("[data-infinite-inputs-row]:last input").one "focus", ->
        appendInput()

    appendInput()

# masonry on cards
$ ->

  $masonry_container  = $(".card-set-container")
  $cards              = $(".card")
  $ad_cards           = $cards.filter(".card-partner")

  $ad_cards.addClass "stamp"

  window.remason = (setup=false)->
    $masonry_container.masonry "destroy" unless setup

    $masonry_container.masonry
      itemSelector: ".card:not(.stamp)",
      stamp: ".stamp",
      gutter: 9,
      isOriginLeft: false

  window.remason(true)

  enquire.register "screen and (max-width: #{Homophone.screen_xs_max}px)",
    match: ->
      $ad_cards.removeClass "stamp"
      window.remason()
    unmatch: ->
      $ad_cards.addClass "stamp"
      window.remason()


  $masonry_container.find("iframe").one "load", window.remason
