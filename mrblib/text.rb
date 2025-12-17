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

    Command = Struct.new(:text, :x, :y, :bg_color, :fg_color)

    def self.align_line(line, width, align)
      case align
      when :left   then line.ljust(width)
      when :right  then line.rjust(width)
      when :center then line.center(width)
      else              line
      end
    end

    def self.inline(inputs, width: nil, align: :left, wrap: false)
      width ||= inputs.map { |input| input[:text].length }.max

      out = []
      buffer = { fg_color: nil, bg_color: nil, x: 0, y: 0, width: width}
      x = 0
      y = 0

      inputs.each do |input|
        buffer[:fg_color] = input[:fg_color]
        buffer[:bg_color] = input[:bg_color]

        text = input[:text].dup

        while text != ''
          buffer[:width] = width - buffer[:x]

          if text[buffer[:width]] == nil

            line = text.strip
            if input[:text].end_with?("\s")
              line += "\s"
            end

            out << Command.new(line, buffer[:x], buffer[:y], buffer[:bg_color], buffer[:fg_color])

            buffer[:x] += line.length
            buffer[:y] = buffer[:y]
            text = ''

          elsif text[buffer[:width]] == "\s"
            line = text.byteslice(0, buffer[:width]).strip

            out << Command.new(line, buffer[:x], buffer[:y], buffer[:bg_color], buffer[:fg_color])

            buffer[:x] = 0
            buffer[:y] += 1
            text.bytesplice(0, buffer[:width], '').strip!

          else
            x = buffer[:width]
            x-= 1 until text[x] == "\s" || x == 0
            if x == 0
              line = text[buffer[:width]]
            else
              line = text.byteslice(0, x).strip
            end

            out << Command.new(line, buffer[:x], buffer[:y], buffer[:bg_color], buffer[:fg_color])

            buffer[:x] = 0
            buffer[:y] += 1
            text.bytesplice(0, x, '').strip!
          end
        end
      end

      out.group_by(&:y).each do |y, cmds|
        if cmds.count == 1
          cmd = cmds.first
          cmd.text = align_line(cmd.text, width, align)
        else
          line_length = cmds.sum { |cmd| cmd.text.length }

          case align
          when :left
            *others, cmd = cmds
            whitespace_count = width - line_length
            cmd.text = cmd.text + ' ' * whitespace_count

          when :right
            cmd, *others = cmds
            whitespace_count = width - line_length
            cmd.text = ' ' * whitespace_count + cmd.text
            others.each { |cmd| cmd.x += whitespace_count }

          when :center
            cmd1, *to_shift_position = cmds
            cmd2 = cmds.last

            count1 = count2 = (whitespace_count = width - line_length) / 2
            if whitespace_count.odd?
              count2 += 1
            end

            cmd1.text =  ' ' * count1 + cmd1.text
            cmd2.text =  cmd2.text + ' ' * count2
            to_shift_position.each { |cmd| cmd.x += count1 }
          else
            raise ArgumentError, "Unknown align type: #{align}"
          end
        end
      end

      out.map(&:to_h)
    end
  end
end
