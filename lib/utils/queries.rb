module Utils
  module Queries

    module_function

    def ilike_string(string, type = "include")
      type == "begin" ? "#{string}%" : "%#{string}%"
    end

  end
end
