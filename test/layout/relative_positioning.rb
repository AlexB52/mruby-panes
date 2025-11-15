class TestRelativePositioning < MTest::Unit::TestCase
  POSITIONS = [
    [:top_left, :top, :left],
    [:top_center, :top, :center],
    [:top_right, :top, :right],
    [:middle_left, :middle, :left],
    [:middle_center, :middle, :center],
    [:middle_right, :middle, :right],
    [:bottom_left, :bottom, :left],
    [:bottom_center, :bottom, :center],
    [:bottom_right, :bottom, :right],
  ].freeze

  def test_all_relative_positions
    layout = Panes.init(width: 200, height: 120)

    commands = layout.build(
      id: 'root',
      width: 150,
      height: 120,
      padding: [1, 2, 3, 4],
      child_gap: 5
    ) do
      ui(id: 'flow', width: 20, height: 15)
      ui(id: 'positioned_parent', width: 90, height: 60, padding: [3, 5, 7, 11]) do
        POSITIONS.each do |name, _vertical, _horizontal|
          ui(id: name.to_s, width: 20, height: 10, position: name)
        end
      end
    end

    root_padding = { top: 1, right: 2, bottom: 3, left: 4 }
    parent_padding = { top: 3, right: 5, bottom: 7, left: 11 }

    parent_box = { x: root_padding[:left] + 20 + 5, y: root_padding[:top], width: 90, height: 60 }
    content_x = parent_box[:x] + parent_padding[:left]
    content_y = parent_box[:y] + parent_padding[:top]
    interior_width = parent_box[:width] - parent_padding[:left] - parent_padding[:right]
    interior_height = parent_box[:height] - parent_padding[:top] - parent_padding[:bottom]

    expected = [
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 150, height: 120 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'flow',
        type: :rectangle,
        bounding_box: { x: root_padding[:left], y: root_padding[:top], width: 20, height: 15 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'positioned_parent',
        type: :rectangle,
        bounding_box: parent_box.dup,
        bg_color: 0,
        fg_color: 0,
      },
    ]

    POSITIONS.each do |name, vertical, horizontal|
      expected << {
        id: name.to_s,
        type: :rectangle,
        bounding_box: {
          x: expected_x(horizontal, content_x, interior_width, 20),
          y: expected_y(vertical, content_y, interior_height, 10),
          width: 20,
          height: 10,
        },
        bg_color: 0,
        fg_color: 0,
      }
    end

    assert_commands(expected, commands)
  end

  def test_positioned_nodes_do_not_influence_flow_sizing
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(width: Panes::Sizing.fit, height: 40) do
      ui(id: 'flow', width: 30, height: 40)
      ui(id: 'relative', width: 60, height: 20, position: :middle_right)
    end

    expected = [
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 40 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'flow',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 40 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'relative',
        type: :rectangle,
        bounding_box: { x: -30, y: 10, width: 60, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
    ]

    assert_commands(expected, commands)
  end

  def test_invalid_position_raises
    assert_raise(ArgumentError) do
      Panes::Node.new(width: 10, height: 10, position: :top)
    end
  end

  private

  def expected_x(horizontal, content_x, interior_width, child_width)
    case horizontal
    when :left
      content_x
    when :center
      content_x + (interior_width - child_width) / 2
    when :right
      content_x + interior_width - child_width
    end
  end

  def expected_y(vertical, content_y, interior_height, child_height)
    case vertical
    when :top
      content_y
    when :middle
      content_y + (interior_height - child_height) / 2
    when :bottom
      content_y + interior_height - child_height
    end
  end
end

MTest::Unit.new.run
