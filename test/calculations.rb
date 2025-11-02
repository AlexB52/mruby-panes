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
end

MTest::Unit.new.run
