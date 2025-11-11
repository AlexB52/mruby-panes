Termbox2.init

layout = Panes.init(width: 50, height: 25)
commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
  ui(id: '1st', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1)
  ui(id: '2nd', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
    text("hello world!")
  end
end

begin
  Termbox2.clear
  Panes::TBRender.render_commands(commands, tb: Termbox2)
  Termbox2.present
  while true
    event = TB2.poll_event
    break if event[:ch].chr == 'q'
  end
ensure
  Termbox2.shutdown
end
