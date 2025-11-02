module Panes
  module Calculations
    def self.water_fill_distribution(current_sizes, extra)
      n       = current_sizes.length
      result  = current_sizes.dup
      order   = (0...n).sort_by { |i| current_sizes[i] }
      extra   = extra.to_f

      i = 0
      while i < n - 1 && extra > 0
        level      = current_sizes[order[i]]
        next_level = current_sizes[order[i + 1]]
        need       = (next_level - level) * (i + 1)

        if extra < need
          inc = extra / (i + 1)
          order[0..i].each { |idx| result[idx] += inc }
          extra = 0
        else
          order[0..i].each { |idx| result[idx] = next_level }
          extra -= need
          i += 1
        end
      end

      if extra > 0
        inc = extra / n
        (0...n).each { |j| result[j] += inc }
      end

      result
    end
  end
end
