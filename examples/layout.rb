Termbox2.init

begin
  while true
    Termbox2.clear

    layout = Panes.init(width: Termbox2.width, height: Termbox2.height)
    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1, direction: :top_bottom) do
      ui(id: '1st', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text(<<~TEXT)
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          TEXT
        end
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text("Hello, World!")
        end
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text("Hello, World!")
        end
      end

      ui(id: '2nd', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text("Hello, World!")
        end
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text("Hello, World!")
        end
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text("Hello, World!")
        end
      end

      ui(id: '2nd', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text("Hello, World!")
        end
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text("Hello, World!")
        end
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text("Hello, World!")
        end
      end
    end

    Panes::TBRender.render_commands(commands, tb: Termbox2)
    Termbox2.present

    event = TB2.poll_event
    break if event[:ch].chr == 'q'
  end
ensure
  Termbox2.shutdown
end
