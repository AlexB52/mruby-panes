class TestWidthGrow < MTest::Unit::TestCase
  def test_root_level_max_width_inferior_to_width_available
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow(max: 50), height: 30)

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_max_over_calculated_size
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: 30) do
      ui(id: 'one',   width: Panes::Sizing.grow(max: 50),  height: 20)
      ui(id: 'two',   width: Panes::Sizing.grow(max: 125), height: 20)
      ui(id: 'third', width: Panes::Sizing.grow,           height: 20)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 50, y: 0, width: 75, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'third',
        type: :rectangle,
        bounding_box: { x: 125, y: 0, width: 75, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_min_width_over_calculated_size
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: 30) do
      ui(id: 'one',   width: Panes::Sizing.grow(max: 50),  height: 20)
      ui(id: 'two',   width: Panes::Sizing.grow(min: 125), height: 20)
      ui(id: 'third', width: Panes::Sizing.grow,           height: 20)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 38, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 38, y: 0, width: 125, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'third',
        type: :rectangle,
        bounding_box: { x: 163, y: 0, width: 37, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_padding_and_child_gap
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: 30, padding: [5], child_gap: 5) do
      ui(id: 'one',   width: Panes::Sizing.grow(max: 50),  height: 20)
      ui(id: 'two',   width: Panes::Sizing.grow(min: 125), height: 20)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 50, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 60, y: 5, width: 135, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end
end

MTest::Unit.new.run
