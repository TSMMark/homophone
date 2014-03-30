window.remason = ->
  $(".card-set-container").masonry()

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
  $cards = $(".card-set-container")
  $cards.masonry
    itemSelector: ".card",
    gutter: 9


  $cards.find("iframe").one "load", window.remason

$ ->
  $("[data-toggle=popover]").popover
    trigger: "focus"
