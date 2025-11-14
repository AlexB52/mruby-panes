class TestHeightGrowth < MTest::Unit::TestCase
  def test_root_level_with_max_height
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: 100, height: Panes::Sizing.grow(max: 50))

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 100, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: 30) do
      ui(id: 'one',   width: 100, height: Panes::Sizing.grow(max: 50))
      ui(id: 'two',   width: 50,  height: Panes::Sizing.grow(max: 20))
      ui(id: 'third', width: 50,  height: Panes::Sizing.grow)
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
        bounding_box: { x: 0, y: 0, width: 100, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 100, y: 0, width: 50, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'third',
        type: :rectangle,
        bounding_box: { x: 150, y: 0, width: 50, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_padding_and_child_gap
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: 200, height: 200, padding: [5], child_gap: 5) do
      ui(id: 'one', width: 100, height: Panes::Sizing.grow(max: 50))
      ui(id: 'two', width: 85, height: Panes::Sizing.grow(min: 125))
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 100, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 110, y: 5, width: 85, height: 190 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_root_nested_levels_with_fit_parent
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: 200, height: Panes::Sizing.fit, padding: [5], child_gap: 5) do
      ui(id: 'one', width: 100, height: Panes::Sizing.grow(max: 50))
      ui(id: 'two', width: 85, height: Panes::Sizing.grow(min: 125))
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 135 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 100, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 110, y: 5, width: 85, height: 125 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end
end

MTest::Unit.new.run
