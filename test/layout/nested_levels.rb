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
    skip
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root') do |l|
      l.ui(id: 'one', width: 20, height: 20) do |l|
        l.ui(id: 'three', width: 10, height: 20)
      end
      l.ui(id: 'two', width: 30, height: 30) do |l|
        l.ui(id: 'four', width: 10, height: 20)
      end
    end

    assert_equal([
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
