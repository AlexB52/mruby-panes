module Panes
  class Node
    include SizingHelpers
    include DirectionHelpers

    attr_accessor :id, :parent, :children
    attr_accessor :type, :content, :wrap
    attr_accessor :border
    attr_accessor :w_sizing, :h_sizing, :padding, :child_gap
    attr_accessor :x, :y, :width, :height
    attr_accessor :direction
    attr_accessor :bg_color, :fg_color
    attr_accessor :grid_layout, :grid_areas, :grid_position, :grid_state

    def initialize(
      id: nil, parent: nil, children: [],
      width: nil, height: nil,
      padding: [0], child_gap: 0,
      type: :rectangle, content: '', wrap: true, border: nil,
      direction: :left_right,
      bg_color: 0, fg_color: 0)

      @id = id
      @children = children
      @parent = parent
      @content = content
      @wrap = wrap
      @type = type
      @direction = direction
      @bg_color = Colors.parse(bg_color)
      @fg_color = Colors.parse(fg_color)
      @x = @y = @height = @width = 0
      @padding = Padding[*padding]
      @child_gap = child_gap || 0
      @border = Borders.parse(**(border || {}))
      if border
        @padding[:top]    += 1 if @border[:top]
        @padding[:right]  += 1 if @border[:right]
        @padding[:bottom] += 1 if @border[:bottom]
        @padding[:left]   += 1 if @border[:left]
      end

      @grid_layout = nil
      @grid_areas = []
      @grid_position = nil
      @grid_state = {}

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

    def grid_layout?
      !!grid_layout
    end

    def parent=(node)
      return unless node

      @parent = node
      node.children << self
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

    def grid(columns:, rows:, gap: 0, **_grid_options, &block)
      unless block_given?
        raise ArgumentError, 'grid requires a block'
      end

      if grid_layout?
        label = id ? id.inspect : '(anonymous)'
        raise ArgumentError, "Grid already defined for #{label}"
      end

      @grid_layout = GridLayout.new(columns: columns, rows: rows, gap: gap)
      @grid_areas = []
      @grid_state = {}

      builder = GridLayout::Builder.new(self, grid_layout)
      builder.instance_eval(&block)

      self
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

      unless node_parent.grid_layout?
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
      end

      node
    end

    def text(content = '', id: nil, wrap: true, bg_color: nil, fg_color: nil, &block)
      node_parent = self

      @children << node = Node.new(
        id: id,
        parent: self,
        type: :text,
        content: content,
        wrap: wrap,
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
      node.w_sizing = Sizing.grow(**boundaries[:width])
      node.h_sizing = Sizing.grow(**boundaries[:height])

      if node_parent.inline_text?
        node_parent.content += node.content
      end

      # Fit Width Adjustment - (unused)
      if node.fit_width?
        node.width += node.total_width_spacing
      end

      unless node_parent.grid_layout?
        if node_parent.fit_width?
          node_parent.width += node.min_width
        end
      end

      # Fit Height Adjustment - (unused)
      if node.fit_height?
        node.height += node.total_height_spacing
      end

      unless node_parent.grid_layout?
        if node_parent.fit_height?
          node_parent.height = [node_parent.height, node.min_height].max
        end
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
        result = [
         {
           id: id,
           type: :rectangle,
           bounding_box: bounding_box,
           bg_color: bg_color,
           fg_color: fg_color,
         }
        ]

        if border
          result << {
            id: id,
            type: :border,
            border: border,
            bounding_box: bounding_box,
            bg_color: bg_color,
            fg_color: fg_color,
          }
        end

        result
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
          cmd = new_cmd.call(x, y_offset, child.bg_color, child.fg_color)

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
          {
            id: id,
            type: :text,
            text: line,
            bounding_box: { x: x, y: y + i, width: line.length, height: 1 },
            bg_color: bg_color,
            fg_color: fg_color,
          }
        end
      end
    end
  end
end
