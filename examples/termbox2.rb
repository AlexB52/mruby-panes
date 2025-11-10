TB2.init
TB2.set_input_mode(:esc, :mouse)
TB2.print(0, 0, 0,0, "hello from termbox")
TB2.print(0, 1, 0,0, "press any key to quit...")
TB2.present
while true
  event = TB2.poll_event
  break if event[:ch].chr == 'q'
  TB2.print(0, 2, 0,0, event.inspect)
  TB2.present
end
TB2.tb_shutdown