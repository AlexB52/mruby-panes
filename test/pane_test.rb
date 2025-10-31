class TestPane < MTest::Unit::TestCase
  def test_it_works
    assert true
  end

  def test_a_second_time
    assert false
  end
end

MTest::Unit.new.run
