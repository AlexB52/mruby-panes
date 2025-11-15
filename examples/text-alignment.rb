Termbox2.init

layout = Panes.init(width: Termbox2.width, height: Termbox2.height)

begin
  loop do
    layout.width = Termbox2.width
    layout.height = Termbox2.height

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
      ui(width: Panes::Sizing.grow, height: 10, border: {all: [:default, :default]}) do
        text('Left aligned text stays flush with the container edge.', align: :left)
      end
      ui(width: Panes::Sizing.grow, height: 10, border: {all: [:default, :default]}) do
        text('Centered text distributes space evenly and wraps within the box to stay centered.', align: :center)
      end
      ui(width: Panes::Sizing.grow, height: 10, border: {all: [:default, :default]}) do
        text('Right aligned text keeps the end of each line tight to the boundary.', align: :right)
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
