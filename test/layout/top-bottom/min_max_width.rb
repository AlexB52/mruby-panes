class TestWidthGrow < MTest::Unit::TestCase
  def test_root_level_max_width_inferior_to_width_available
    layout = Panes.init(height: 200, width: 200)

    commands = layout.build(id: 'root', height: Panes::Sizing.grow(max: 50), width: 30, direction: :top_bottom)

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_max_over_calculated_size
    layout = Panes.init(height: 200, width: 200)

    commands = layout.build(id: 'root', height: Panes::Sizing.grow, width: 30, direction: :top_bottom) do
      ui(id: 'one',   height: Panes::Sizing.grow(max: 50),  width: 20)
      ui(id: 'two',   height: Panes::Sizing.grow(max: 125), width: 20)
      ui(id: 'third', height: Panes::Sizing.grow,           width: 20)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 0, y: 50, width: 20, height: 75 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'third',
        type: :rectangle,
        bounding_box: { x: 0, y: 125, width: 20, height: 75 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_min_width_over_calculated_size
    layout = Panes.init(height: 200, width: 200)

    commands = layout.build(id: 'root', height: Panes::Sizing.grow, width: 30, direction: :top_bottom) do
      ui(id: 'one',   height: Panes::Sizing.grow(max: 50),  width: 20)
      ui(id: 'two',   height: Panes::Sizing.grow(min: 125), width: 20)
      ui(id: 'third', height: Panes::Sizing.grow,           width: 20)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 37.5 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 0, y: 37.5, width: 20, height: 125 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'third',
        type: :rectangle,
        bounding_box: { x: 0, y: 162.5, width: 20, height: 37.5 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_padding_and_child_gap
    layout = Panes.init(height: 200, width: 200)

    commands = layout.build(id: 'root', height: Panes::Sizing.grow, width: 30, padding: [5], child_gap: 5, direction: :top_bottom) do
      ui(id: 'one',   height: Panes::Sizing.grow(max: 50),  width: 20)
      ui(id: 'two',   height: Panes::Sizing.grow(min: 125), width: 20)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 20, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 5, y: 60, width: 20, height: 135 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end
end

MTest::Unit.new.run
