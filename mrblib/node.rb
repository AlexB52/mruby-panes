module Panes
  class Node
    include Panes::SizingHelpers

    attr_accessor :id, :parent, :children
    attr_accessor :w_sizing, :h_sizing, :child_gap
    attr_accessor :x, :y, :width, :height
    attr_accessor :padding

    def initialize(id: nil, parent: nil, children: [], width: nil, height: nil, padding: [0], child_gap: 0)
      @id = id
      @children = children
      @parent = parent
      @x = @y = @height = @width = 0
      @padding = Padding[*padding]
      @child_gap = child_gap || 0

      @w_sizing = Sizing.build(width)
      if fixed_width?
        @width = min_width
      end

      @h_sizing = Sizing.build(height)
      if fixed_height?
        @height = min_height
      end
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

    def ui(id: nil, width: nil, height: nil, padding: [0], child_gap: 0, &block)
      node_parent = self
      @children << node = Node.new(id: id, parent: self, width: width, height: height, child_gap: child_gap, padding: padding)

      if block
        node.instance_eval(&block)
      end

      # Setup first width
      if node.fit_width?
        node.width += node.total_width_spacing
      end

      if node_parent.fit_width?
        node_parent.width += node.min_width
      end

      # Setup height - TODO change this to another place later
      if node.fit_height?
        node.height += node.total_height_spacing
      end

      if node_parent.fit_height?
        node_parent.height = [node_parent.height, node.min_height].max
      end
    end

    def inspect
      {
        id: id,
        child_gap: child_gap,
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

    def to_command
      {
        id: id,
        type: :rectangle,
        bounding_box: {
          x:      x,
          y:      y,
          width:  width,
          height: height
        }
      }
    end
  end
end
