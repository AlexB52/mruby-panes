class TestPaddings < MTest::Unit::TestCase
  def test_padding_with_one_level
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', padding: [1]) do |l|
      l.ui(id: 'one', width: 20, height: 20)
      l.ui(id: 'two', width: 30, height: 30)
    end

    assert_equal([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 52, height: 32 },
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 20, height: 20 },
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 21, y: 1, width: 30, height: 30 },
      }
    ], commands)
  end

  def test_paddings_with_nested_levels
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', padding: [1]) do |l|
      l.ui(id: 'one', width: 20, height: 20, padding: [2]) do |l|
        l.ui(id: 'three', width: 10, height: 10)
      end
      l.ui(id: 'two', width: 30, height: 30, padding: [3]) do |l|
        l.ui(id: 'four', width: 10, height: 20)
      end
    end

    assert_equal([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 52, height: 32 },
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 20, height: 20 },
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 3, y: 3, width: 10, height: 10 },
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 21, y: 1, width: 30, height: 30 },
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 24, y: 4, width: 10, height: 20 },
      }
    ], commands)
  end

  def test_child_gap
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', padding: [1], child_gap: 5) do |l|
      l.ui(id: 'one', width: 20, height: 20, padding: [2]) do |l|
        l.ui(id: 'three', width: 10, height: 10)
      end
      l.ui(id: 'two', width: 30, height: 30, padding: [3]) do |l|
        l.ui(id: 'four', width: 10, height: 20)
      end
    end

    assert_equal([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 57, height: 32 },
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 20, height: 20 },
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 3, y: 3, width: 10, height: 10 },
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 26, y: 1, width: 30, height: 30 },
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 29, y: 4, width: 10, height: 20 },
      }
    ], commands)
  end
end

MTest::Unit.new.run
