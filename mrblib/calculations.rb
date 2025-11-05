module Panes
  module Calculations
    Level = Struct.new(:idx, :current, :min, :max) do
      def fillable?
        return true unless max

        current < max
      end
    end

    def self.water_fill_distribution(levels, extra)
      extra  = extra.to_f
      n      = levels.length
      result = levels.map.with_index do |level, idx|
        case level
        when Integer, Float
          Level.new(idx, level, 0, nil)
        when Hash
          Level.new(idx, level[:current], level[:min], level[:max])
        end
      end

      order = result.sort_by(&:current)

      # spent = nil
      # until spent == 0
      #   spent = 0
      #   level = result.max
      # end

      i = 0

      while i < n - 1 && extra > 0
        value      = order[i].current
        next_value = order[i + 1].current

        if extra >= next_value - value
          order[0..i].each do |level|
            next unless level.fillable?

            old_value = level.current
            if level.max && level.max < next_value
              level.current = level.max
            else
              level.current = next_value
            end
            extra -= (level.current - old_value)
          end

          i += 1
        else
          inc = extra / (i + 1)
          order[0..i].each do |level|
            next unless level.fillable?

            old_value = level.current
            next_value = old_value + inc

            if level.max && level.max < next_value
              level.current = level.max
            else
              level.current = next_value
            end
            extra -= (level.current - old_value)
          end

          i += 1
        end

        order.sort_by!(&:current)
      end

      if extra > 0
        inc = extra / n
        (0...n).each { |j| result[j].current += inc }
      end

      result.sort_by(&:idx).map(&:current)
    end
  end
end
