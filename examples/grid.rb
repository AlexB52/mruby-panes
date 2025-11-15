Termbox2.init

layout = Panes.init(width: Termbox2.width, height: Termbox2.height)

begin
  loop do
    layout.width = Termbox2.width
    layout.height = Termbox2.height

    commands = layout.build(
      id: 'root',
      width: Panes::Sizing.grow,
      height: Panes::Sizing.grow,
      border: { all: [:black, :default] }
    ) do
      ui(id: 'dashboard', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
        grid columns: '20 1fr 2fr', rows: '3 1fr 3', gap: 1 do
          area :header, row: 1, col: :all, bg_color: :blue, fg_color: :white do
            text 'Grid header layout'
          end

          area :sidebar, row: 2, col: 1, bg_color: :red, fg_color: :white do
            text "Navigation\n- Status\n- Logs"
          end

          area :main, row: 2, col: 2..3, border: { all: [:black, :default] } do
            grid columns: '1fr 1fr', rows: '1fr 1fr', gap: 1 do
              area :stats, row: 1, col: :all, bg_color: :green, fg_color: :black do
                text 'Nested grid'
              end

              area :left, row: 2, col: 1, bg_color: :yellow, fg_color: :black do
                text 'Left pane'
              end

              area :right, row: 2, col: 2, bg_color: :cyan, fg_color: :black do
                text 'Right pane'
              end
            end
          end

          area :footer, row: 3, col: :all, bg_color: :white, fg_color: :black do
            text 'Press q to quit'
          end
        end
      end
    end

    Panes::TBRender.render_commands(commands, tb: Termbox2)
    Termbox2.present

    event = Termbox2.peek_event(33)
    Termbox2.clear
    break if event && event[:ch] && event[:ch].chr == 'q'
  end
ensure
  Termbox2.shutdown
end
