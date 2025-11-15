module Panes
  class Node
    include SizingHelpers
    include DirectionHelpers

    attr_accessor :id, :parent, :children
    attr_accessor :type, :content, :wrap, :align
    attr_accessor :border
    attr_accessor :w_sizing, :h_sizing, :padding, :child_gap
    attr_accessor :x, :y, :width, :height
    attr_accessor :direction
    attr_accessor :bg_color, :fg_color

    def initialize(
      id: nil, parent: nil, children: [],
      width: nil, height: nil,
      padding: [0], child_gap: 0,
      type: :rectangle, content: '', wrap: true, border: nil,
      align: :left,
      direction: :left_right,
      bg_color: 0, fg_color: 0)

      @id = id
      @children = children
      @parent = parent
      @content = content
      @wrap = wrap
      @type = type
      @align = normalize_align(align)
      @direction = direction
      @bg_color = Colors.parse(bg_color)
      @fg_color = Colors.parse(fg_color)
      @x = @y = @height = @width = 0
      @padding = Padding[*padding]
      @child_gap = child_gap || 0
      @border = border
      if border
        @padding[:top] += 1
        @padding[:right] += 1
        @padding[:bottom] += 1
        @padding[:left] += 1
      end

      @w_sizing = Sizing.build(width)
      if fixed_width?
        @width = min_width
      end

      @h_sizing = Sizing.build(height)
      if fixed_height?
        @height = min_height
      end
    end

    def text?
      type == :text || type == :inline_text
    end

    def inline_text?
      type == :inline_text
    end

    def parent=(node)
      return unless node

      @parent = node
      node.children << self
    end

    def align=(value)
      @align = normalize_align(value)
    end

    def alignment_offset(width_available)
      return 0 unless width_available
      return 0 if width_available <= 0

      available = width_available
      if available.is_a?(Float) && !available.finite?
        available = 0
      end
      available = available.floor

      case align
      when :right
        available
      when :center
        available / 2
      else
        0
      end
    end

    def total_width_spacing
      result = padding[:left] + padding[:right]
      if left_right?
        result += [0, (children.length-1) * child_gap].max
      end
      result
    end

    def total_height_spacing
      result = padding[:top] + padding[:bottom]
      if top_bottom?
        result += [0, (children.length-1) * child_gap].max
      end
      result
    end

    def ui(id: nil, width: nil, height: nil, padding: [0], child_gap: 0, border: nil, direction: :left_right, bg_color: nil, fg_color: nil, &block)
      node_parent = self

      @children << node = Node.new(
        id: id,
        parent: self,
        width: width,
        height: height,
        child_gap: child_gap,
        padding: padding,
        border: border,
        direction: direction,
        bg_color: bg_color || node_parent.bg_color,
        fg_color: fg_color || node_parent.fg_color,
      )

      if block
        node.instance_eval(&block)
      end

      if node.fit_width?
        node.width += node.total_width_spacing
      end

      if node.fit_height?
        node.height += node.total_height_spacing
      end

      if node_parent.fit_width?
        if node_parent.left_right?
          node_parent.width += node.min_width
        else
          node_parent.width = [node_parent.width, node.min_width].max
        end
      end

      if node_parent.fit_height?
        if node_parent.left_right?
          node_parent.height = [node_parent.height, node.min_height].max
        else
          node_parent.height += node.min_height
        end
      end

      node
    end

    def text(content = '', id: nil, wrap: true, align: :left, bg_color: nil, fg_color: nil, &block)
      node_parent = self

      @children << node = Node.new(
        id: id,
        parent: self,
        type: :text,
        content: content,
        wrap: wrap,
        align: align,
        width: Sizing.grow,
        height: Sizing.grow,
        bg_color: bg_color || node_parent.bg_color,
        fg_color: fg_color || node_parent.fg_color,
      )

      if block
        node.type = :inline_text
        node.instance_eval(&block)
      end

      boundaries = Calculations.text_size(node.content)
      unless node.wrap
        boundaries[:width][:min] = node.content.length
      end
      if node.align != :left
        boundaries[:width][:max] = Float::INFINITY
      end
      node.w_sizing = Sizing.grow(**boundaries[:width])
      node.h_sizing = Sizing.grow(**boundaries[:height])

      if node_parent.inline_text?
        node_parent.content += node.content
      end

      # Fit Width Adjustment - (unused)
      if node.fit_width?
        node.width += node.total_width_spacing
      end

      if node_parent.fit_width?
        node_parent.width += node.min_width
      end

      # Fit Height Adjustment - (unused)
      if node.fit_height?
        node.height += node.total_height_spacing
      end

      if node_parent.fit_height?
        node_parent.height = [node_parent.height, node.min_height].max
      end

      node
    end

    def inspect
      {
        id: id,
        child_gap: child_gap,
        type: type,
        wrap: wrap,
        content: content,
        w_sizing: w_sizing,
        h_sizing: h_sizing,
        bounding_box: {
          x:      x,
          y:      y,
          width:  width,
          height: height
        }
      }
    end

    def bounding_box(offset: 0)
      {
        x:      x - offset,
        y:      y - offset,
        width:  width  + 2 * offset,
        height: height + 2 * offset
      }
    end

    def to_commands
      case type
      when :rectangle
        if border
          [
            {
              id: id,
              type: :border,
              bounding_box: bounding_box,
              bg_color: bg_color,
              fg_color: fg_color,
            },
            {
              id: id,
              type: :rectangle,
              bounding_box: bounding_box(offset: -1),
              bg_color: bg_color,
              fg_color: fg_color,
            }
          ]
        else
          [
            {
              id: id,
              type: :rectangle,
              bounding_box: bounding_box,
              bg_color: bg_color,
              fg_color: fg_color,
            }
          ]
        end
      when :inline_text
        result   = []
        y_offset = y

        child_enum    = children.each

        child         = child_enum.next
        child_content = child&.content.to_s
        child_pos     = 0

        new_cmd = ->(x0, y0, bg_color = 0, fg_color = 0) do
          {
            id: id,
            type: :text,
            text: "",
            bounding_box: { x: x0, y: y0, width: 0, height: 1 },
            bg_color: bg_color,
            fg_color: fg_color,
          }
        end

        Text.wrap(content, width: width).each do |line|
          offset = alignment_offset(width - line.length)
          start_x = x + offset
          cmd = new_cmd.call(start_x, y_offset, child.bg_color, child.fg_color)

          if line.empty?
            result << cmd
            y_offset += 1
            next
          end

          line_pos = 0
          while line_pos < line.length
            if child_pos >= child_content.length # get a new child
              result << cmd

              child         = child_enum.next
              child_content = child&.content.to_s
              child_pos     = 0
              cmd = new_cmd.call(cmd[:bounding_box][:x] + cmd[:bounding_box][:width], y_offset, child.bg_color, child.fg_color)
            end

            take = [line.length - line_pos, child_content.length - child_pos].min

            segment = child_content.byteslice(child_pos, take)
            cmd[:text] << segment
            cmd[:bounding_box][:width] += take

            line_pos  += take
            child_pos += take + 1
          end

          result << cmd
          y_offset += 1
        end

        result
      when :text
        Text.wrap(content, width: width).map.with_index do |line, i|
          offset = alignment_offset(width - line.length)
          {
            id: id,
            type: :text,
            text: line,
            bounding_box: { x: x + offset, y: y + i, width: line.length, height: 1 },
            bg_color: bg_color,
            fg_color: fg_color,
          }
        end
      end
    end

    private

    ALIGNMENTS = [:left, :center, :right].freeze

    def normalize_align(value)
      sym = value.is_a?(String) ? value.to_sym : value
      ALIGNMENTS.include?(sym) ? sym : :left
    end
  end
end
