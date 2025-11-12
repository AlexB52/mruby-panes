Termbox2.init

layout = Panes.init(width: Termbox2.width-1, height: Termbox2.height-1)
time = Time.now

begin
  while true
    layout.width = Termbox2.width-1
    layout.height = Termbox2.height-1

    new_time = Time.now
    duration = new_time - time
    time = new_time

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1, direction: :top_bottom) do
      ui(id: '1st', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text(<<~TEXT)
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          TEXT
        end
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text("Duration: #{duration}")
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

    event = Termbox2.peek_event(16)
    Termbox2.clear
    break if event && event[:ch].chr == 'q'
  end
ensure
  Termbox2.shutdown
end
