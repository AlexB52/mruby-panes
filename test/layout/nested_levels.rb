class TestRootWindow < MTest::Unit::TestCase
  def test_fixed_dimensions
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 20, height: 20)

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
      }
    ], commands)
  end

  def test_fixed_dimensions_with_nested_elements
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 60, height: 60) do
      ui(width: 20, height: 20)
      ui(width: 30, height: 30)
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
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 20, y: 0, width: 30, height: 30 },
      }
    ], commands)
  end

  def test_with_nested_elements_with_fit_width
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root') do
      ui(id: 'one', width: 20, height: 20)
      ui(id: 'two', width: 30, height: 30)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 30 },
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 20, y: 0, width: 30, height: 30 },
      }
    ], commands)
  end

  def test_with_multiple_nested_levels
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root') do
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
        bounding_box: { x: 0, y: 0, width: 50, height: 30 },
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 10, height: 20 },
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 20, y: 0, width: 30, height: 30 },
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 20, y: 0, width: 10, height: 20 },
      }
    ], commands)
  end
end

MTest::Unit.new.run
