class TestTextAlignment < MTest::Unit::TestCase
  def test_center_alignment_with_grow_container
    layout = Panes.init(width: 20, height: 5)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow) do
      text('Hello', id: 'text', wrap: false, align: :center)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: 'Hello',
        bounding_box: { x: 7, y: 0, width: 5, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_right_alignment_multi_line_text
    layout = Panes.init(width: 10, height: 4)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow) do
      text("Hello\nWorld", id: 'text', align: :right)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 10, height: 2 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: 'Hello',
        bounding_box: { x: 5, y: 0, width: 5, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: 'World',
        bounding_box: { x: 5, y: 1, width: 5, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_string_alignment_is_normalized
    layout = Panes.init(width: 10, height: 3)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow) do
      text('Hello', id: 'text', wrap: false, align: 'right')
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 10, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: 'Hello',
        bounding_box: { x: 5, y: 0, width: 5, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_inline_text_honors_alignment
    layout = Panes.init(width: 20, height: 5)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow) do
      text(id: 'text', wrap: false, align: :right) do
        text('Name: ')
        text('Alex')
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: 'Name: ',
        bounding_box: { x: 10, y: 0, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: 'Alex',
        bounding_box: { x: 16, y: 0, width: 4, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_inline_center_alignment_divides_remaining_space
    layout = Panes.init(width: 20, height: 5)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow) do
      text(id: 'text', wrap: false, align: :center) do
        text('Score:')
        text(' 42')
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: 'Score:',
        bounding_box: { x: 5, y: 0, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: ' 42',
        bounding_box: { x: 11, y: 0, width: 3, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_unknown_alignment_falls_back_to_left
    layout = Panes.init(width: 20, height: 5)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow) do
      text('Hello', id: 'text', wrap: false, align: :diagonal)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 20, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text',
        type: :text,
        text: 'Hello',
        bounding_box: { x: 0, y: 0, width: 5, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end
end

MTest::Unit.new.run
