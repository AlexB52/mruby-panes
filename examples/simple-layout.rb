Termbox2.init

layout = Panes.init(width: Termbox2.width-1, height: Termbox2.height-1)

time = Time.now

begin
  while true
    new_time = Time.now
    duration = new_time - time
    time = new_time

    layout.width = Termbox2.width-1
    layout.height = Termbox2.height-1

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1, direction: :top_bottom) do
      ui(id: '1st', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
          text(<<~TEXT)
            Duration of the cycle #{duration}
          TEXT
        end
      end
    end

    Panes::TBRender.render_commands(commands, tb: Termbox2)
    Termbox2.present

    event = Termbox2.peek_event(33)
    Termbox2.clear
    break if event && event[:ch].chr == 'q'
  end
ensure
  Termbox2.shutdown
end
