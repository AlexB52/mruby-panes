class TestWidthGrow < MTest::Unit::TestCase
  def test_single_container
    layout = Panes.init(width: 50, height: 50)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: { all: [:blue, :red] })

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'root',
        type: :border,
        border: {
          top:    { fg_color: 5, bg_color: 2 },
          right:  { fg_color: 5, bg_color: 2 },
          bottom: { fg_color: 5, bg_color: 2 },
          left:   { fg_color: 5, bg_color: 2 },
        },
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_single_container_with_incomplete_border
    layout = Panes.init(width: 50, height: 50)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: { top: [:blue, :red] })

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'root',
        type: :border,
        border: {
          top: { fg_color: 5, bg_color: 2 },
        },
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_borders_with_text
    layout = Panes.init(width: 50, height: 50)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: { all: [:default, :blue] }) do
      text("Hello, World!", id: 'text')
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'root',
        type: :border,
        border: {
          top:    { fg_color: 0, bg_color: 5 },
          right:  { fg_color: 0, bg_color: 5 },
          bottom: { fg_color: 0, bg_color: 5 },
          left:   { fg_color: 0, bg_color: 5 },
        },
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: "Hello, World!",
        bounding_box: { x: 1, y: 1, width: 13, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_nested_containers
    layout = Panes.init(width: 50, height: 50)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: { all: { fg_color: 0, bg_color: :black } }) do
      ui(id: '1st', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: { bottom: [:red, :green] })
      ui(id: '2nd', width: Panes::Sizing.grow, height: Panes::Sizing.grow, border: { right: { fg_color: :red, bg_color: 5 } })
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'root',
        type: :border,
        border: {
          top:    { fg_color: 0, bg_color: 1 },
          right:  { fg_color: 0, bg_color: 1 },
          bottom: { fg_color: 0, bg_color: 1 },
          left:   { fg_color: 0, bg_color: 1 },
        },
        bounding_box: { x: 0, y: 0, width: 50, height: 50 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '1st',
        type: :rectangle,
        bounding_box: { x: 1, y: 1, width: 24, height: 48 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '1st',
        type: :border,
        border: {
          bottom: { fg_color: 2, bg_color: 3 },
        },
        bounding_box: { x: 1, y: 1, width: 24, height: 48 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '2nd',
        type: :rectangle,
        bounding_box: { x: 25, y: 1, width: 24, height: 48 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '2nd',
        type: :border,
        border: {
          right:  { fg_color: 2, bg_color: 5 },
        },
        bounding_box: { x: 25, y: 1, width: 24, height: 48 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_complex_border
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
      ui(id: '1st', height: Panes::Sizing.grow, width: Panes::Sizing.grow(min: 100), border: { all: [:magenta, :cyan] }, padding: [10], child_gap: 10) do
        ui(id: '3rd', height: Panes::Sizing.grow, width: Panes::Sizing.fixed(30), border: { all: [:magenta, :cyan] })
        ui(id: '4th', height: Panes::Sizing.grow, width: Panes::Sizing.grow, border: { all: [:magenta, :cyan] })
      end

      ui(id: '2nd', height: Panes::Sizing.grow, width: Panes::Sizing.grow, border: { all: [:magenta, :cyan] }, padding: [10])
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 200, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '1st',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 100, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '1st',
        type: :border,
        border: {
          top:    { fg_color: 6, bg_color: 7 },
          right:  { fg_color: 6, bg_color: 7 },
          bottom: { fg_color: 6, bg_color: 7 },
          left:   { fg_color: 6, bg_color: 7 },
        },
        bounding_box: { x: 0, y: 0, width: 100, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '3rd',
        type: :rectangle,
        bounding_box: { x: 11, y: 11, width: 30, height: 178 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '3rd',
        type: :border,
        border: {
          top:    { fg_color: 6, bg_color: 7 },
          right:  { fg_color: 6, bg_color: 7 },
          bottom: { fg_color: 6, bg_color: 7 },
          left:   { fg_color: 6, bg_color: 7 },
        },
        bounding_box: { x: 11, y: 11, width: 30, height: 178 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '4th',
        type: :rectangle,
        bounding_box: { x: 51, y: 11, width: 38, height: 178 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '4th',
        type: :border,
        border: {
          top:    { fg_color: 6, bg_color: 7 },
          right:  { fg_color: 6, bg_color: 7 },
          bottom: { fg_color: 6, bg_color: 7 },
          left:   { fg_color: 6, bg_color: 7 },
        },
        bounding_box: { x: 51, y: 11, width: 38, height: 178 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '2nd',
        type: :rectangle,
        bounding_box: { x: 100, y: 0, width: 100, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: '2nd',
        type: :border,
        border: {
          top:    { fg_color: 6, bg_color: 7 },
          right:  { fg_color: 6, bg_color: 7 },
          bottom: { fg_color: 6, bg_color: 7 },
          left:   { fg_color: 6, bg_color: 7 },
        },
        bounding_box: { x: 100, y: 0, width: 100, height: 200 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end
end
