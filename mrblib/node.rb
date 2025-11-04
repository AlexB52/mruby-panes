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

    def grown_width?
      width_type == :grow
    end

    def fixed_width?
      width_type == :fixed
    end

    def fit_width?
      width_type == :fit
    end

    def fixed_height?
      height_type == :fixed
    end

    def fit_height?
      height_type == :fit
    end

    def grown_height?
      height_type == :grow
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
      if fixed_width?
        @width = max_width
      end

      @h_sizing = Sizing.build(height)
      if fixed_height?
        @height = max_height
      end
      @padding = Padding[*padding]
      @child_gap = child_gap || 0
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
      case node.width_type
      when :fit
        node.width += node.total_width_spacing
      when :fixed
        node.width = node.max_width
        node_parent.width += node.width if node_parent.fit_width?
      end

      # Setup height - TODO change this to another place later
      case node.height_type
      when :fit
        node.height += node.padding[:top] + node.padding[:bottom]
      when :fixed
        node.height = node.max_height
        node_parent.height = [node_parent.height, node.height].max if node_parent.fit_width?
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
