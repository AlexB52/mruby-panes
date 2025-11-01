class TestRootWindow < MTest::Unit::TestCase
  def test_fixed_dimensions
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 20, height: 20)

    assert_equal([
      {
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
      }
    ], commands)
  end

  def test_fixed_dimensions_with_nested_elements
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 60, height: 60) do |l|
      l.ui(width: 20, height: 20)
      l.ui(width: 30, height: 30)
    end

    assert_equal([
      {
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 60 },
      },
      {
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
      },
      {
        type: :rectangle,
        bounding_box: { x: 20, y: 0, width: 30, height: 30 },
      }
    ], commands)
  end
end

MTest::Unit.new.run
