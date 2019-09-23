#!/usr/bin/env ruby
require 'optparse'
require 'caption_file.rb'

@options = {}
OptionParser.new do |opts|
  opts.banner = [
    "#{$0} [OPTS] input_caption_file [output_caption_file]",
    "Process caption file. (Convert format, shift, ...?)",
    "Prints result to STDOUT unless output_caption_file is provided"
    ] * "\n"
  opts.on("-d", "--debug", "Print some debug info to stderr") do
    @options[:debug] = true
  end
  opts.on("-i", "--input-format FORMAT", String, "Format of input captions (default read from input filename extension)") do |x|
    @options[:input_format] = x
  end
  opts.on("-o", "--output-format FORMAT", String, "Format of output captions (default is read from output filename if provided, or input filename if not)") do |x|
    @options[:output_format] = x
  end
  opts.on("-s", "--shift SECONDS", Float, "Shift all caption frames by amount") do |x|
    @options[:shift] = x
  end
  opts.on("-d", "--drift SECONDS", Float, "Drift caption frames by specified amount per second relative to time 0:00:00") do |x|
    @options[:drift] = x+1
  end
  opts.on("-D", "--drift-fraction FLOAT", Float, "Drift caption frames by specified ratio: E.g. 0.9 means each second of input become 0.9 seconds of output.") do |x|
    @options[:drift] = x
  end
  opts.on("-r", "--framerate NUMBER", Float, "Framerate for output (only applies to some formats)") do |x|
    @options[:framerate] = x
  end
end.parse!

input_captions = ARGV.shift
output_captions = ARGV.shift
input_filename_parts = input_captions.split(/\./)
output_filename_parts = output_captions.to_s.split(/\./)

@options[:input_format] ||= input_filename_parts.last or raise "Cannot detect input caption format from input filename"
@options[:output_format] ||= output_filename_parts.last || @options[:input_format]

STDERR.puts "Processing #{File.basename input_captions} with #{@options}" if @options[:debug]

c_in = CaptionFile.open(input_captions)
c_options = {
  format: @options[:output_format],
  framerate: @options[:framerate] || (c_in.respond_to?(:framerate) && c_in.framerate),
  mode: "w"
}

c_out = CaptionFile.open(output_captions||STDOUT, c_options)

if @options[:output_format] == @options[:input_format]
  c_out.header = c_in.header
  c_out.footer = c_in.footer
end

c_out.print_header
c_in.each_frame do |frame|
  output_frame = frame.dup
  if @options[:drift]
    output_frame["start_time"] *= @options[:drift]
    output_frame["end_time"] *= @options[:drift]
  end
  if @options[:shift]
    output_frame["start_time"] += @options[:shift]
    output_frame["end_time"] += @options[:shift]
  end
  c_out.print_frame(output_frame)
end
c_out.print_footer
c_in.close
c_out.close
