module ActiveRecord
  class Base

    def self.sample
      return if (c = count).zero?
      offset(rand(c)).first
    end

  end
end
