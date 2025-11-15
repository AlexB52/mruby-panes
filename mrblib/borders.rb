module Panes
  module Borders
    def self.parse(all: nil, top: nil, right: nil, bottom: nil, left: nil)
      result = {}

      if all&.any?
        result[:top] = result[:left] = result[:right] = result[:bottom] = config(all)
      end

      if top
        result[:top] = config(top)
      end

      if right
        result[:right] = config(right)
      end

      if bottom
        result[:bottom] = config(bottom)
      end

      if left
        result[:left] = config(left)
      end

      result if result.any?
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
