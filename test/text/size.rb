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
end

MTest::Unit.new.run
