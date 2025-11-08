module MTest::Assertions
  ##
  # Fails unless <tt>exp == act</tt> printing the difference between
  # the two, if possible.
  #
  # If there is no visible difference but the assertion fails, you
  # should suspect that your #== is buggy, or your inspect output is
  # missing crucial details.
  #
  # For floats use assert_in_delta.
  #
  # See also: MiniTest::Assertions.diff

  # METHODS DISPLAYED ONLY TO NOT CHECK OUT mruby-mtest mrbgem

  # def assert_equal exp, act, msg = nil
  #   msg = message(msg, "") { diff exp, act }
  #   assert(exp == act, msg)
  # end

  # ##
  # # Returns a proc that will output +msg+ along with the default message.

  # def message msg = nil, ending = ".", &default
  #   Proc.new{
  #     custom_message = "#{msg}.\n" unless msg.nil? or msg.to_s.empty?
  #     "#{custom_message}#{default.call}#{ending}"
  #   }
  # end

  # def diff exp, act
  #   return "Expected: #{mu_pp exp}\n  Actual: #{mu_pp act}"
  # end

  def diff exp, act
    # adding a breakline before the message
    return "\nExpected: #{mu_pp exp}\n  Actual: #{mu_pp act}"
  end

  def assert_commands exp, act, msg = nil
    return assert(exp == act, msg) if msg

    msg = "\n\n"
    i = [exp.length, act.length].max
    i.times do |n|
      next if exp[n] == act[n]

      msg += <<~MSG
        Expected: #{exp[n]}
        Actual:   #{act[n]}

      MSG
    end

    assert(exp == act, msg)
  end
end
