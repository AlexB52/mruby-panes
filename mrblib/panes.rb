module Panes
  def self.init(width:, height:)
    Layout.new(width: width, height: height)
  end

  class Layout
    def initialize(width:, height:)
      @width = width
      @height = height
      @tree = Node.new(id: "__root__", width: width, height: height)
    end

    def ui(**config, &block)
      @tree.ui(**config, &block)

      set_positions(@tree)

      @tree.children.flat_map do |node|
        build_commands(node)
      end
    end
    alias :build :ui

    def set_positions(node, offset_x = 0, offset_y = 0)
      node.x = offset_x
      node.y = offset_y

      node.children.each do |child|
        set_positions(
          child,
          offset_x + node.padding[:left],
          offset_y + node.padding[:top]
        )

        offset_x += child.width + node.child_gap
      end
    end

    def build_commands(node)
      [node.to_h] + node.children.flat_map do |child|
        build_commands(child)
      end
    end
  end
end
