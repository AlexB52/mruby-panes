module Panes
  class Node
    attr_reader :id, :parent, :children
    attr_accessor :x, :y, :width, :height
    def initialize(id: nil, parent: nil, children: [], width: nil, height: nil)
      @id = id
      @parent = parent
      @children = children
      @x = @y = 0
      @width = width || 0
      @height = height || 0
    end

    def ui(id: nil, width: nil, height: nil, padding: [0], &block)
      padding_values = Padding[*padding]

      self.children << node = Node.new(id: id, parent: self)

      if block
        block.call(node)
      end

      content_width = 0
      tallest_child = 0
      node.children.each do |child|
        child.x = padding_values[:left] + content_width
        child.y = padding_values[:top]
        content_width += child.width
        tallest_child = [tallest_child, child.height].max
      end

      node.width = [
        width || 0,
        padding_values[:left] + content_width + padding_values[:right]
      ].max

      node.height = [
        height || 0,
        padding_values[:top] + tallest_child + padding_values[:bottom]
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
