module Panes
  def self.init(width:, height:)
    Layout.new(width: width, height: height)
  end

  class Node
    attr_reader :id, :parent, :children
    attr_accessor :x, :y, :width, :height
    def initialize(id: nil, parent: nil, children: [], width: nil, height: nil)
      @id = id
      @parent = parent
      @children = children
      @config = config
      @x = @y = 0.0
      @width = width || 0
      @height = height || 0
    end

    def ui(id: nil, width: nil, height: nil, &block)
      self.children << node = Node.new(id: id, parent: self)

      if block
        block.call(node)
      end

      offset = 0.0
      children.each do |child|
        child.x = offset
        offset += child.width.to_f
        self.width += child.width.to_f
        self.height = [self.height, child.height].max
      end

      if width
        node.width = width.to_f
      end

      if height
        node.height = height.to_f
      end

      node
    end

    def to_h
      {
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

  class Layout
    def initialize(width:, height:)
      @width = width
      @height = height
      @tree = Node.new(id: "__root__", width: width, height: height)
    end

    def ui(**config, &block)
      @tree.ui(**config, &block)

      @tree.children.flat_map do |node|
        build_commands(node)
      end
    end
    alias :build :ui

    def build_commands(node)
      [node.to_h] + node.children.flat_map do |child|
        build_commands(child)
      end
    end
  end
end