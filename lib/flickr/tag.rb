module Flickr
  class Tag
    attr_reader :raw

    def initialize str
      # be sure to remove white space
      @raw = str.strip
    end

    # Return the raw tag string formatted for submission to Flickr. Tags with
    # spaces are enclosed in quotes:
    #
    #   "my tag"     =>   "\"my tag\""
    def flickr_format
      raw =~ /\s/ ? double_quote : raw
    end

    # Return the raw tag string quoted by `open` and `close` values, by
    # default '"' and '"', which will format a string with spaces for
    # submission to Flickr.
    #
    #   "my tag"     =>   "\"my tag\""
    def quote open='"', close='"'
      open + raw + close
    end

    # Quote raw tag with double quotes: "'" and "'":
    #
    #     "my tag" => '`"my tag"`'
    def double_quote
      quote '"', '"'
    end

    # Quote the raw tag with '`' and '"':
    #
    #     "my tag" => "`my tag'"
    def cute_quote
      quote "`", "'"
    end

    # Quote raw tag with single quotes: "'" and "'":
    #
    #     "my tag" => "'my tag'"
    def single_quote
      quote "'", "'"
    end

    # Strip out non-alphanumeric characters and downcase to return valid
    # Flickr tag 'text'.
    #
    #    Tag.new('My tag').normalize     # => "mytag"
    #    Tag.new('my täg').normalize     # => "mytäg"
    #    Tag.new("Mike's tag").normalize # => "mikestag"
    #    Tag.new('my_tag').normalize     # => "mytag"
    def normalize
      raw && raw.downcase.gsub(/[^\p{Alnum}]+/, '')
    end
    alias :text :normalize

    def to_s
      raw
    end
  end
end