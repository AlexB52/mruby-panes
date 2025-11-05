class TestWidthGrow < MTest::Unit::TestCase
  def test_root_level_max_width_inferior_to_width_available
    skip
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow(max: 50), height: 30)

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 30 },
      }
    ], commands)
  end
end

MTest::Unit.new.run
