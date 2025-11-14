class TestWidthGrow < MTest::Unit::TestCase
  def test_root_level
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 30, height: Panes::Sizing.grow)

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 60 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end

  def test_grow_one_level
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', height: Panes::Sizing.grow, width: 60, direction: :top_bottom) do
      ui(id: '1st', height: Panes::Sizing.grow, width: 20)
      ui(id: '2nd', height: Panes::Sizing.grow, width: 30)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 60 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '1st',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '2nd',
        type: :rectangle,
        bounding_box: { x: 0, y: 30, width: 30, height: 30 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end

  def test_grow_nested_levels_with_paddings_and_child_gaps
    layout = Panes.init(width: 100, height: 200)

    commands = layout.build(id: 'root', height: Panes::Sizing.grow, width: 60, direction: :top_bottom) do
      ui(id: 'one', height: 150, width: 20, padding: [5], child_gap: 5, direction: :top_bottom) do
        ui(id: 'two', height: 30, width: 20)
        ui(id: 'three', height: Panes::Sizing.grow, width: 20)
        ui(id: 'four', height: Panes::Sizing.grow, width: 20)
      end

      ui(id: 'five', height: Panes::Sizing.grow, width: 30)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 150 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 20, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 5, y: 40, width: 20, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 5, y: 95, width: 20, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'five',
        type: :rectangle,
        bounding_box: { x: 0, y: 150, width: 30, height: 50 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end
end

class TestWidthGrow < MTest::Unit::TestCase
  def test_root_level
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(height: 30, width: Panes::Sizing.grow, direction: :top_bottom)

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 30 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end

  def test_grow_heights_one_level
    layout = Panes.init(height: 60, width: 60)

    commands = layout.build(height: 60, width: 60, direction: :top_bottom) do
      ui(height: 20, width: Panes::Sizing.grow)
      ui(height: 30, width: Panes::Sizing.grow)
    end

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 60 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 20, width: 60, height: 30 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end

  def test_grow_nested_levels_with_paddings_and_child_gaps
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', height: 60, width: Panes::Sizing.grow, direction: :top_bottom) do
      ui(id: 'one', height: 100, width: 150, padding: [5], child_gap: 5, direction: :top_bottom) do
        ui(id: 'two',   height: 30, width: 20)
        ui(id: 'three', height: 20, width: Panes::Sizing.grow)
        ui(id: 'four',  height: 20, width: Panes::Sizing.grow)
      end

      ui(id: 'five', height: 30, width: Panes::Sizing.grow)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 60 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 150, height: 100 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 20, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 5, y: 40, width: 140, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 5, y: 65, width: 140, height: 20 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'five',
        type: :rectangle,
        bounding_box: { x: 0, y: 100, width: 200, height: 30 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end
end

class TestMixedGrow < MTest::Unit::TestCase
  def test_one_level_with_max_size
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: Panes::Sizing.grow, height: Panes::Sizing.grow, direction: :top_bottom)

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 60 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end

  def test_with_multiple_nested_levels_width
    layout = Panes.init(width: 60, height: 100)

    commands = layout.build(id: 'root', padding: [5], child_gap: 5, height: Panes::Sizing.grow, width: Panes::Sizing.grow, direction: :top_bottom) do
      ui(id: 'one', height: Panes::Sizing.grow, width: 20, direction: :top_bottom) do
        ui(id: 'two', height: Panes::Sizing.grow, width: Panes::Sizing.grow)
      end
      ui(id: 'three', height: Panes::Sizing.grow, width: 30, direction: :top_bottom) do
        ui(id: 'four', height: Panes::Sizing.grow, width: Panes::Sizing.grow)
        ui(id: 'five', height: Panes::Sizing.grow, width: Panes::Sizing.grow)
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 100 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 20, height: 42.5 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 20, height: 42.5 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 5, y: 52.5, width: 30, height: 42.5 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 5, y: 52.5, width: 30, height: 21.25 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'five',
        type: :rectangle,
        bounding_box: { x: 5, y: 73.75, width: 30, height: 21.25 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end
end

MTest::Unit.new.run
