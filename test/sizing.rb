module Panes
  class TestSizing < MTest::Unit::TestCase
    def test_fit
      assert_equal({min: 20.5, max: 35.2, type: :fit}, Sizing.fit(min: 20.5, max: 35.2))
      assert_equal({min: 1, max: Float::INFINITY, type: :fit}, Sizing.fit(min: 1))
      assert_equal({min: 0, max: Float::INFINITY, type: :fit}, Sizing.fit)
    end

    def test_grow
      assert_equal({min: 20.5, max: 35.2, type: :grow}, Sizing.grow(min: 20.5, max: 35.2))
      assert_equal({min: 0, max: Float::INFINITY, type: :grow}, Sizing.grow(min: 0))
      assert_equal({min: 0, max: Float::INFINITY, type: :grow}, Sizing.grow)
    end

    def test_percent
      assert_equal({percent: 0.65, type: :percent}, Sizing.percent(0.65))
    end

    def test_fixed
      assert_equal({min: 20, max: 20, type: :fixed}, Sizing.fixed(20))
    end

    def test_build_fit
      assert_equal({min: 0, max: Float::INFINITY, type: :fit}, Sizing.build)
      assert_equal({min: 0, max: Float::INFINITY, type: :fit}, Sizing.build(nil))
    end

    def test_build_fixed
      assert_equal({min: 20, max: 20, type: :fixed}, Sizing.build(20))
    end
  end
end

MTest::Unit.new.run