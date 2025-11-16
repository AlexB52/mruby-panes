POSITIONS = [
  :top_left,
  :top_center,
  :top_right,
  :middle_left,
  :middle_center,
  :middle_right,
  :bottom_left,
  :bottom_center,
  :bottom_right,
].freeze

Termbox2.init

layout = Panes.init(width: Termbox2.width, height: Termbox2.height)

begin
  while true
    layout.width = Termbox2.width
    layout.height = Termbox2.height

    commands = layout.build(
      id: 'root',
      width: Panes::Sizing.grow,
      height: Panes::Sizing.grow,
      padding: [1, 1, 1, 1],
      direction: :top_bottom,
      child_gap: 1
    ) do
      ui(id: 'title', width: Panes::Sizing.grow, height: 3, fg_color: :yellow) do
        text('Relative positioning demo (press q to quit)')
      end

      ui(id: 'canvas_wrapper', width: Panes::Sizing.grow, height: Panes::Sizing.grow, padding: [1]) do
        ui(id: 'canvas', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: { all: [:default, :default] }) do
          POSITIONS.each do |position|
            ui(
              id: position.to_s,
              width: 18,
              height: 5,
              border: { all: [:default, :default] },
              position: position,
              bg_color: :blue,
              fg_color: :white
            ) do
              text(position.to_s.tr('_', ' ').upcase, fg_color: :yellow)
            end
          end
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
