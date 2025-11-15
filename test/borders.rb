

module Panes
  class TestBorders < MTest::Unit::TestCase
    def test_nil
      assert_nil Borders.parse(all: nil)
    end

    def test_integers
      assert_equal({
        top:    { fg_color: 0, bg_color: 1 },
        left:   { fg_color: 0, bg_color: 1 },
        right:  { fg_color: 0, bg_color: 1 },
        bottom: { fg_color: 0, bg_color: 1 },
      }, Borders.parse(all: [0, 1]))

      assert_equal({
        top:    { fg_color: 5, bg_color: 2 },
        left:   { fg_color: 5, bg_color: 2 },
        right:  { fg_color: 5, bg_color: 2 },
        bottom: { fg_color: 5, bg_color: 2 },
      }, Borders.parse(all: [5, 2]))
    end

    def test_hashes
      assert_equal({
        top:    { fg_color: 5, bg_color: 2 },
        right:  { fg_color: 1, bg_color: 3 },
      }, Borders.parse(top: [5, 2], right: [1, 3]))
    end

    def test_complete_hashes
      assert_equal({
          top:    { fg_color: 5, bg_color: 2 },
          right:  { fg_color: 1, bg_color: 3 },
        },
        Borders.parse(
          top:   { fg_color: 5, bg_color: 2 },
          right: { fg_color: 1, bg_color: 3 }
        )
      )
    end

    def test_symbols
      assert_equal({
        top:    { fg_color: 2, bg_color: 5 },
        left:   { fg_color: 2, bg_color: 5 },
        right:  { fg_color: 2, bg_color: 5 },
        bottom: { fg_color: 2, bg_color: 5 },
      }, Borders.parse(all: [:red, :blue]))

      assert_equal({
        top:    { fg_color: 5, bg_color: 2 },
        right:  { fg_color: 1, bg_color: 3 },
      }, Borders.parse(top: [:blue, :red], right: [:black, :green]))

      assert_equal({
          bottom: { fg_color: 2, bg_color: 5 },
          left:   { fg_color: 1, bg_color: 3 },
        },
        Borders.parse(
          bottom: { fg_color: :red,  bg_color: :blue },
          left:   { fg_color: :black, bg_color: :green }
        )
      )
    end
  end
end

MTest::Unit.new.run