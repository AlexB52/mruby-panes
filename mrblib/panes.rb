module Panes
  def self.init(width:, height:)
    Layout.new(width: width, height: height)
  end

  class Node
    attr_reader :id, :parent, :children, :config
    def initialize(id: nil, parent: nil, children: [], config: {})
      @id = id
      @parent = parent
      @children = children
      @config = config
    end

    def ui(id: nil, width: nil, height: nil, &block)
      if block
        raise 'not here yet'
      end

      children << Node.new(
        id: id,
        parent: self,
        children: [],
        config: {
          type: :rectangle,
          x: 0.0,
          y: 0.0,
          width: width.to_f,
          height: height.to_f
        }
      )
    end
  end

  class Layout
    attr_reader :width, :height
    def initialize(width:, height:)
      @width = width
      @height = height
      @tree = Node.new(id: "__root__", config: { width: width, height: height })
    end

    def ui(**config, &block)
      @tree.ui(**config, &block)

      @tree.children.map do |node|
        {
          type: node.config[:type],
          bounding_box: {
            x:      node.config[:x],
            y:      node.config[:y],
            width:  node.config[:width],
            height: node.config[:height]
          }
        }
      end
    end
    alias :build :ui

    def debug(tree)
      puts
      puts <<~DEBUG
        #{tree.id}
        #{tree.config.inspect}
      DEBUG

      tree.children.each do |node|
        debug(node)
      end
    end
  end
end