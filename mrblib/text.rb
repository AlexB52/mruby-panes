module Panes
  module Text
    def self.wrap(content, width:)
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
            result << buffer
            buffer = word
          end
        end
        result << buffer
      end
      result
    end
  end
end