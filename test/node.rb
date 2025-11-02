module Panes
  class TestNode < MTest::Unit::TestCase
    def test_parent=
      node1 = Node.new(width: 100, height: 100)
      node2 = Node.new(width: Sizing.grow, height: 50)

      node2.parent = node1
      assert_include(node1.children, node2)
    end

    def test_available_width
      node1 = Node.new(width: 100, height: 100)
      node2 = Node.new(width: Sizing.grow, height: 50)
      node3 = Node.new(width: Sizing.grow, height: 50)

      node3.parent = node2
      node2.parent = node1

      assert_equal 100, node1.available_width
      assert_equal 100, node2.available_width
      assert_equal 100, node3.available_width
    end
  end
end

MTest::Unit.new.run
