class TestTextSize < MTest::Unit::TestCase
  def test_unwrapped_text
    layout = Panes.init(width: 100, height: 100)

    commands = layout.build(id: 'root') do
      text("Hello, World!", id: 'text', wrap: false)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 13, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "Hello, World!",
        bounding_box: { x: 0, y: 0, width: 13, height: 1 },
      },
    ], commands)
  end

  def test_wrapped_text_within_grow_container
    layout = Panes.init(width: 100, height: 100)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow) do
      text("Hello, World!", id: 'text', wrap: false)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 100, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "Hello, World!",
        bounding_box: { x: 0, y: 0, width: 13, height: 1 },
      },
    ], commands)
  end

  def test_wrapped_text_within_grow_container_and_max_width
    layout = Panes.init(width: 100, height: 100)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow(max: 28)) do
      text("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor", id: 'text')
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 28, height: 3 },
      },
      {
        id: 'text',
        type: :text,
        text: "Lorem ipsum dolor sit amet,",
        bounding_box: { x: 0, y: 0, width: 27, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "consectetur adipisicing",
        bounding_box: { x: 0, y: 1, width: 23, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "elit, sed do eiusmod tempor",
        bounding_box: { x: 0, y: 2, width: 27, height: 1 },
      },
    ], commands)
  end

  def test_wrapped_text_within_fit_container
    layout = Panes.init(width: 100, height: 100)

    commands = layout.build(id: 'root') do
      text("Hello, World!", id: 'text', wrap: true)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 6, height: 2 },
      },
      {
        id: 'text',
        type: :text,
        text: "Hello,",
        bounding_box: { x: 0, y: 0, width: 6, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "World!",
        bounding_box: { x: 0, y: 1, width: 6, height: 1 },
      },
    ], commands)
  end
end

MTest::Unit.new.run
