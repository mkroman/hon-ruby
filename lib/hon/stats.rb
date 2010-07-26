# encoding: utf-8

module HoN
  class Stats
  
    def self.attr_statistics name, key
      define_method name do
        @statistics[key]
      end
    end
    
    def [] name
      @statistics[name]
    end

  end
end
