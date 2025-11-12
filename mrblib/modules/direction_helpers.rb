module Panes
  module DirectionHelpers
    def left_right?
      direction == :left_right
    end

    def top_bottom?
      direction == :top_bottom
    end
  end
end
