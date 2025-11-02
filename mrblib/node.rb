module Panes
  class Node
    attr_accessor :id, :parent, :children, :w_sizing
    attr_accessor :x, :y, :width, :height
    attr_accessor :padding

    def initialize(id: nil, parent: nil, children: [], width: nil, height: nil, padding: [0])
      @id = id
      @children = children
      @parent = parent
      @x = @y = 0
      @w_sizing = Sizing.build(width)
      @height = height || 0
      @padding = Padding[*padding]
    end

    def max_width
      w_sizing[:max]
    end

    def width_type
      w_sizing[:type]
    end

    def available_width
      Sizing.available_width(w_sizing) || parent&.available_width
    end

    def parent=(node)
      return unless node

      @parent = node
      node.children << self
    end

    def ui(id: nil, width: nil, height: nil, padding: [0], child_gap: 0, &block)
      @children << node = Node.new(id: id, parent: self, width: width, padding: padding)

      if block
        node.instance_eval(&block)
      end

      content_width = 0
      tallest_child = 0
      gap = child_gap || 0
      last_index = node.children.length - 1

      node.children.each_with_index do |child, index|
        child.x = node.padding[:left] + content_width
        child.y = node.padding[:top]
        content_width += child.width
        content_width += gap if index < last_index
        tallest_child = [tallest_child, child.height].max
      end

      node.width = case node.width_type
        when :fixed
          node.max_width
        when :grow
          # 0
        when :fit
          node.padding[:left] + content_width + node.padding[:right]
        when :percent
          raise NotImplementedError, 'percent isn\'t supported'
        else
          raise 'not supposed to be there'
        end

      node.height = [
        height || 0,
        node.padding[:top] + tallest_child + node.padding[:bottom]
      ].max

      node
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
