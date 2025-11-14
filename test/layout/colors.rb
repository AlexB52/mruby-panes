class TestColors < MTest::Unit::TestCase
  def test_simple_node
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 20, height: 20, bg_color: :blue, fg_color: :red)

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
        bg_color: 5,
        fg_color: 2,
      }
    ], commands)
  end

  def test_nested_nodes
    # Colors are pass down from parent when they are not explicitly set

    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(width: 60, height: 60, bg_color: :red, fg_color: :blue) do
      ui(width: 20, height: 20)
      ui(width: 30, height: 30, bg_color: 0)
    end

    assert_commands([
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 60, height: 60 },
        bg_color: 2,
        fg_color: 5,
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
        bg_color: 2,
        fg_color: 5,
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: { x: 20, y: 0, width: 30, height: 30 },
        bg_color: 0,
        fg_color: 5,
      }
    ], commands)
  end

  def test_with_multiple_nested_levels
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', bg_color: :green) do
      ui(id: 'one', width: 20, height: 20) do
        ui(id: 'three', width: 10, height: 20)
      end
      ui(id: 'two', width: 30, height: 30) do
        ui(id: 'four', width: 10, height: 20)
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 50, height: 30 },
        bg_color: 3,
        fg_color: 0,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
        bg_color: 3,
        fg_color: 0,
      },
      {
        id: 'three',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 10, height: 20 },
        bg_color: 3,
        fg_color: 0,
      },
      {
        id: 'two',
        type: :rectangle,
        bounding_box: { x: 20, y: 0, width: 30, height: 30 },
        bg_color: 3,
        fg_color: 0,
      },
      {
        id: 'four',
        type: :rectangle,
        bounding_box: { x: 20, y: 0, width: 10, height: 20 },
        bg_color: 3,
        fg_color: 0,
      }
    ], commands)
  end

  def test_with_text
    layout = Panes.init(width: 60, height: 60)

    commands = layout.build(id: 'root', bg_color: :green, fg_color: :blue) do
      ui(id: 'one', width: 20, height: 20) do
        text(id: 'text') do
          text("Hello, ")
          text("World!", bg_color: :red, fg_color: :white)
        end
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
        bg_color: 3,
        fg_color: 5,
      },
      {
        id: 'one',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 20 },
        bg_color: 3,
        fg_color: 5,
      },
      {
        id: 'text',
        type: :text,
        text: 'Hello, ',
        bounding_box: { x: 0, y: 0 , width: 7, height: 1 },
        bg_color: 3,
        fg_color: 5,
      },
      {
        id: 'text',
        type: :text,
        text: 'World!',
        bounding_box: { x: 7, y: 0 , width: 6, height: 1 },
        bg_color: 2,
        fg_color: 8,
      },
    ], commands)
  end
end

MTest::Unit.new.run
