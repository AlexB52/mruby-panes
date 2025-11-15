Termbox2.init

layout = Panes.init(width: Termbox2.width, height: Termbox2.height)

lorem_ipsum =
  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod" \
  "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam," \
  "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo" \
  "consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse" \
  "cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non" \
  "proident, sunt in culpa qui officia deserunt mollit anim id est laborum." \

begin
  loop do
    layout.width = Termbox2.width
    layout.height = Termbox2.height

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, direction: :top_bottom) do
      ui(width: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: 10, border: {all: [:default, :default]}) do
          text(lorem_ipsum, align: :left)
        end
        ui(width: Panes::Sizing.grow, height: 10, border: {all: [:default, :default]}) do
          text(lorem_ipsum, align: :center)
        end
        ui(width: Panes::Sizing.grow, height: 10, border: {all: [:default, :default]}) do
          text(lorem_ipsum, align: :right)
        end
      end
      ui(width: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: 10, border: {all: [:default, :default]}) do
          text("Hello, World!", align: :left)
        end
        ui(width: Panes::Sizing.grow, height: 10, border: {all: [:default, :default]}) do
          text("Hello, World!", align: :center)
        end
        ui(width: Panes::Sizing.grow, height: 10, border: {all: [:default, :default]}) do
          text("Hello, World!", align: :right)
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
