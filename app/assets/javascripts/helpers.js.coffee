window.Helpers = 
  describe_query: (term, type="include")->
    if type == "begin"
      "begin with \"#{term}\""
    else
      "include \"#{term}\""
