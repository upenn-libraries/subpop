module Flickr
  class Tag
    attr_reader :str

    def initialize str
      @str = str
    end

    def quote open='`', close='\''
      open + str + close
    end

    def dquote
      quote '"', '"'
    end

    def squote
      quote "'", "'"
    end

    def normalize
      str && str.downcase.gsub(/[^\p{Alnum}]+/, '')
    end

    def to_s
      str
    end
  end
end