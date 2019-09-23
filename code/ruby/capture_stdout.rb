# Capture: module lets you intercept puts's and do whatever you want with it

module Capture
  def self.stdout
    out = StringIO.new
    $stdout = out
    yield
    STDOUT.puts "Caputred:"
    out.string.split("\n").each{|s| STDOUT.puts " > " + s}
    return out
  ensure
    $stdout = STDOUT
  end
end

# Example usage:
Capture.stdout {puts "Testing Capture"}

require 'stringio'

class CaptureStdout
  def initialize(&blk)
    @handler = blk
  end

  def capture
    StringIO.open do |io|
      stash = $stdout
      $stdout = io
      yield
      $stdout = stash
      handle_output(io)
    end
  end

  def handle_output(io)
    @handler.call(io.string)
  end
end

# define your capturer and its behavior
c = CaptureStdout.new{|s| s.each_line{|l| puts "Received: " + l.upcase}}
# caputre!
c.capture{ puts "hello"; puts "world" }