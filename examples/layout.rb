commands = [
  {id: "root", type: :rectangle, bounding_box: {x: 0, y: 0, width: 200.0, height: 200} },
  {id: "navigation", type: :rectangle, bounding_box: {x: 0, y: 0, width: 50, height: 200} },
  {id: nil, type: :rectangle, bounding_box: {x: 0, y: 0, width: 20, height: 1} },
  {id: "world", type: :text, text: "Hello, World!", bounding_box: {x: 0, y: 0, width: 13, height: 1} },
  {id: nil, type: :rectangle, bounding_box: {x: 20, y: 0, width: 30.0, height: 3} },
  {id: "EOL", type: :text, text: "Lorem ipsum dolor sit amet,", bounding_box: {x: 20, y: 0, width: 27, height: 1} },
  {id: "EOL", type: :text, text: "consectetur adipisicing elit,", bounding_box: {x: 20, y: 1, width: 29, height: 1} },
  {id: "EOL", type: :text, text: "dolore magna aliqua", bounding_box: {x: 20, y: 2, width: 19, height: 1} },
  {id: "content", type: :rectangle, bounding_box: {x: 50, y: 0, width: 150.0, height: 21} },
  {id: "inline", type: :text, text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", bounding_box: {x: 60, y: 10, width: 56, height: 1} },
  {id: "inline", type: :text, text: "sed do eiusmod tempor incididunt ut", bounding_box: {x: 116, y: 10, width: 35, height: 1} },
  {id: "inline", type: :text, text: "labore et dolore magna aliqua. Ut enim ad minim veniam,", bounding_box: {x: 60, y: 11, width: 55, height: 1} },
  {id: nil, type: :text, text: "Another line down there", bounding_box: {x: 167.0, y: 10, width: 23, height: 1} },
]

Termbox2.init
begin
  Termbox2.clear
  Panes::TBRender.render_commands(commands, tb: Termbox2)
  Termbox2.present
  while true
    event = TB2.poll_event
    break if event[:ch].chr == 'q'
  end
ensure
  Termbox2.shutdown
end
