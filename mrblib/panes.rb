module Panes
  def self.init(width:, height:)
    Layout.new(width: width, height: height)
  end

  class Layout
    attr_accessor :width, :height
    def initialize(width:, height:)
      @width = width
      @height = height
      @tree = nil
    end

    def ui(**config, &block)
      @tree = Node.new(id: "__root__", width: width, height: height)
      @tree.ui(**config, &block)

      grow_width_containers(@tree)
      wrap_text(@tree)
      grow_height_containers(@tree)
      set_positions(@tree)

      commands = []
      @tree.children.each { |node| build_commands(node, out: commands) }
      commands
    end
    alias :build :ui

    def grow_width_containers(node)
      flow_children = node.flow_children
      growables, sized = flow_children.partition(&:grown_width?)

      if node.left_right?
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
      else
        if growables.any?
          max_width = [node.width - node.total_width_spacing, 0].max
          growables.each do |child|
            child.width = [max_width, child.max_width].min
          end
        end

        parent = node.parent
        if parent&.fit_width? && !node.positioned?
          parent.width = [parent.width, node.width].max
        end
      end

      node.children.each do |child|
        grow_width_containers(child)
      end
    end

    def wrap_text(node)
      if node.text?
        lines = Text.wrap(node.content, width: node.width)
        node.height = lines.count
        return
      end

      node.children.each do |child|
        wrap_text(child)
      end
    end

    def grow_height_containers(node)
      flow_children = node.flow_children.reject(&:text?)
      growables, sized = flow_children.partition(&:grown_height?)

      if node.left_right?
        if growables.any?
          max_height = [node.height - node.total_height_spacing, 0].max
          growables.each do |child|
            child.height = [max_height, child.max_height].min
          end
        end

        parent = node.parent
        if parent&.fit_height? && !node.positioned?
          parent.height = [parent.height, node.height].max
        end
      else
        if growables.any?
          extra_height = [0, node.height - node.total_height_spacing - sized.sum(&:height)].max
          current_sizes = growables.map do |node|
            {
              current: node.height,
              min: node.min_height,
              max: node.max_height
            }
          end

          Calculations
            .water_fill_distribution(current_sizes, extra_height)
            .each.with_index do |extra, i|
              growables[i].height += extra
            end
        end
      end

      node.children.each do |child|
        grow_height_containers(child)
      end
    end

    def set_positions(node, offset_x = 0, offset_y = 0)
      node.x = offset_x
      node.y = offset_y

      content_x = offset_x + node.padding[:left]
      content_y = offset_y + node.padding[:top]
      flow_x = content_x
      flow_y = content_y

      node.children.each do |child|
        if child.positioned?
          child_x, child_y = relative_coordinates(node, child)
          set_positions(child, child_x, child_y)
        else
          set_positions(child, flow_x, flow_y)

          if node.left_right?
            flow_x += child.width + node.child_gap
          else
            flow_y += child.height + node.child_gap
          end
        end
      end
    end

    def relative_coordinates(parent, child)
      content_x = parent.x + parent.padding[:left]
      content_y = parent.y + parent.padding[:top]
      interior_width = parent.width - parent.padding[:left] - parent.padding[:right]
      interior_height = parent.height - parent.padding[:top] - parent.padding[:bottom]

      child_x = case child.position_horizontal
                when :left
                  content_x
                when :center
                  content_x + (interior_width - child.width) / 2
                when :right
                  content_x + interior_width - child.width
                end

      child_y = case child.position_vertical
                when :top
                  content_y
                when :middle
                  content_y + (interior_height - child.height) / 2
                when :bottom
                  content_y + interior_height - child.height
                end

      [child_x, child_y]
    end

    def build_commands(node, out: [])
      out.concat(node.to_commands)

      case node.type
      when :rectangle
        node.children.each do |child|
          build_commands(child, out: out)
        end
      end
    end
  end
end
