module Panes
  module SizingHelpers
    def max_width
      w_sizing[:max]
    end

    def min_width
      w_sizing[:max]
    end

    def width_type
      w_sizing[:type]
    end

    def max_height
      h_sizing[:max]
    end

    def min_height
      h_sizing[:max]
    end

    def height_type
      h_sizing[:type]
    end

    def available_width
      Sizing.available_width(w_sizing) || parent&.available_width
    end
  end

  class Node
    include SizingHelpers

    attr_accessor :id, :parent, :children
    attr_accessor :w_sizing, :h_sizing, :child_gap
    attr_accessor :x, :y, :width, :height
    attr_accessor :padding

    def initialize(id: nil, parent: nil, children: [], width: nil, height: nil, padding: [0], child_gap: 0)
      @id = id
      @children = children
      @parent = parent
      @x = @y = @height = @width = 0
      @w_sizing = Sizing.build(width)
      @h_sizing = Sizing.build(height)
      @padding = Padding[*padding]
      @child_gap = child_gap || 0
    end

    def parent=(node)
      return unless node

      @parent = node
      node.children << self
    end

    def ui(id: nil, width: nil, height: nil, padding: [0], child_gap: 0, &block)
      node_parent = self
      @children << node = Node.new(id: id, parent: self, width: width, height: height, child_gap: child_gap, padding: padding)

      if block
        node.instance_eval(&block)
      end

      # Setup first width
      case node.width_type
      when :fit
        node.width += node.padding[:left] +
                      node.padding[:right] +
                      [0, (node.children.length-1) * node.child_gap].max
      when :fixed
        node.width = node.max_width
        node_parent.width += node.width
      end

      # Setup height - TODO change this to another place later
      case node.height_type
      when :fit
        node.height += node.padding[:top] + node.padding[:bottom]
      when :fixed
        node.height = node.max_height
        node_parent.height = [node_parent.height, node.height].max
      end
    end

    def inspect
      to_h
    end

    def to_h
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
