class TestPercentSizing < MTest::Unit::TestCase
  def test_percent_width_and_height_on_single_child
    layout = Panes.init(width: 200, height: 120)

    commands = layout.build(id: 'root', width: 200, height: 120) do
      ui(id: 'percent', width: Panes::Sizing.percent(0.5), height: Panes::Sizing.percent(0.75))
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 120 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'percent',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 100, height: 90 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end

  def test_percent_width_with_padding_and_gap
    layout = Panes.init(width: 240, height: 120)

    commands = layout.build(id: 'root', width: 240, height: 120, padding: [10], child_gap: 20) do
      ui(id: 'one', width: Panes::Sizing.percent(0.5), height: 30)
      ui(id: 'two', width: Panes::Sizing.percent(0.25), height: 30)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 240, height: 120 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 10, y: 10, width: 100, height: 30 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 130, y: 10, width: 50, height: 30 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end

  def test_percent_width_with_top_bottom_parent
    layout = Panes.init(width: 160, height: 160)

    commands = layout.build(id: 'root', width: 160, height: 160, direction: :top_bottom, padding: [8]) do
      ui(id: 'percent', width: Panes::Sizing.percent(0.5), height: 40)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 160, height: 160 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'percent',
        type: :rectangle,
        bounding_box: { x: 8, y: 8, width: 72, height: 40 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end

  def test_percent_height_with_padding_and_gap
    layout = Panes.init(width: 140, height: 220)

    commands = layout.build(id: 'root', width: 140, height: 220, direction: :top_bottom, padding: [5], child_gap: 10) do
      ui(id: 'one', width: 60, height: Panes::Sizing.percent(0.5))
      ui(id: 'two', width: 60, height: Panes::Sizing.percent(0.25))
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 140, height: 220 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 5, y: 5, width: 60, height: 100 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 5, y: 115, width: 60, height: 50 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end

  def test_percent_height_with_left_right_parent
    layout = Panes.init(width: 200, height: 180)

    commands = layout.build(id: 'root', width: 200, height: 180, padding: [10], child_gap: 15) do
      ui(id: 'one', width: 80, height: Panes::Sizing.percent(0.5))
      ui(id: 'two', width: 60, height: 40)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 180 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 10, y: 10, width: 80, height: 80 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 105, y: 10, width: 60, height: 40 },
        bg_color: 0,
        fg_color: 0,
      }
    ], commands)
  end
end

MTest::Unit.new.run
