$ ->
  $search_form = $(".search-form")

  TYPES = {
    include: "Includes",
    begin: "Begins with"
  }

  window.applySearchType = (type)->
    $dropdown_text.html(TYPES[type])
    $hidden_input.val(type)

  $dropdown_text  = $search_form.find(".dropdown-toggle span:first")
  $dropdown_menu  = $search_form.find(".dropdown-menu")
  $hidden_input   = $search_form.find("input[type=hidden]")
  $text_field     = $search_form.find("#search-text")

  $dropdown_menu.find("a").on "click", (e)->
    e.preventDefault()
    $this = $(this)
    window.applySearchType($(this).data("value"))
    $search_form.submit() unless $text_field.val().trim() == ""

  window.applySearchType($hidden_input.val())
