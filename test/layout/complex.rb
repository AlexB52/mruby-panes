class TestComplexLayout < MTest::Unit::TestCase
  def test_complex_layout
    layout = Panes.init(width: 200, height: 200)

    commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
      ui(id: 'navigation', width: Panes::Sizing.fixed(50), height: Panes::Sizing.grow) do
        ui(width: Panes::Sizing.fixed(20)) do
          text("Hello, World!", id: 'world')
        end

        ui(width: Panes::Sizing.grow) do
          text(<<~TEXT, id: 'EOL')
            Lorem ipsum dolor sit amet, consectetur adipisicing elit,
            dolore magna aliqua
          TEXT
        end
      end

      ui(id: 'content', width: Panes::Sizing.grow, padding: [10], child_gap: 10) do
        text(id: 'inline') do
          text("Lorem ipsum dolor sit amet, consectetur adipisicing elit")
          text("sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,")
        end

        text("Another line down there")
      end
    end

    assert_commands([
      {
        id: "root",
        type: :rectangle,
        bounding_box: {x: 0, y: 0, width: 200.0, height: 200},
        bg_color: 0
      },
      {
        id: "navigation",
        type: :rectangle,
        bounding_box: {x: 0, y: 0, width: 50, height: 200},
        bg_color: 0
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: {x: 0, y: 0, width: 20, height: 1},
        bg_color: 0
      },
      {
        id: "world",
        type: :text,
        text: "Hello, World!",
        bounding_box: {x: 0, y: 0, width: 13, height: 1},
        bg_color: 0
      },
      {
        id: nil,
        type: :rectangle,
        bounding_box: {x: 20, y: 0, width: 30.0, height: 3},
        bg_color: 0
      },
      {
        id: "EOL",
        type: :text,
        text: "Lorem ipsum dolor sit amet,",
        bounding_box: {x: 20, y: 0, width: 27, height: 1},
        bg_color: 0
      },
      {
        id: "EOL",
        type: :text,
        text: "consectetur adipisicing elit,",
        bounding_box: {x: 20, y: 1, width: 29, height: 1},
        bg_color: 0
      },
      {
        id: "EOL",
        type: :text,
        text: "dolore magna aliqua",
        bounding_box: {x: 20, y: 2, width: 19, height: 1},
        bg_color: 0
      },
      {
        id: "content",
        type: :rectangle,
        bounding_box: {x: 50, y: 0, width: 150.0, height: 21},
        bg_color: 0
      },
      {
        id: "inline",
        type: :text,
        text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit",
        bounding_box: {x: 60, y: 10, width: 56, height: 1},
        bg_color: 0
      },
      {
        id: "inline",
        type: :text,
        text: "sed do eiusmod tempor incididunt ut",
        bounding_box: {x: 116, y: 10, width: 35, height: 1},
        bg_color: 0
      },
      {
        id: "inline",
        type: :text,
        text: "labore et dolore magna aliqua. Ut enim ad minim veniam,",
        bounding_box: {x: 60, y: 11, width: 55, height: 1},
        bg_color: 0
      },
      {
        id: nil,
        type: :text,
        text: "Another line down there",
        bounding_box: {x: 167.0, y: 10, width: 23, height: 1},
        bg_color: 0
      },
    ], commands)
  end
end

MTest::Unit.new.run
