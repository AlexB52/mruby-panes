class TestPaddings < MTest::Unit::TestCase
  def test_padding_with_one_level
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', padding: [1]) do
      ui(id: 'one', width: 20, height: 20)
      ui(id: 'two', width: 30, height: 30)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 52, height: 32 },
        bg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 20, height: 20 },
        bg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 21, y: 1, width: 30, height: 30 },
        bg_color: 0,
      }
    ], commands)
  end

  def test_paddings_with_nested_levels
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', padding: [1]) do
      ui(id: 'one', width: 20, height: 20, padding: [2]) do
        ui(id: 'three', width: 10, height: 10)
      end
      ui(id: 'two', width: 30, height: 30, padding: [3]) do
        ui(id: 'four', width: 10, height: 20)
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 52, height: 32 },
        bg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 20, height: 20 },
        bg_color: 0,
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 3, y: 3, width: 10, height: 10 },
        bg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 21, y: 1, width: 30, height: 30 },
        bg_color: 0,
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 24, y: 4, width: 10, height: 20 },
        bg_color: 0,
      }
    ], commands)
  end

  def test_child_gap
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', padding: [1], child_gap: 5) do
      ui(id: 'one', width: 20, height: 20, padding: [2]) do
        ui(id: 'three', width: 10, height: 10)
      end
      ui(id: 'two', width: 30, height: 30, padding: [3]) do
        ui(id: 'four', width: 10, height: 20)
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 57, height: 32 },
        bg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 20, height: 20 },
        bg_color: 0,
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 3, y: 3, width: 10, height: 10 },
        bg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 26, y: 1, width: 30, height: 30 },
        bg_color: 0,
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 29, y: 4, width: 10, height: 20 },
        bg_color: 0,
      }
    ], commands)
  end
end

MTest::Unit.new.run
