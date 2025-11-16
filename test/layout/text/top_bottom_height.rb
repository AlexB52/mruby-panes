class TestTextHeightInTopBottomLayouts < MTest::Unit::TestCase
  def test_text_height_increases_grow_container_minimum
    layout = Panes.init(width: 30, height: 12)

    paragraph = (1..9).map { |i| "line-#{i}" }.join("\n")

    commands = layout.build(id: 'root', width: 30, height: 12, direction: :top_bottom) do
      ui(id: 'text-container', width: 30, height: Panes::Sizing.grow, direction: :top_bottom) do
        text(paragraph, id: 'paragraph')
      end

      ui(id: 'second', width: 30, height: Panes::Sizing.grow)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 12 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text-container',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 9 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'line-1',
        bounding_box: { x: 0, y: 0, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'line-2',
        bounding_box: { x: 0, y: 1, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'line-3',
        bounding_box: { x: 0, y: 2, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'line-4',
        bounding_box: { x: 0, y: 3, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'line-5',
        bounding_box: { x: 0, y: 4, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'line-6',
        bounding_box: { x: 0, y: 5, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'line-7',
        bounding_box: { x: 0, y: 6, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'line-8',
        bounding_box: { x: 0, y: 7, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'line-9',
        bounding_box: { x: 0, y: 8, width: 6, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'second',
        type: :rectangle,
        bounding_box: { x: 0, y: 9, width: 30, height: 3 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end

  def test_text_height_honors_padding
    layout = Panes.init(width: 30, height: 12)

    paragraph = (1..4).map { |i| "padded-#{i}" }.join("\n")

    commands = layout.build(id: 'root', width: 30, height: 12, direction: :top_bottom) do
      ui(id: 'text-container', width: 30, height: Panes::Sizing.grow, direction: :top_bottom, padding: [1]) do
        text(paragraph, id: 'paragraph')
      end

      ui(id: 'second', width: 30, height: Panes::Sizing.grow)
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 12 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'text-container',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 30, height: 6 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'padded-1',
        bounding_box: { x: 1, y: 1, width: 8, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'padded-2',
        bounding_box: { x: 1, y: 2, width: 8, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'padded-3',
        bounding_box: { x: 1, y: 3, width: 8, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'paragraph',
        type: :text,
        text: 'padded-4',
        bounding_box: { x: 1, y: 4, width: 8, height: 1 },
        bg_color: 0,
        fg_color: 0,
      },
      {
        id: 'second',
        type: :rectangle,
        bounding_box: { x: 0, y: 6, width: 30, height: 6 },
        bg_color: 0,
        fg_color: 0,
      },
    ], commands)
  end
end

MTest::Unit.new.run
