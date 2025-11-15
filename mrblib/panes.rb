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
      unless node.grid_layout?
        growables, sized = node.children.partition(&:grown_width?)

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
          if parent&.fit_width?
            parent.width = [parent.width, node.width].max
          end
        end
      end

      if node.grid_layout?
        assign_grid_columns(node)
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
      unless node.grid_layout?
        growables, sized = node.children.reject(&:text?).partition(&:grown_height?)

        if node.left_right?
          if growables.any?
            max_height = [node.height - node.total_height_spacing, 0].max
            growables.each do |child|
              child.height = [max_height, child.max_height].min
            end
          end

          parent = node.parent
          if parent&.fit_height?
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
      end

      if node.grid_layout?
        assign_grid_rows(node)
      end

      node.children.each do |child|
        grow_height_containers(child)
      end
    end

    def assign_grid_columns(node)
      label = grid_container_label(node)
      ensure_grid_children!(node, label)

      inner_width = node.width - node.padding[:left] - node.padding[:right]
      if inner_width <= 0
        raise ArgumentError, "Grid container #{label} must have positive width"
      end

      layout = node.grid_layout.layout_columns(inner_width)
      node.grid_state[:columns] = layout

      node.grid_areas.each do |area|
        child = area.node
        child.width = node.grid_layout.span_size(layout, area.col_range)
        child.w_sizing = Sizing.fixed(child.width)
        position = child.grid_position || { x: 0, y: 0 }
        position[:x] = node.grid_layout.axis_start(layout, area.col_range.begin - 1)
        child.grid_position = position
      end
    end

    def assign_grid_rows(node)
      label = grid_container_label(node)
      ensure_grid_children!(node, label)

      inner_height = node.height - node.padding[:top] - node.padding[:bottom]
      if inner_height <= 0
        raise ArgumentError, "Grid container #{label} must have positive height"
      end

      assign_grid_columns(node) unless node.grid_state[:columns]

      layout = node.grid_layout.layout_rows(inner_height)
      node.grid_state[:rows] = layout

      node.grid_areas.each do |area|
        child = area.node
        child.height = node.grid_layout.span_size(layout, area.row_range)
        child.h_sizing = Sizing.fixed(child.height)
        position = child.grid_position || { x: 0, y: 0 }
        position[:y] = node.grid_layout.axis_start(layout, area.row_range.begin - 1)
        child.grid_position = position
      end
    end

    def ensure_grid_children!(node, label)
      grid_nodes = node.grid_areas.map(&:node)
      unless (node.children - grid_nodes).empty?
        raise ArgumentError, "All children of grid container #{label} must be declared via area"
      end
    end

    def grid_container_label(node)
      node.id ? node.id.inspect : '(anonymous)'
    end

    def set_positions(node, offset_x = 0, offset_y = 0)
      node.x = offset_x
      node.y = offset_y

      child_offset_x = offset_x + node.padding[:left]
      child_offset_y = offset_y + node.padding[:top]

      if node.grid_layout?
        node.children.each do |child|
          position = child.grid_position || { x: 0, y: 0 }
          set_positions(
            child,
            child_offset_x + position[:x],
            child_offset_y + position[:y]
          )
        end
      else
        node.children.each do |child|
          set_positions(child, child_offset_x, child_offset_y)

          if node.left_right?
            child_offset_x += child.width + node.child_gap
          else
            child_offset_y += child.height + node.child_gap
          end
        end
      end
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
