class TestInlineText < MTest::Unit::TestCase
  def test_unwrapped_text
    layout = Panes.init(width: 100, height: 100)

    commands = layout.build(id: 'root') do
      text(id: 'text', wrap: false) do
        text("Prenom: ")
        text("Alexandre")
      end
    end

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 17, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "Prenom: ",
        bounding_box: { x: 0, y: 0, width: 8, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "Alexandre",
        bounding_box: { x: 8, y: 0, width: 9, height: 1 },
      },
    ], commands)
  end

  def test_wrapped_text_with_overlap
    layout = Panes.init(width: 100, height: 100)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow(max: 51)) do
      text(id: 'text') do
        text("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod ")
        text("tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,")
      end
    end

    # EXPECTED RESULTS.
    # Note '|' the delimited between the two different text

    # Lorem ipsum dolor sit amet, consectetur adipisicing
    # elit, sed do eiusmod|tempor incididunt ut labore et
    # dolore magna aliqua. Ut enim ad minim veniam,

    assert_commands([
      {
        id: 'root',
        type: :rectangle,
        bounding_box: { x: 0, y: 0, width: 51, height: 3 },
      },
      {
        id: 'text',
        type: :text,
        text: "Lorem ipsum dolor sit amet, consectetur adipisicing",
        bounding_box: { x: 0, y: 0, width: 51, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "elit, sed do eiusmod ",
        bounding_box: { x: 0, y: 1, width: 21, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "tempor incididunt ut labore et",
        bounding_box: { x: 21, y: 1, width: 30, height: 1 },
      },
      {
        id: 'text',
        type: :text,
        text: "dolore magna aliqua. Ut enim ad minim veniam,",
        bounding_box: { x: 0, y: 2, width: 45, height: 1 },
      },
    ], commands)
  end
end

MTest::Unit.new.run

