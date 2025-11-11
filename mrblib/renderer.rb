# Minimal renderer for mruby-termbox2 commands
module Panes
  module TBRender
    def self.render_commands(commands, tb: Termbox2)
      commands.each do |command|
        bbox = command[:bounding_box]

        case command[:type]
        when :rectangle
        when :text
          tb.print(bbox[:x], bbox[:y], 0, 0, command[:text])
        when :border
          c = '+'.ord
          x0 = (bbox[:x]).to_i
          x1 = (bbox[:x]+bbox[:width]).to_i
          y0 = (bbox[:y]).to_i
          y1 = (bbox[:y]+bbox[:height]).to_i

          (x0..x1).each { |x| tb.set_cell(x, y0, 0, 0, '-'.ord) }
          (x0..x1).each { |x| tb.set_cell(x, y1, 0, 0, '-'.ord) }
          (y0..y1).each { |y| tb.set_cell(x0, y, 0, 0, '|'.ord) }
          (y0..y1).each { |y| tb.set_cell(x1, y, 0, 0, '|'.ord) }

          tb.set_cell(x0, y0, 0, 0, c)
          tb.set_cell(x1, y0, 0, 0, c)
          tb.set_cell(x0, y1, 0, 0, c)
          tb.set_cell(x1, y1, 0, 0, c)
        end
      end
    end
  end
end
