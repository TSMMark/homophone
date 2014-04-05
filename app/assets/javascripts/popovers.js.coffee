Popover = 
  settings:
    trigger: "hover",
    html: true

$ ->
  $("[data-toggle=popover]").popover Popover.settings
    

$ ->
  $("[data-toggle=popover][data-ajax]").each ->
    $self = $(this)
    $self.one "mouseover", ->
      $.get $self.data("ajax"), (d)->
        $self.attr("data-content", d)
        $self.popover("destroy").popover(Popover.settings)
        $self.popover("show") if $self.is(":hover")
