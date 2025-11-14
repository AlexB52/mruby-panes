module Panes
  class TestPanesColor < MTest::Unit::TestCase
    def test_named_colors_map_correctly
      assert_equal 0x0000, Colors.parse(:default)
      assert_equal 0x0001, Colors.parse(:black)
      assert_equal 0x0002, Colors.parse(:red)
      assert_equal 0x0003, Colors.parse(:green)
      assert_equal 0x0004, Colors.parse(:yellow)
      assert_equal 0x0005, Colors.parse(:blue)
      assert_equal 0x0006, Colors.parse(:magenta)
      assert_equal 0x0007, Colors.parse(:cyan)
      assert_equal 0x0008, Colors.parse(:white)
    end

    def test_unknown_symbol_raises
      assert_raise(ArgumentError) do
        Colors.parse(:chartreuse)
      end
    end

    def test_integer_passthrough_for_palette_or_packed_rgb
      assert_equal 5, Colors.parse(5)             # palette index
      assert_equal 0x123456, Colors.parse(0x123456) # packed rgb
    end

    def test_array_rgb_is_packed_correctly
      # [r, g, b] -> (r << 16) | (g << 8) | b
      assert_equal 0x000000, Colors.parse([0, 0, 0])
      assert_equal 0xff0000, Colors.parse([255, 0, 0])
      assert_equal 0x00ff00, Colors.parse([0, 255, 0])
      assert_equal 0x0000ff, Colors.parse([0, 0, 255])
      assert_equal 0x123456, Colors.parse([0x12, 0x34, 0x56])
    end

    def test_hash_rgb_is_packed_correctly
      assert_equal 0x000000, Colors.parse(r: 0, g: 0, b: 0)
      assert_equal 0xff0000, Colors.parse(r: 255, g: 0, b: 0)
      assert_equal 0x00ff00, Colors.parse(r: 0, g: 255, b: 0)
      assert_equal 0x0000ff, Colors.parse(r: 0, g: 0, b: 255)
      assert_equal 0x123456, Colors.parse(r: 0x12, g: 0x34, b: 0x56)
    end

    def test_invalid_array_sizes_still_do_something_predictable
      # Your current implementation just shifts first three items, so
      # this documents that behaviour (and guards against regressions).
      assert_equal 0x112233, Colors.parse([0x11, 0x22, 0x33, 0x44])
    end

    def test_invalid_types_raise_argument_error
      assert_raise(ArgumentError) { Colors.parse(nil) }
      assert_raise(ArgumentError) { Colors.parse("red") }
      assert_raise(ArgumentError) { Colors.parse(Object.new) }
    end
  end
end

MTest::Unit.new.run