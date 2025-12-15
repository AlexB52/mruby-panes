module Panes
  class TestFormatText < MTest::Unit::TestCase
    # LEFT
    #  X    X    X    X    X    X    X    X    X    X    X    X    X    X    X    X    X
    LEFT = [
      "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod     ",
      "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, ",
      "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo      ",
      "consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse    ",
      "cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non",
      "proident, sunt in culpa qui officia deserunt mollit anim id est laborum.     "
    ]

    # RIGHT
    #  X    X    X    X    X    X    X    X    X    X    X    X    X    X    X    X    X
    RIGHT = [
      "     Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod",
      " tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,",
      "      quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo",
      "    consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse",
      "cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non",
      "     proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    ]

    #CENTER
    #  X    X    X    X    X    X    X    X    X    X    X    X    X    X    X    X    X
    CENTER = [
      "  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod   ",
      "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, ",
      "   quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo   ",
      "  consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse  ",
      "cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non",
      "  proident, sunt in culpa qui officia deserunt mollit anim id est laborum.   "
    ]

    TEXT = <<~TEXT
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
      quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
      consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
      cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
      proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    TEXT

    def test_default_wrap_left
      inputs = [
        { text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod",     fg_color: 1, bg_color: 2 },
        { text: "|tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,", fg_color: 3, bg_color: 4 },
      ]

      # |0        |10       |20       |30
      # Lorem ipsum dolor sit amet,
      # consectetur adipisicing elit,
      # sed do eiusmod|tempor
      # incididunt ut labore et dolore
      # magna aliqua. Ut enim ad minim
      # veniam,

      expected = [
        { text: 'Lorem ipsum dolor sit amet,   ', x: 0,  y: 0, bg_color: 2, fg_color: 1 },
        { text: 'consectetur adipisicing elit, ', x: 0,  y: 1, bg_color: 2, fg_color: 1 },
        { text: 'sed do eiusmod'                , x: 0,  y: 2, bg_color: 2, fg_color: 1 },
        { text: '|tempor         '              , x: 14, y: 2, bg_color: 4, fg_color: 3 },
        { text: 'incididunt ut labore et dolore', x: 0,  y: 3, bg_color: 4, fg_color: 3 },
        { text: 'magna aliqua. Ut enim ad minim', x: 0,  y: 4, bg_color: 4, fg_color: 3 },
        { text: 'veniam,                       ', x: 0,  y: 5, bg_color: 4, fg_color: 3 },
      ]

      assert_commands(expected, Text.format2(inputs, width: 30, align: :left, wrap: true))
    end

    def test_wrap_right
      inputs = [
        { text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod",     fg_color: 1, bg_color: 2 },
        { text: "|tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,", fg_color: 3, bg_color: 4 },
      ]

      # |0        |10       |20       |30
      #    Lorem ipsum dolor sit amet,
      #  consectetur adipisicing elit,
      #          sed do eiusmod|tempor
      # incididunt ut labore et dolore
      # magna aliqua. Ut enim ad minim
      #                        veniam,

      expected = [
        { text: '   Lorem ipsum dolor sit amet,', x: 0,  y: 0, bg_color: 2, fg_color: 1 },
        { text: ' consectetur adipisicing elit,', x: 0,  y: 1, bg_color: 2, fg_color: 1 },
        { text: '         sed do eiusmod',        x: 0,  y: 2, bg_color: 2, fg_color: 1 },
        { text: '|tempor',                        x: 23, y: 2, bg_color: 4, fg_color: 3 },
        { text: 'incididunt ut labore et dolore', x: 0,  y: 3, bg_color: 4, fg_color: 3 },
        { text: 'magna aliqua. Ut enim ad minim', x: 0,  y: 4, bg_color: 4, fg_color: 3 },
        { text: '                       veniam,', x: 0,  y: 5, bg_color: 4, fg_color: 3 },
      ]

      assert_commands(expected, Text.format2(inputs, width: 30, align: :right, wrap: true))
    end

    def test_wrap_center
      inputs = [
        { text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod",     fg_color: 1, bg_color: 2 },
        { text: "|tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,", fg_color: 3, bg_color: 4 },
      ]

      # |0        |10       |20       |30
      #  Lorem ipsum dolor sit amet,
      # consectetur adipisicing elit,
      #     sed do eiusmod|tempor
      # incididunt ut labore et dolore
      # magna aliqua. Ut enim ad minim
      #            veniam,

      expected = [
        { text: ' Lorem ipsum dolor sit amet,  ', x: 0,  y: 0, bg_color: 2, fg_color: 1 },
        { text: 'consectetur adipisicing elit, ', x: 0,  y: 1, bg_color: 2, fg_color: 1 },
        { text: '    sed do eiusmod'            , x: 0,  y: 2, bg_color: 2, fg_color: 1 },
        { text: '|tempor     '                  , x: 18, y: 2, bg_color: 4, fg_color: 3 },
        { text: 'incididunt ut labore et dolore', x: 0,  y: 3, bg_color: 4, fg_color: 3 },
        { text: 'magna aliqua. Ut enim ad minim', x: 0,  y: 4, bg_color: 4, fg_color: 3 },
        { text: '           veniam,            ', x: 0,  y: 5, bg_color: 4, fg_color: 3 },
      ]

      assert_commands(expected, Text.format2(inputs, width: 30, align: :center, wrap: true))
    end

    def test_wrap_with_space_between_inlines
      inputs = [
        { text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod ",     fg_color: 1, bg_color: 2 },
        { text: "|tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,", fg_color: 3, bg_color: 4 },
      ]

      # |0        |10       |20       |30
      #  Lorem ipsum dolor sit amet,
      # consectetur adipisicing elit,
      #     sed do eiusmod |tempor
      # incididunt ut labore et dolore
      # magna aliqua. Ut enim ad minim
      #            veniam,

      expected = [
        { text: ' Lorem ipsum dolor sit amet,  ', x: 0,  y: 0, bg_color: 2, fg_color: 1 },
        { text: 'consectetur adipisicing elit, ', x: 0,  y: 1, bg_color: 2, fg_color: 1 },
        { text: '    sed do eiusmod '           , x: 0,  y: 2, bg_color: 2, fg_color: 1 },
        { text: '|tempor    '                   , x: 19, y: 2, bg_color: 4, fg_color: 3 },
        { text: 'incididunt ut labore et dolore', x: 0,  y: 3, bg_color: 4, fg_color: 3 },
        { text: 'magna aliqua. Ut enim ad minim', x: 0,  y: 4, bg_color: 4, fg_color: 3 },
        { text: '           veniam,            ', x: 0,  y: 5, bg_color: 4, fg_color: 3 },
      ]

      assert_commands(expected, Text.format2(inputs, width: 30, align: :center, wrap: true))
    end
  end
end

MTest::Unit.new.run