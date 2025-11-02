class TestWidthGrow < MTest::Unit::TestCase
  def test_root_level
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: Panes::Sizing.grow, height: 30)

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 30 },
      }
    ], commands)
  end

  def test_grow_widths_one_level
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: Panes::Sizing.grow, height: 60) do
      ui(width: Panes::Sizing.grow, height: 20)
      ui(width: Panes::Sizing.grow, height: 30)
    end

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 60 },
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 20 },
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 30, y: 0, width: 30, height: 30 },
      }
    ], commands)
  end

  def test_grow_nested_levels_with_paddings_and_child_gaps
    layout = Panes.init(width: 200, height: 100)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: 60) do
      ui(id: 'one', width: 150, height: 20, padding: [5], child_gap: 5) do
        ui(id: 'two', width: 30, height: 20)
        ui(id: 'three', width: Panes::Sizing.grow, height: 20)
        ui(id: 'four', width: Panes::Sizing.grow, height: 20)
      end

      ui(id: 'five', width: Panes::Sizing.grow, height: 30)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 60 },
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 150, height: 20 },
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 30, height: 20 },
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 40, y: 5, width: 50, height: 20 },
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 95, y: 5, width: 50, height: 20 },
      },
      {
        id: 'five',
        type: :rectangle,
        bounding_box: { x: 150, y: 0, width: 50, height: 30 },
      }
    ], commands)
  end
end

class TestHeightGrow < MTest::Unit::TestCase
  def test_grow_heights_one_level
    skip
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 60, height: 60) do
      ui(width: 20, height: Panes::Sizing.grow)
      ui(width: 30, height: Panes::Sizing.grow)
    end

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 60 },
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 60 },
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 20, y: 0, width: 30, height: 60 },
      }
    ], commands)
  end
end

class TestMixedGrow < MTest::Unit::TestCase
  def test_one_level_with_max_size
    skip
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: Panes::Sizing.grow, height: Panes::Sizing.grow(0, 50))

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 50 },
      }
    ], commands)
  end

  def test_with_multiple_nested_levels_width
    skip
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root') do
      ui(id: 'one', width: Panes::Sizing.grow, height: 20) do
        ui(id: 'three', width: Panes::Sizing.grow, height: Panes::Sizing.grow)
      end
      ui(id: 'two', width: Panes::Sizing.grow, height: 30) do
        ui(id: 'four', width: Panes::Sizing.grow, height: Panes::Sizing.grow)
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 30 },
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 20 },
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 20 },
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 30, y: 0, width: 30, height: 30 },
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 30, y: 0, width: 30, height: 30 },
      }
    ], commands)
  end
end

MTest::Unit.new.run
