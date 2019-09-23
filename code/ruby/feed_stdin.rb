#!/usr/bin/env ruby
# example code to monitor the STDOUT of a command and respond to STDIN
# based on pre-defined rules

require 'open4'
# do the command
pid, stdin, stdout, stderr = Open4.popen4("interactive_command")
puts "Starting"

ii = 0
out_buffer = ""
prompt_threshold = 1

# This thread monitors stdout and populates a buffer to be read and cleared by the input thread
stdout_thread = Thread.start do
  stdout.each_char do |c|
    out_buffer << c
    print c
  end
end

# This thread montiors the buffer created by the other thread and decides when to act.
stdin_thread = Thread.start do
  t0 = Time.now
  in_buffer = ""

  while stdout_thread.alive? do
    if out_buffer.length > in_buffer.length
      # Found new output, put it in our in_buffer
      t0 = Time.now
      in_buffer = out_buffer
    else
      # No new input, if we've been waiting long enough decide if we want to respond
      dt = Time.now - t0
      if dt > prompt_threshold
        # Example: get the last non-empty line
        prompt = in_buffer.split("\n").reject(&:empty?).last
        # Example: determine if line starts with "sudo"
        response = prompt =~ /^sudo\s/ ? "ok." : "no."
        # For educational purposes only
        puts "(( Was asked '#{prompt}', responded with '#{response}' ))"
        # reset the buffers
        out_buffer = ""
        in_buffer = ""
        t0 = Time.now
        # feed response to stdin
        begin
          stdin.puts response
        rescue => Errno::EPIPE
          puts "Broken pipe. We probably falesly triggered a prompt after the program exited."
        end
      end
    end
    # don't overload the cpu with needless cycles
    sleep(0.1)
  end
end

stdout_thread.join
stdin_thread.join
puts "Closed"
stdout.close
stderr.close
stdin.close
