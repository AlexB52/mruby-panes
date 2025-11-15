Termbox2.init

layout = Panes.init(width: Termbox2.width, height: Termbox2.height)

begin
  loop do
    layout.width = Termbox2.width
    layout.height = Termbox2.height

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, direction: :top_bottom) do
      ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: { all: [:black, :default] }, padding: [1], child_gap: 1) do
        text('Left aligned text stays flush with the container edge.', align: :left)
        text('Centered text distributes space evenly and wraps within the box to stay centered.', align: :center)
        text('Right aligned text keeps the end of each line tight to the boundary.', align: :right)

        text('Inline segments share the same alignment:') do
          text(' first ', bg_color: :blue, fg_color: :white)
          text('second ', bg_color: :green, fg_color: :black)
          text('third', bg_color: :yellow, fg_color: :black)
        end
      end
    end

    Panes::TBRender.render_commands(commands, tb: Termbox2)
    Termbox2.present

    event = Termbox2.peek_event(16)
    Termbox2.clear
    break if event && event[:ch].chr == 'q'
  end
ensure
  Termbox2.shutdown
end
