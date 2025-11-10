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
        end
      end
    end
  end
end
