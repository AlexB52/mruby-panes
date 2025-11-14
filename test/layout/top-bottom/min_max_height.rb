class TestHeightGrowth < MTest::Unit::TestCase
  def test_root_level_with_max_height
    layout = Panes.init(height: 200, width: 200)

    commands = layout.build(id: 'root', height: 100, width: Panes::Sizing.grow(max: 50), direction: :top_bottom)

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 100 },
        bg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels
    layout = Panes.init(height: 200, width: 200)

    commands = layout.build(id: 'root', height: Panes::Sizing.grow, width: 30, direction: :top_bottom) do
      ui(id: 'one',   height: 100, width: Panes::Sizing.grow(max: 50))
      ui(id: 'two',   height: 50,  width: Panes::Sizing.grow(max: 20))
      ui(id: 'third', height: 50,  width: Panes::Sizing.grow)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 200 },
        bg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 100 },
        bg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 0, y: 100, width: 20, height: 50 },
        bg_color: 0,
      },
      {
        id: 'third',
        type: :rectangle,
        bounding_box: { x: 0, y: 150, width: 30, height: 50 },
        bg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_padding_and_child_gap
    layout = Panes.init(height: 200, width: 200)

    commands = layout.build(id: 'root', height: 200, width: 200, padding: [5], child_gap: 5, direction: :top_bottom) do
      ui(id: 'one', height: 100, width: Panes::Sizing.grow(max: 50))
      ui(id: 'two', height: 85, width: Panes::Sizing.grow(min: 125))
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 200 },
        bg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 50, height: 100 },
        bg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 5, y: 110, width: 190, height: 85 },
        bg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_fit_parent
    layout = Panes.init(height: 200, width: 200)

    commands = layout.build(id: 'root', height: 200, width: Panes::Sizing.fit, padding: [5], child_gap: 5, direction: :top_bottom) do
      ui(id: 'one', height: 100, width: Panes::Sizing.grow(max: 50))
      ui(id: 'two', height: 85, width: Panes::Sizing.grow(min: 125))
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 135, height: 200 },
        bg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 50, height: 100 },
        bg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 5, y: 110, width: 125, height: 85 },
        bg_color: 0,
      },
    ], commands)
  end
end

MTest::Unit.new.run
