window.Homophone = 
  scrollSpeed: 300,
  navbarHeight: 64

window.delay = (ms, func) -> setTimeout func, ms

((sessvars)->
  sessvars.current_query ||= {}
  sessvars.current_query.type ||= "include"
)(sessvars)
