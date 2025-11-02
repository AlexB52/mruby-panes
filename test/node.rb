module Panes
  class TestNode < MTest::Unit::TestCase
    def test_parent=
      node1 = Node.new(width: 100, height: 100)
      node2 = Node.new(width: Sizing.grow, height: 50)

      node2.parent = node1
      assert_include(node1.children, node2)
    end
  end
end

MTest::Unit.new.run
