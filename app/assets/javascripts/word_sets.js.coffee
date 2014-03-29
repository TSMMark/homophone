# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
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
  $(".card-set-container").masonry
    itemSelector: ".card",
    gutter: 9

$ ->
  $("[data-toggle=popover]").popover
    trigger: "focus"
  # $("[data-toggle=popover]").each ->
  #   $this = $(this)
  #   $this.on "click", ->
  #     # $("[data-toggle=popover]").not($this).popover("hide")
  #     $this.popover("show")
