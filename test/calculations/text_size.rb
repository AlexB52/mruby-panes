module Panes
  class TestTextSizing < MTest::Unit::TestCase
    def test_one_sentence
      text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

      assert_equal(
        {
          width: { min: 11, max: 124 },
          height: { min: 1, max:  13 }
        }, Calculations.text_size(text)
      )
    end

    def test_empty_string
      expected = {
        width: { min: 0, max: 0 },
        height: { min: 1, max:  1 }
      }

      assert_equal(expected, Calculations.text_size(""))
      assert_equal(expected, Calculations.text_size(<<~TEXT))


      TEXT
    end

    def test_multiple_lines
      text = <<~TEXT
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo

        consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
        cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
        proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      TEXT

      assert_equal(
        {
          width: { min: 13, max: 77 },
          height: { min: 7, max:  42 }
        }, Calculations.text_size(text)
      )
    end

    def test_multiple_lines_without_wrap
      text = <<~TEXT
        Lorem

        tempor

        consequat
      TEXT

      assert_equal(
        {
          width: { min: 9, max: 9 },
          height: { min: 5, max:  5 }
        }, Calculations.text_size(text)
      )
    end
  end
end

MTest::Unit.new.run
