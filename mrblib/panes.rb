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

      grow_width_containers(@tree)
      grow_height_containers(@tree)
      set_positions(@tree)

      @tree.children.flat_map do |node|
        build_commands(node)
      end
    end
    alias :build :ui

    def grow_width_containers(node)
      growables, sized = node.children.partition(&:grown_width?)
      if growables.any?
        extra_width = [0, node.width - node.total_width_spacing - sized.sum(&:width)].max
        current_sizes = growables.map do |node|
          {
            current: node.width,
            min: node.min_width,
            max: node.max_width
          }
        end

        Calculations
          .water_fill_distribution(current_sizes, extra_width)
          .each.with_index do |extra, i|
            growables[i].width += extra
          end
      end

      node.children.each do |child|
        grow_width_containers(child)
      end
    end

    def grow_height_containers(node)
      growables, sized = node.children.partition(&:grown_height?)
      if growables.any?
        max_height = [node.height - node.total_height_spacing, 0].max
        growables.each do |child|
          child.height = [max_height, child.max_height].min
        end
      end

      node.children.each do |child|
        grow_height_containers(child)
      end
    end

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
      [node.to_command] + node.children.flat_map do |child|
        build_commands(child)
      end
    end
  end
end
