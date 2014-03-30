module ActiveRecord
  class Base

    def self.sample
      return nil if (c=count).zero?
      offset(rand c).first
    end

  end
end
