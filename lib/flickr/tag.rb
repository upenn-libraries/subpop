module Flickr
  class Tag
    attr_reader :raw, :author, :authorname, :id, :_content, :machine_tag

    ALLOWABLE_OPTIONS = [ :raw, :author, :authorname, :id, :_content, :machine_tag ]

    def initialize options
      validate_options options
      options.each do |k,v|
        var = "@#{k}".to_sym
        instance_variable_set var, v
      end
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
    #    Tag.new(raw: 'My tag').normalize     # => "mytag"
    #    Tag.new(raw: 'my täg').normalize     # => "mytäg"
    #    Tag.new(raw: "Mike's tag").normalize # => "mikestag"
    #    Tag.new(raw: 'my_tag').normalize     # => "mytag"
    def normalize
      raw && raw.downcase.gsub(/[^\p{Alnum}]+/, '')
    end
    alias :text :normalize

    def to_s
      raw
    end

    def <=> o
      s.downcase_raw <=> o.downcase_raw
    end

    def == o
      o.class == self.class && o.downcase_raw == downcase_raw
    end
    alias_method :eql?, :==

    def hash
      downcase_raw.hash
    end

    protected
    def downcase_raw
      @raw and @raw.downcase or ''
    end

    private
    def validate_options options
      bad_opts = options.flat_map { |k,v|
        ALLOWABLE_OPTIONS.include?(k.to_sym) ? [] : k
      }
      unless bad_opts.empty?
        msg = "Illegal option(s): #{bad_opts.join ' '}"
        raise ArgumentError.new(msg)
      end
    end

  end
end