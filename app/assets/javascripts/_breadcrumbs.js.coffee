$ ->
  current_query = sessvars.current_query

  if current_query.term
    term = $.trim(current_query.term)
    type = $.trim(current_query.type)

  $(".breadcrumb").each ->
    $crumb = $(@).find("a[href=\\[current_query_path\\]]")
    return unless $crumb.length > 0
    
    path = "/word_sets"

    unless !term || term == ""
      path += "?q=#{term}&type=#{type}" 
      text = "Homophones that " + Helpers.describe_query(term, type)
    else
      text = "All homophones"

    $crumb.attr("href", path)
    $crumb.html(text)
