module Panes
  class Node
    include SizingHelpers

    attr_accessor :id, :parent, :children
    attr_accessor :type, :content, :wrap
    attr_accessor :border
    attr_accessor :w_sizing, :h_sizing, :child_gap
    attr_accessor :x, :y, :width, :height
    attr_accessor :padding

    def initialize(id: nil, parent: nil, children: [], width: nil, height: nil, padding: [0], child_gap: 0, type: :rectangle, content: '', wrap: true, border: nil)
      @id = id
      @children = children
      @parent = parent
      @content = content
      @wrap = wrap
      @type = type
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

    def total_width_spacing
      padding[:left] + padding[:right] + [0, (children.length-1) * child_gap].max
    end

    def total_height_spacing
      padding[:top] + padding[:bottom]
    end

    def ui(id: nil, width: nil, height: nil, padding: [0], child_gap: 0, border: nil, &block)
      node_parent = self
      @children << node = Node.new(
        id: id,
        parent: self,
        width: width,
        height: height,
        child_gap: child_gap,
        padding: padding,
        border: border
      )

      if block
        node.instance_eval(&block)
      end

      # Fit Width Adjustment
      if node.fit_width?
        node.width += node.total_width_spacing
      end

      if node_parent.fit_width?
        node_parent.width += node.min_width
      end

      # Fit Height Adjustment
      if node.fit_height?
        node.height += node.total_height_spacing
      end

      if node_parent.fit_height?
        node_parent.height = [node_parent.height, node.min_height].max
      end

      node
    end

    def text(content = '', id: nil, wrap: true, &block)
      node_parent = self
      @children << node = Node.new(
        id: id,
        parent: self,
        type: :text,
        content: content,
        wrap: wrap,
        width: Sizing.grow,
        height: Sizing.grow,
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
              bounding_box: bounding_box
            },
            {
              id: id,
              type: :rectangle,
              bounding_box: bounding_box(offset: -1)
            }
          ]
        else
          [
            {
              id: id,
              type: :rectangle,
              bounding_box: bounding_box
            }
          ]
        end
      when :inline_text
        result   = []
        y_offset = y

        child_enum = children.each
        child      = child_enum.next&.content.to_s
        child_pos  = 0

        new_cmd = ->(x0, y0) do
          { id: id, type: :text, text: "", bounding_box: { x: x0, y: y0, width: 0, height: 1 } }
        end

        Text.wrap(content, width: width).each do |line|
          cmd = new_cmd.call(x, y_offset)

          if line.empty?
            result << cmd
            y_offset += 1
            next
          end

          line_pos = 0
          while line_pos < line.length
            if child_pos >= child.length # get a new child
              result << cmd

              child     = child_enum.next&.content.to_s
              child_pos = 0
              cmd = new_cmd.call(cmd[:bounding_box][:x] + cmd[:bounding_box][:width], y_offset)
            end

            take = [line.length - line_pos, child.length - child_pos].min

            segment = child.byteslice(child_pos, take)
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
            bounding_box: { x: x, y: y + i, width: line.length, height: 1 }
          }
        end
      end
    end
  end
end
