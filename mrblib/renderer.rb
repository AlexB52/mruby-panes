# Minimal renderer for mruby-termbox2 commands
module Panes
  module TBRender
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
          line = ' ' * (x1-x0+1)
          (y0..y1).each { |y| tb.print(bbox[:x], y, fg_color, bg_color, line) }
        when :text
          tb.print(bbox[:x], bbox[:y], fg_color, bg_color, command[:text])
        when :border
          tb.print(x0, y0, fg_color, bg_color, '-' * (x1-x0+1))
          tb.print(x0, y1, fg_color, bg_color, '-' * (x1-x0+1))
          (y0..y1).each { |y| tb.set_cell(x0, y, fg_color, bg_color, '|'.ord) }
          (y0..y1).each { |y| tb.set_cell(x1, y, fg_color, bg_color, '|'.ord) }

          tb.set_cell(x0, y0, fg_color, bg_color, '+'.ord)
          tb.set_cell(x1, y0, fg_color, bg_color, '+'.ord)
          tb.set_cell(x0, y1, fg_color, bg_color, '+'.ord)
          tb.set_cell(x1, y1, fg_color, bg_color, '+'.ord)
        end
      end
    end
  end
end
