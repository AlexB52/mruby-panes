module Panes
  class TestTextAlignment < MTest::Unit::TestCase
    def build_commands(width:, height:, &block)
      layout = Panes.init(width: width, height: height)

      layout.build(
        id: 'root',
        width: Panes::Sizing.fixed(width),
        height: Panes::Sizing.fixed(height),
        &block
      )
    end

    def test_right_alignment_single_line
      commands = build_commands(width: 10, height: 3) do
        text('Hi', id: 'right', align: :right)
      end

      assert_commands([
        {
          id: 'root',
          type: :rectangle,
          bounding_box: { x: 0, y: 0, width: 10, height: 3 },
          bg_color: 0,
          fg_color: 0,
        },
        {
          id: 'right',
          type: :text,
          text: '        Hi',
          bounding_box: { x: 0, y: 0, width: 10, height: 1 },
          bg_color: 0,
          fg_color: 0,
        },
      ], commands)
    end

    def test_center_alignment_single_line
      commands = build_commands(width: 10, height: 3) do
        text('Hi', id: 'right', align: :center)
      end

      assert_commands([
        {
          id: 'root',
          type: :rectangle,
          bounding_box: { x: 0, y: 0, width: 10, height: 3 },
          bg_color: 0,
          fg_color: 0,
        },
        {
          id: 'right',
          type: :text,
          text: '    Hi    ',
          bounding_box: { x: 0, y: 0, width: 10, height: 1 },
          bg_color: 0,
          fg_color: 0,
        },
      ], commands)
    end

    def test_center_alignment_with_wrapping
      commands = build_commands(width: 20, height: 5) do
        text('one two three four five', id: 'wrap', align: :center)
      end

      assert_commands([
        {
          id: 'root',
          type: :rectangle,
          bounding_box: { x: 0, y: 0, width: 20, height: 5 },
          bg_color: 0,
          fg_color: 0,
        },
        {
          id: 'wrap',
          type: :text,
          text: ' one two three four ',
          bounding_box: { x: 0, y: 0, width: 20, height: 1 },
          bg_color: 0,
          fg_color: 0,
        },
        {
          id: 'wrap',
          type: :text,
          text: '        five        ',
          bounding_box: { x: 0, y: 1, width: 20, height: 1 },
          bg_color: 0,
          fg_color: 0,
        },
      ], commands)
    end

    def test_inline_text_alignment_to_right
      commands = build_commands(width: 20, height: 5) do
        text(id: 'inline', align: :right) do
          text('abc def ghi jkl')
          text('mnop')
        end
      end

      assert_commands([
        {
          id: 'root',
          type: :rectangle,
          bounding_box: { x: 0, y: 0, width: 20, height: 5 },
          bg_color: 0,
          fg_color: 0,
        },
        {
          id: 'inline',
          type: :text,
          text: ' abc def ghi jkl',
          bounding_box: { x: 0, y: 0, width: 16, height: 1 },
          bg_color: 0,
          fg_color: 0,
        },
        {
          id: 'inline',
          type: :text,
          text: 'mnop',
          bounding_box: { x: 16.0, y: 0, width: 4, height: 1 },
          bg_color: 0,
          fg_color: 0,
        },
      ], commands)
    end
  end
end

MTest::Unit.new.run
