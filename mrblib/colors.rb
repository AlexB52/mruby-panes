module Panes
  module Colors
    NAMED = {
      black:   0x0001,
      red:     0x0002,
      green:   0x0003,
      yellow:  0x0004,
      blue:    0x0005,
      magenta: 0x0006,
      cyan:    0x0007,
      white:   0x0008,
      default: 0x0000
    }

    def self.parse(value)
      case value
      when Symbol
        NAMED.fetch(value) { raise ArgumentError, "Unknown color: #{value}" }

      when Integer
        # Could be:
        # - 0xRRGGBB (future truecolor)
        # - 0..255 (256-color index)
        # - termbox base palette when < 16
        value

      when Array
        # [r, g, b]
        r, g, b = value
        (r << 16) | (g << 8) | b

      when Hash
        # {r: x, g: y, b: z}
        (value[:r] << 16) | (value[:g] << 8) | value[:b]

      else
        raise ArgumentError, "Invalid color format: #{value.inspect}"
      end
    end
  end
end
