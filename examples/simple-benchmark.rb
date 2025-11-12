Termbox2.init

time = Time.now

begin
  while true
    new_time = Time.now
    duration = new_time - time
    time = new_time

    Termbox2.print(0, 0, 0, 0, "Duration of the cycle #{duration}")
    Termbox2.present

    event = TB2.poll_event
    Termbox2.clear
    break if event[:ch].chr == 'q'
  end
ensure
  Termbox2.shutdown
end
