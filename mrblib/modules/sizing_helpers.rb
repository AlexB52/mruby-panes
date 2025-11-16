module Panes
  module SizingHelpers
    def max_width
      w_sizing[:max]
    end

    def min_width
      w_sizing[:min]
    end

    def width_type
      w_sizing[:type]
    end

    def width_percent
      w_sizing[:percent]
    end

    def max_height
      h_sizing[:max]
    end

    def min_height
      h_sizing[:min]
    end

    def height_type
      h_sizing[:type]
    end

    def height_percent
      h_sizing[:percent]
    end

    def grown_width?
      width_type == :grow
    end

    def fixed_width?
      width_type == :fixed
    end

    def fit_width?
      width_type == :fit
    end

    def percent_width?
      width_type == :percent
    end

    def grown_height?
      height_type == :grow
    end

    def fixed_height?
      height_type == :fixed
    end

    def fit_height?
      height_type == :fit
    end

    def percent_height?
      height_type == :percent
    end
  end
end
