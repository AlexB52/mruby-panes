eval(File.read('mrblib/panes.rb'))

class TestRootWindow < MTest::Unit::TestCase
  def test_fixed_dimensions
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 20, height: 20)

    assert_equal([
      {
        type: :rectangle,
        bounding_box: { x: 0.0, y: 0.0, width: 20.0, height: 20.0 },
      }
    ], commands)
  end
end

MTest::Unit.new.run
