# Minimal renderer for mruby-termbox2 commands
module Panes
  module TBRender
    CORNER_CHAR = '+'.ord

    def self.render_commands(commands, tb: Termbox2)
      commands.each do |command|
        bbox     = command[:bounding_box]
        bg_color = command[:bg_color]
        fg_color = command[:fg_color]

        x0 = (bbox[:x]).to_i
        x1 = (bbox[:x]+bbox[:width]).to_i
        y0 = (bbox[:y]).to_i
        y1 = (bbox[:y]+bbox[:height]).to_i

        case command[:type]
        when :rectangle
          (y0...y1).each { |y| tb.print(bbox[:x], y, fg_color, bg_color, ' ' * (x1-x0)) }

        when :text
          tb.print(bbox[:x], bbox[:y], fg_color, bg_color, command[:text])

        when :border
          border = command[:border]

          if top = border[:top]
            fg, bg = top[:fg_color], top[:bg_color]

            tb.print(x0, y0, fg, bg, '-' * (x1-x0))
            tb.set_cell(x0, y0, fg, bg, CORNER_CHAR)
            tb.set_cell(x1, y0, fg, bg, CORNER_CHAR)
          end

          if right = border[:right]
            fg, bg = right[:fg_color], right[:bg_color]

            (y0...y1).each { |y| tb.set_cell(x1, y, fg, bg, '|'.ord) }
            tb.set_cell(x1, y0, fg, bg, CORNER_CHAR)
            tb.set_cell(x1, y1, fg, bg, CORNER_CHAR)
          end

          if bottom = border[:bottom]
            fg, bg = bottom[:fg_color], bottom[:bg_color]

            tb.print(x0, y1, fg, bg, '-' * (x1-x0))
            tb.set_cell(x0, y1, fg, bg, CORNER_CHAR)
            tb.set_cell(x1, y1, fg, bg, CORNER_CHAR)
          end

          if left = border[:left]
            fg, bg = left[:fg_color], left[:bg_color]

            (y0...y1).each { |y| tb.set_cell(x0, y, fg, bg, '|'.ord) }
            tb.set_cell(x0, y0, fg, bg, CORNER_CHAR)
            tb.set_cell(x0, y1, fg, bg, CORNER_CHAR)
          end
        end
      end
    end
  end
end
