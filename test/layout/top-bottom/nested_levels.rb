class TestRootWindow < MTest::Unit::TestCase
  def test_fixed_dimensions
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 20, height: 20)

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
        bg_color: 0,
      }
    ], commands)
  end

  def test_fixed_dimensions_with_nested_elements
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 60, height: 60, direction: :top_bottom) do
      ui(width: 20, height: 20)
      ui(width: 30, height: 30)
    end

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 60 },
        bg_color: 0,
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
        bg_color: 0,
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 20, width: 30, height: 30 },
        bg_color: 0,
      }
    ], commands)
  end

  def test_with_nested_elements_with_fit_size
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', direction: :top_bottom) do
      ui(id: 'one', width: 20, height: 20)
      ui(id: 'two', width: 30, height: 30)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 50 },
        bg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
        bg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 0, y: 20, width: 30, height: 30 },
        bg_color: 0,
      }
    ], commands)
  end

  def test_with_multiple_nested_levels
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', direction: :top_bottom) do
      ui(id: 'one', width: 20, height: 20) do
        ui(id: 'three', width: 10, height: 20)
      end
      ui(id: 'two', width: 30, height: 30) do
        ui(id: 'four', width: 10, height: 20)
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 50 },
        bg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
        bg_color: 0,
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 10, height: 20 },
        bg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 0, y: 20, width: 30, height: 30 },
        bg_color: 0,
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 0, y: 20, width: 10, height: 20 },
        bg_color: 0,
      }
    ], commands)
  end
end

MTest::Unit.new.run
