module Panes
  class TestWaterFillDistribution < MTest::Unit::TestCase
    def test_when_an_item_way_smaller
      assert_equal [20, 70], Calculations.water_fill_distribution([10, 70], 10)
    end

    def test_when_two_way_smaller_items
      assert_equal [20, 70, 20], Calculations.water_fill_distribution([10, 70, 10], 20)
    end

    def test_when_all_items_get_updated
      assert_equal [50, 50], Calculations.water_fill_distribution([10, 30], 60)
    end

    def test_when_all_but_the_last_one_get_updated
      assert_equal [30, 30 ,30], Calculations.water_fill_distribution([10, 20, 30], 30)
    end
  end

  class TestWaterFillDistributionWithMinMax < MTest::Unit::TestCase
    def test_when_an_item_has_a_max_value
      assert_equal [20, 90], Calculations.water_fill_distribution([
        { current: 10, min: 0, max: 20 },
        { current: 70 },
      ], 30)
    end

    def test_when_two_way_smaller_items
      assert_equal [20, 70, 20], Calculations.water_fill_distribution([
        { current: 10, min: 0, max: 20 },
        { current: 70, min: 70, max: 70 },
        { current: 10, min: 0, max: 20 },
      ], 30)
    end

    def test_when_items_with_max_limit_not_reached
      assert_equal [25, 70, 25], Calculations.water_fill_distribution([
        { current: 10, min: 0, max: 30 },
        { current: 70, min: 70, max: 70 },
        { current: 10, min: 0, max: 50 },
      ], 30)
    end

    def test_when_items_with_max_limit_not_reached
      assert_equal [30, 70, 50], Calculations.water_fill_distribution([
        { current: 10, min: 0, max: 30 },
        { current: 70, min: 70, max: 70 },
        { current: 10, min: 0, max: 50 },
      ], 100)
    end

    def test_when_items_with_min
      assert_equal [50, 125, 75], Calculations.water_fill_distribution([
        { current: 0, min: 0, max: 50 },
        { current: 0, min: 125, max: nil },
        { current: 0, min: 0, max: nil },
      ], 250)
    end

    def test_discretizes_fractional_values
      assert_equal [16, 15, 15], Calculations.water_fill_distribution([
        { current: 0, min: 15, max: nil },
        { current: 0, min: 15, max: nil },
        { current: 0, min: 15, max: nil },
      ], 46)
    end
  end
end

MTest::Unit.new.run
