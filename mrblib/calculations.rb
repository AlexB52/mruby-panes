module Panes
  module Calculations
    def self.water_fill_distribution(levels, extra)
      # normalize
      min_amount = 0
      items = levels.map.with_index do |lv, idx|
        case lv
        when Numeric
          min_amount += 0
          { idx: idx, cur: lv, min: 0, max: Float::INFINITY }
        when Hash
          cur = lv[:current] || 0
          min = lv[:min] || 0
          max = lv[:max] ||  Float::INFINITY

          min_amount += [0, min - cur].max
          { idx: idx, cur: cur, min: min, max: max }
        else
          raise ArgumentError, "unsupported item: #{lv.inspect}"
        end
      end

      if min_amount < extra
        items.each do |item|
          need = [0, item[:min] - item[:cur]].max
          extra -= need
          item[:cur] += need
        end
      end

      # sort by current level
      order = items.sort_by { |it| it[:cur] }
      extra = extra
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
          delta, rest = extra.divmod(group.length)
          group.each.with_index(1) { |it, i| it[:cur] += (i <= rest ? delta + 1 : delta) }
          extra = 0.0
        end
      end

      # return in original order
      items.sort_by { |it| it[:idx] }.map { |it| it[:cur] }
    end

    def self.text_size(text, wrap: true, align: :left)
      lines = text.split("\n")
      if lines.empty?
        lines = [""]
      end

      words = text.split

      w_max = lines.map(&:length).max || 0
      if align != :left
        w_max = Float::INFINITY
      end

      w_min = words.map(&:length).max || 0
      unless wrap
        w_min = w_max
      end

      h_min = lines.length

      h_max = 0
      lines.each do |line|
        line_height = 1
        buffer = 0

        line.split.each do |word|
          word_length = word.length
          if buffer.zero?
            buffer = word_length
            next
          end

          new_buffer = buffer + 1 + word_length
          if new_buffer <= w_min
            buffer = new_buffer
          else
            line_height += 1
            buffer = word_length
          end
        end

        h_max += line_height
      end

      {
        width:  { min: w_min, max: w_max },
        height: { min: h_min, max: h_max },
      }
    end
  end
end
