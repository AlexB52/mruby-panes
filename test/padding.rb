module Panes
  class TestPadding < MTest::Unit::TestCase
    def test_call
      assert_equal({top: 0, right: 0, bottom: 0, left: 0}, Padding[])
      assert_equal({top: 1, right: 1, bottom: 1, left: 1}, Padding[1])
      assert_equal({top: 2, right: 3, bottom: 2, left: 3}, Padding[2, 3])
      assert_equal({top: 2, right: 3, bottom: 4, left: 3}, Padding[2, 3, 4])
      assert_equal({top: 1, right: 2, bottom: 3, left: 4}, Padding[1, 2, 3, 4])
      assert_equal({top: 1, right: 2, bottom: 0, left: 4}, Padding[1, 2, nil, 4])
    end
  end
end

MTest::Unit.new.run