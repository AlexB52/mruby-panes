class TestWidthGrow < MTest::Unit::TestCase
  def test_single_container
    layout = Panes.init(width: 50, height: 50)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1)

    assert_commands([
      {
        id: 'root',
        type: :border,
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
      },
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 48, height: 48 },
        bg_color: 0,
      },
    ], commands)
  end

  def test_borders_with_text
    layout = Panes.init(width: 50, height: 50)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
      text("Hello, World!", id: 'text')
    end

    assert_commands([
      {
        id: 'root',
        type: :border,
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
      },
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 48, height: 48 },
        bg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: "Hello, World!",
        bounding_box: { x: 1, y: 1, width: 13, height: 1 },
        bg_color: 0,
      },
    ], commands)
  end

  def test_nested_containers
    layout = Panes.init(width: 50, height: 50)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1) do
      ui(id: '1st', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1)
      ui(id: '2nd', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: 1)
    end

    assert_commands([
      {
        id: 'root',
        type: :border,
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
      },
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 48, height: 48 },
        bg_color: 0,
      },
      {
        id: '1st',
        type: :border,
        bounding_box: { x: 1, y: 1, width: 24, height: 48 },
        bg_color: 0,
      },
      {
        id: '1st',
        type: :rectangle,
        bounding_box: { x: 2, y: 2, width: 22, height: 46 },
        bg_color: 0,
      },
      {
        id: '2nd',
        type: :border,
        bounding_box: { x: 25, y: 1, width: 24, height: 48 },
        bg_color: 0,
      },
      {
        id: '2nd',
        type: :rectangle,
        bounding_box: { x: 26, y: 2, width: 22, height: 46 },
        bg_color: 0,
      },
    ], commands)
  end

  def test_complex_border
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
      ui(id: '1st', height: Panes::Sizing.grow, width: Panes::Sizing.grow(min: 100), border: 1, padding: [10], child_gap: 10) do
        ui(id: '3rd', height: Panes::Sizing.grow, width: Panes::Sizing.fixed(30), border: 1)
        ui(id: '4th', height: Panes::Sizing.grow, width: Panes::Sizing.grow, border: 1)
      end

      ui(id: '2nd', height: Panes::Sizing.grow, width: Panes::Sizing.grow, border: 1, padding: [10])
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 200 },
        bg_color: 0,
      },
      {
        id: '1st',
        type: :border,
        bounding_box: { x: 0, y: 0, width: 100, height: 200 },
        bg_color: 0,
      },
      {
        id: '1st',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 98, height: 198 },
        bg_color: 0,
      },
      {
        id: '3rd',
        type: :border,
        bounding_box: { x: 11, y: 11, width: 30, height: 178 },
        bg_color: 0,
      },
      {
        id: '3rd',
        type: :rectangle,
        bounding_box: { x: 12, y: 12, width: 28, height: 176 },
        bg_color: 0,
      },
      {
        id: '4th',
        type: :border,
        bounding_box: { x: 51, y: 11, width: 38, height: 178 },
        bg_color: 0,
      },
      {
        id: '4th',
        type: :rectangle,
        bounding_box: { x: 52, y: 12, width: 36, height: 176 },
        bg_color: 0,
      },
      {
        id: '2nd',
        type: :border,
        bounding_box: { x: 100, y: 0, width: 100, height: 200 },
        bg_color: 0,
      },
      {
        id: '2nd',
        type: :rectangle,
        bounding_box: { x: 101, y: 1, width: 98, height: 198 },
        bg_color: 0,
      },
    ], commands)
  end
end
