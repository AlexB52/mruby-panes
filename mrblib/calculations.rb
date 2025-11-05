module Panes
  module Calculations
    def self.water_fill_distribution(levels, extra)
      # normalize
      items = levels.map.with_index do |lv, idx|
        case lv
        when Numeric
          { idx: idx, cur: lv.to_f, min: 0, max: Float::INFINITY }
        when Hash
          {
            idx: idx,
            cur: (lv[:current] || 0).to_f,
            min: (lv[:min] || 0).to_f,
            max: (lv[:max] ||  Float::INFINITY).to_f
          }
        else
          raise ArgumentError, "unsupported item: #{lv.inspect}"
        end
      end

      # sort by current level
      order = items.sort_by { |it| it[:cur] }
      extra = extra.to_f
      i = 0
      eps = 1e-9 # epsilon to avoid float ping-pong

      while extra > eps && i < order.length
        group = order.take(i + 1).reject { |it| it[:cur] >= it[:max] }
        if group.empty?
          i += 1
          next
        end

        group_cur  = group.first[:cur]
        neighbor   = order[i + 1]&.dig(:cur) || Float::INFINITY
        cap_level  = group.map { |it| it[:max] }.min

        target     = [neighbor, cap_level].min
        delta      = target - group_cur
        need       = delta * group.length

        if delta <= eps
          i += 1
          next
        end

        if extra + eps >= need
          group.each { |it| it[:cur] += delta }
          extra -= need

          i += 1 if target == neighbor
        else
          delta = extra / group.length
          group.each { |it| it[:cur] += delta }
          extra = 0.0
        end
      end

      # return in original order
      items.sort_by { |it| it[:idx] }.map { |it| it[:cur] }
    end

  end
end
