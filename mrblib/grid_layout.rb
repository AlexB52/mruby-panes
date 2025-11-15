module Panes
  class GridLayout
    Track = Struct.new(:type, :value)
    AreaAssignment = Struct.new(:node, :row_range, :col_range)

    attr_reader :columns, :rows, :gap

    def initialize(columns:, rows:, gap: 0)
      @gap = (gap || 0).to_i
      raise ArgumentError, 'Grid gap must be non-negative' if @gap < 0

      @columns = parse_tracks(columns, :columns)
      @rows = parse_tracks(rows, :rows)

      if @columns.empty? || @rows.empty?
        raise ArgumentError, 'Grid requires at least one row and one column'
      end
    end

    def track_count(axis)
      case axis
      when :columns then columns.length
      when :rows    then rows.length
      else 0
      end
    end

    def layout(container_width:, container_height:)
      {
        columns: layout_columns(container_width),
        rows:    layout_rows(container_height)
      }
    end

    def layout_columns(container_width)
      layout_axis(columns, container_width, :columns)
    end

    def layout_rows(container_height)
      layout_axis(rows, container_height, :rows)
    end

    def range_length(range)
      range_end = range.end
      range_end -= 1 if range.exclude_end?
      range_end - range.begin + 1
    end

    def axis_start(layout_axis, index)
      layout_axis[:offsets][index]
    end

    def span_size(layout_axis, range)
      size = 0
      last_index = normalized_index(range.end, range.exclude_end?)
      first_index = normalized_index(range.begin)

      (first_index..last_index).each do |i|
        size += layout_axis[:sizes][i]
        size += gap if i < last_index
      end

      size
    end

    private

    def parse_tracks(definition, axis)
      tokens = tokenize(definition)
      tokens.map do |token|
        parse_track_token(token, axis)
      end
    end

    def tokenize(definition)
      return [] unless definition

      result = []
      current = ''

      definition.to_s.each_byte do |byte|
        if whitespace_byte?(byte)
          unless current.empty?
            result << current
            current = ''
          end
        else
          current << byte.chr
        end
      end

      result << current unless current.empty?
      result
    end

    def parse_track_token(token, axis)
      if integer_token?(token)
        Track.new(:fixed, token.to_i)
      elsif token.end_with?('%')
        value = token[0...-1]
        validate_numeric_token!(value, axis, token)
        Track.new(:percent, value.to_f)
      elsif token.end_with?('fr')
        value = token[0...-2]
        validate_numeric_token!(value, axis, token)
        Track.new(:fr, value.to_f)
      else
        raise ArgumentError, "Invalid grid track token: '#{token}' in #{axis} definition"
      end
    end

    def layout_axis(tracks, container_size, axis)
      if container_size <= 0
        raise ArgumentError, "Grid container #{axis == :columns ? 'width' : 'height'} must be positive"
      end

      sizes = compute_sizes(tracks, container_size)
      offsets = []
      cursor = 0
      tracks.length.times do |i|
        offsets << cursor
        cursor += sizes[i]
        cursor += gap if i < tracks.length - 1
      end

      { sizes: sizes, offsets: offsets }
    end

    def compute_sizes(tracks, container_size)
      track_sizes = base_track_sizes(tracks, container_size)
      distribute_leftover(track_sizes, container_size, tracks.length)
    end

    def base_track_sizes(tracks, container_size)
      total_gaps = gap * [tracks.length - 1, 0].max
      total_fixed = 0
      percent_sizes = []
      total_percent = 0.0
      total_fr = 0.0

      tracks.each_with_index do |track, idx|
        case track.type
        when :fixed
          total_fixed += track.value
        when :percent
          size = container_size * (track.value / 100.0)
          percent_sizes[idx] = size
          total_percent += size
        when :fr
          total_fr += track.value
        end
      end

      free_space = container_size - total_fixed - total_percent - total_gaps
      free_space = 0 if free_space < 0

      tracks.each_with_index.map do |track, idx|
        case track.type
        when :fixed
          track.value
        when :percent
          percent_sizes[idx]
        when :fr
          if total_fr.zero?
            0
          else
            free_space * (track.value / total_fr)
          end
        end
      end
    end

    def distribute_leftover(track_sizes, container_size, track_count)
      available = container_size - gap * [track_count - 1, 0].max
      floored = track_sizes.map { |size| size.floor }
      fractional = track_sizes.map.with_index do |size, index|
        [size - size.floor, index]
      end
      fractional_total = fractional.sum { |(frac, _)| frac }

      leftover = available - floored.sum
      return floored if leftover <= 0 || fractional_total <= 0

      order = fractional.sort do |(frac_a, idx_a), (frac_b, idx_b)|
        if frac_a == frac_b
          idx_a <=> idx_b
        else
          frac_b <=> frac_a
        end
      end

      i = 0
      while leftover > 0 && order.any?
        _, idx = order[i % order.length]
        floored[idx] += 1
        leftover -= 1
        i += 1
      end

      floored
    end

    def normalized_index(value, exclude_end = false)
      index = value.to_i
      index -= 1 if exclude_end
      index - 1
    end

    def whitespace_byte?(byte)
      byte == 32 || byte == 9 || byte == 10 || byte == 13
    end

    def integer_token?(value)
      return false unless value
      return false if value.empty?

      value.each_byte.all? { |byte| digit_byte?(byte) }
    end

    def validate_numeric_token!(value, axis, token)
      unless numeric_token?(value)
        raise ArgumentError, "Invalid grid track token: '#{token}' in #{axis} definition"
      end
    end

    def numeric_token?(value)
      return false unless value
      return false if value.empty?

      dot_seen = false
      value.each_byte do |byte|
        if byte == 46
          return false if dot_seen
          dot_seen = true
        elsif !digit_byte?(byte)
          return false
        end
      end

      true
    end

    def digit_byte?(byte)
      byte >= 48 && byte <= 57
    end


    class Builder
      def initialize(node, layout)
        @node = node
        @layout = layout
      end

      def area(name = nil, row:, col:, **attrs, &block)
        row_range = normalize_axis(row, :rows, name)
        col_range = normalize_axis(col, :columns, name)

        validate_dimension_options!(attrs, name)

        options = attrs.dup
        options[:id] = name if name && !options.key?(:id)
        options[:width] = Panes::Sizing.fixed(0)
        options[:height] = Panes::Sizing.fixed(0)

        area_node = @node.ui(**options, &block)
        @node.grid_areas << AreaAssignment.new(area_node, row_range, col_range)
        area_node
      end

      private

      def normalize_axis(value, axis, area_name)
        count = @layout.track_count(axis)
        axis_label = single_axis_label(axis)
        plural_label = plural_axis_label(axis)

        range = case value
                when :all
                  if count.zero?
                    raise ArgumentError, "Grid area #{area_label(area_name)} cannot use :all for #{axis_label} when no #{plural_label} are defined"
                  end
                  1..count
                when Range
                  build_range(value, axis_label, area_name)
                when Integer
                  build_range(value..value, axis_label, area_name)
                else
                  raise ArgumentError, "Grid area #{area_label(area_name)} #{axis_label} must be an Integer, Range, or :all"
                end

        ensure_bounds(range, count, axis_label, plural_label, area_name)
      end

      def build_range(value, axis_label, area_name)
        first = coerce_index(value.begin, axis_label, area_name)
        last_value = value.end
        last_value = last_value - 1 if value.exclude_end?
        last = coerce_index(last_value, axis_label, area_name)

        if last < first
          raise ArgumentError, "Grid area #{area_label(area_name)} #{axis_label} range must be increasing"
        end

        first..last
      end

      def ensure_bounds(range, count, axis_label, plural_label, area_name)
        if range.begin < 1
          raise ArgumentError, "Grid area #{area_label(area_name)} #{axis_label} indices must be >= 1"
        end

        if range.end > count
          raise ArgumentError, "Grid area #{area_label(area_name)} refers to #{axis_label} #{range.end} but only #{count} #{plural_label} are defined"
        end

        range
      end

      def validate_dimension_options!(attrs, area_name)
        if attrs.key?(:width) || attrs.key?(:height)
          raise ArgumentError, "Grid area #{area_label(area_name)} derives its size from the grid definition"
        end
      end

      def coerce_index(value, axis_label, area_name)
        Integer(value)
      rescue ArgumentError, TypeError
        raise ArgumentError, "Grid area #{area_label(area_name)} #{axis_label} index must be numeric"
      end

      def area_label(name)
        name ? name.inspect : '(anonymous)'
      end

      def single_axis_label(axis)
        axis == :rows ? 'row' : 'col'
      end

      def plural_axis_label(axis)
        axis == :rows ? 'rows' : 'columns'
      end
    end
  end
end
