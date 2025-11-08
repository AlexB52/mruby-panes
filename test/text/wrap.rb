module Panes
  class TestWrapText < MTest::Unit::TestCase
    def test_one_sentence
      content = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
      assert_equal([
        "Lorem ipsum dolor sit amet,",
        "consectetur adipisicing elit,",
        "sed do eiusmod tempor",
        "incididunt ut labore et dolore",
        "magna aliqua.",
      ], Text.wrap(content, width: 30))
    end

    def test_multiple_lines
      content = <<~TEXT
        Lorem ipsum dolor sit amet, consectetur adipisicing
        elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      TEXT

      assert_equal([
        "Lorem ipsum dolor sit amet, consectetur adipisicing",
        "elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      ], Text.wrap(content, width: 80))
    end

    def test_multiple_breaklines
      content = <<~TEXT
        Lorem ipsum dolor sit amet, consectetur adipisicing


        elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      TEXT

      assert_equal([
        "Lorem ipsum dolor sit amet, consectetur adipisicing",
        "",
        "",
        "elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      ], Text.wrap(content, width: 80))
    end

    def test_multiple_lines_with_wrapping
      content = <<~TEXT
        Lorem ipsum dolor sit amet, consectetur adipisicing
        elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      TEXT

      assert_equal([
        "Lorem ipsum dolor sit amet,",
        "consectetur adipisicing",
        "elit, sed do eiusmod tempor",
        "incididunt ut labore et",
        "dolore magna aliqua.",
      ], Text.wrap(content, width: 27))
    end
  end
end

MTest::Unit.new.run
