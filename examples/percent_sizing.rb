Termbox2.init

layout = Panes.init(width: Termbox2.width, height: Termbox2.height)

begin
  while true
    layout.width = Termbox2.width
    layout.height = Termbox2.height

    commands = layout.build(
      id: 'root',
      width: layout.width,
      height: layout.height,
      direction: :top_bottom,
      padding: [1],
      child_gap: 1,
      border: { all: [:default, :default] },
    ) do
      ui(id: 'header', width: Panes::Sizing.percent(1.0), height: Panes::Sizing.percent(0.15), bg_color: :blue, fg_color: :white) do
        text("Percent-based layout", wrap: false)
      end

      ui(id: 'body', width: Panes::Sizing.percent(1.0), height: Panes::Sizing.percent(0.85), child_gap: 1) do
        ui(id: 'sidebar', width: Panes::Sizing.percent(0.25), height: Panes::Sizing.percent(1.0), bg_color: :green, fg_color: :black) do
          text("25% width\n100% height", wrap: false)
        end

        ui(id: 'content', width: Panes::Sizing.percent(0.75), height: Panes::Sizing.percent(1.0), padding: [1], bg_color: :black, fg_color: :white) do
          text(<<~TEXT)
            This example shows how child nodes can reserve a percentage of the
            available space in their parent container. Resize your terminal to
            see the panels react to the new bounds while maintaining their
            declared percentages.
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
