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

      @tree.children.flat_map do |node|
        build_commands(node)
      end
    end
    alias :build :ui

    def build_commands(node, offset_x: 0, offset_y: 0)
      command = node.to_h
      command[:bounding_box][:x] += offset_x
      command[:bounding_box][:y] += offset_y

      [command] + node.children.flat_map do |child|
        build_commands(
          child,
          offset_x: command[:bounding_box][:x],
          offset_y: command[:bounding_box][:y]
        )
      end
    end
  end
end
