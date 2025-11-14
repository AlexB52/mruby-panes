module Panes
  module Borders
    def self.parse(*args, **kwargs)
      result = {}

      if args.any?
        result[:top] = result[:left] = result[:right] = result[:bottom] = config(args)
      end

      if kwargs[:top]
        result[:top] = config(kwargs[:top])
      end

      if kwargs[:right]
        result[:right] = config(kwargs[:right])
      end

      if kwargs[:bottom]
        result[:bottom] = config(kwargs[:bottom])
      end

      if kwargs[:left]
        result[:left] = config(kwargs[:left])
      end

      result
    end

    def self.config(configuration)
      case configuration
      when Array
        {
          fg_color: Colors.parse(configuration[0] || 0),
          bg_color: Colors.parse(configuration[1] || 0),
        }
      when Hash
        {
          fg_color: Colors.parse(configuration[:fg_color]),
          bg_color: Colors.parse(configuration[:bg_color]),
        }
      end
    end
  end
end
