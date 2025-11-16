module Panes
  module Text
    def self.wrap(content, width:, align: :left)
      result = []
      lines = content.split("\n")
      lines.each do |line|
        if line.empty?
          result << ""
          next
        end

        buffer, *words = line.split
        words.each do |word|
          if buffer.length + 1 + word.length <= width
            buffer = format("%s %s", buffer, word)
          else
            result << align_line(buffer, width, align)
            buffer = word
          end
        end
        result << align_line(buffer, width, align)
      end
      result
    end

    def self.align_line(line, width, align)
      case align
      when :left   then line
      when :right  then line.rjust(width)
      when :center then line.center(width)
      else              line
      end
    end
  end
end