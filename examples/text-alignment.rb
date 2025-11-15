Termbox2.init

layout = Panes.init(width: Termbox2.width - 1, height: Termbox2.height - 1)

begin
  loop do
    layout.width = Termbox2.width - 1
    layout.height = Termbox2.height - 1

    commands = layout.build(id: 'root', width: 100, height: 50, direction: :top_bottom, border: 1) do
      ui(width: Panes::Sizing.grow, height: Panes::Sizing.grow, direction: :top_bottom, border: 1, child_gap: 1) do
        text('Left aligned text', wrap: false, align: :left)
        text('Centered text', wrap: false, align: :center)
        text('Right aligned text', wrap: false, align: :right)
      end

      ui(width: Panes::Sizing.grow, height: 3, border: 1) do
        text(wrap: false, align: :right) do
          text('Label: ')
          text('Value')
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
