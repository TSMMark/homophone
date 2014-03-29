$ ->
  $navbar = $(".navbar")
  $search_form = $navbar.find(".navbar-search-form")

  $search_form.each ->
    TYPES = {
      include: "Includes",
      begin: "Begins with"
    }
    applyType = (type)->
      $dropdown_text.html(TYPES[type])
      $hidden_input.val(type)

    $search_form = $(this)
    $dropdown_text = $search_form.find(".dropdown-toggle span:first")
    $dropdown_menu = $search_form.find(".dropdown-menu")
    $hidden_input = $search_form.find("input[type=hidden]")

    $dropdown_menu.find("a").on "click", (e)->
      e.preventDefault()
      $this = $(this)
      applyType($(this).data("value"))
