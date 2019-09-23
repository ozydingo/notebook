class CaptionFile

  attr_reader :frame, :input_frame_number, :output_frame_number, :duration
  attr_accessor :header, :footer
  attr_reader :file

  @@formats = {}

  def initialize(file, *opt)
    options = {}
    options.merge!(opt.pop) if !opt.empty? && opt.last.is_a?(Hash)

    @frame = nil
    @mode = options[:mode] || (file==STDOUT ? 'w' : 'r')
    @encoding = options[:encoding] || "UTF-8"
    @input_frame_number = 0
    @output_frame_number = 0
    @header = []
    @footer = []
    @garbage = []
    @file = file==STDOUT ? STDOUT : open(file,*opt)
  end

  #sub-classes should call this to register their extension
  def self.extension(*extensions)
    extensions.each{|ext| @@formats[ext] = self.name}
  end
  def self.list_extensions()
    @@formats.each{|ext,klass| puts "#{ext}: #{klass}"}
  end

  # open a new or existing caption file, return an instnace of a CaptionFile
  def self.open(file, *opt)
    options = {format: nil}
    options.merge!(opt.pop) if !opt.empty? && opt.last.is_a?(Hash)

    format = (options.delete(:format) || (file.is_a?(String) && file.split(/\./).last).downcase)
    format or raise "No format detected"
    class_name = @@formats[format] or raise "Unknown caption format #{format}"
    captions = Module.const_get(class_name).new(file, options)
    if block_given?
      yield(captions)
      captions.close
    else
      return captions
    end
  end

  # Ouput frames in specified format, auto-detected from output file name
  # or overridden by format: fmt in arguments
  def convert(output_file, *opt)
    options = {}
    options.merge!(opt.pop) if !opt.empty? && opt.last.is_a?(Hash)

    converted = CaptionFile.open(output_file, options.merge(mode: 'w'))

    converted.print_header
    each_frame{|frame| converted.print_frame(frame)}
    converted.print_footer

    converted.close
  end

  # Allow iteration over frames
  def each_frame
    rewind
    if block_given?
      loop {yield next_frame}
    else
      return self.to_enum(:each_frame)
    end
  rescue StopIteration => e
  end

  # get next frame. Depends on ingest_frame, which must be implmented by subclasses
  def next_frame
    raise(StopIteration, "End of file") if @file.eof?
    @garbage = []
    @frame = {}
    ingest_frame
    @input_frame_number += 1 if !@frame.empty?
    frame["index"] ||= @input_frame_number
    @footer = @garbage if @file.eof?
    if @input_frame_number > 1 && !@file.eof? && !@garbage.empty?
      STDERR.puts "Extra text found:\n #{@garbage * ""}"
    end
    unless ["start_time", "end_time", "content"].all?{|k| @frame.has_key?(k)}
      if @file.eof?
        raise StopIteration, "No more valid frames"
      else
        raise "Invalid frame and not EOF: #{frame}"
      end
    end
    return @frame
  end

  # next_frame without StopIteration error
  def get_frame
    next_frame
  rescue StopIteration => e
    return nil
  end

  def rewind
    @file.rewind
    ignore_bom
    @input_frame_number = 0
    @output_frame_number = 0 if @mode =~ /w/
    return self
  end

  def ignore_bom
    return unless @file.pos==0
    char = @file.getc
    return if char == "\xEF\xBB\xBF".force_encoding("UTF-8")
    @file.ungetc(char)
  end

  def scan
    frame = nil
    each_frame{|f| frame = f}
    @duration = frame["end_time"] || frame["start_time"]
    return self
  end

  def print_header()
    @header.each{|line| output_stream.print line.chop + "\n"}
  end

  def print_frame(frame = @frame)
    return if frame.nil?
    frame.is_a?(Hash) or raise "Expecting frame as a Hash"
    frame = frame.dup
    frame["index"] = @output_frame_number+=1
    output_stream.print format_frame(frame) + "\n"
  end

  def print_footer
    @footer.each{|line| output_stream.print line.chop + "\n"}
  end

  def output_stream
    @mode =~ /w/ ? @file : STDOUT
  end

  def close
    @file.close unless @file.tty?
  end

  private

  # instance method to open file
  def open(filename)
    @file.nil? or raise "Caption file already set"
    @filename = filename
    @file = File.open(@filename, "#{@mode}:#{@encoding}")
    if @mode =~ /r/
      read_header
      parse_header
      scan
      rewind
    end
    return @file
  end

  def hms2sec(time_string)
    time_string.gsub(",",".").split(":").map(&:to_f).zip([3600,60,1]).reduce(0){|secs,x| secs+x.first * x.last}
  end
  def sec2hms(time,decimal='.')
    msec = ((time % 1) * 1000).round.to_i
    time = time.to_i
    sec = time % 60
    min = ((time-sec)/60) % 60
    hr = (time-60*min-sec)/3600
    return sprintf("%0.2d:%0.2d:%0.2d%s%0.3d",hr,min,sec,decimal,msec)
  end

end

class File
  def peek_line
    cur = self.pos
    line = gets
    seek(cur)
    return line
  end
end

class VTTCaptionFile < CaptionFile
  extension "vtt"
  private

  TIME_REGEX = /\d+\:\d+\:\d+(?:\.|,)\d+/
  TIME_FORMAT = "%0.2d:%0.2d:%0.3f"

  def line_matches_caption?(line)
    !detect_caption_info(line).empty?
  end

  def detect_caption_info(line)
    if line =~ /^(#{TIME_REGEX})\s*\-\-(?:\>|\&gt\;)\s*(#{TIME_REGEX})(.*)$/
      {"start_time" => hms2sec($1), "end_time" => hms2sec($2), "params" => $3}
    else
      {}
    end
  end

  def read_header
    while !line_matches_caption?(@file.peek_line)
      line = @file.gets or break
      @header << line
    end
  end

  def parse_header
  end

  def ingest_frame
    @frame = {}
    while line = @file.gets
      @frame = detect_caption_info(line)
      break if !@frame.empty?
      @garbage << line
    end
    @frame["content"] = @file.gets   #force get the first line, in some cases it is blank
    @frame["content"] += line while (line = @file.gets) =~ /\S/
    @frame["content"].chop! unless @frame["content"].nil?
    return @frame
  end

  def format_frame(frame=@frame)
    [
      "#{sec2hms(frame["start_time"],',')} --> #{sec2hms(frame["end_time"],',')}#{frame["params"]}",
      "#{frame["content"]}",
      ""
    ] * "\n"
  end
end

class SRTCaptionFile < CaptionFile
  extension "srt"
  private

  TIME_REGEX = /\d+\:\d+\:\d+(?:\.|,)\d+/
  TIME_FORMAT = "%0.2d:%0.2d:%0.3f"

  def detect_caption_info(line)
    info = detect_caption_number(line)
    #!info.empty? or info = detect_caption_times(line)
    return info
  end

  def detect_caption_number(line)
    line =~ /^\s*\d+\s*$/ ? {"index" => line.to_i} : {}
  end

  def detect_caption_times(line)
    line =~ /^(#{TIME_REGEX})\s*\-\-(?:\>|\&gt\;)\s*(#{TIME_REGEX})\s*$/ ? {"start_time" => hms2sec($1), "end_time" => hms2sec($2)} : {}
  end

  def read_header
    @header = []
  end

  def parse_header
  end

  def ingest_frame
    @frame = {}
    while line = @file.gets
      info = detect_caption_info(line)
      break if !info.empty?
      @garbage << line
    end
    @frame.merge!(info)
    info = detect_caption_times(@file.gets) unless info.has_key?("start_time")
    @frame.merge!(info)
    @frame["content"] = @file.gets   #force get the first line, in some cases it is blank
    @frame["content"] += line while (line = @file.gets) =~ /\S/
    @frame["content"].chop! unless @frame["content"].nil?
    return @frame
  end

  def format_frame(frame=@frame)
    [
      "#{frame["index"]}",
      "#{sec2hms(frame["start_time"],',')} --> #{sec2hms(frame["end_time"],',')}",
      "#{frame["content"]}",
      ""
    ] * "\n"
  end
end

class XMLCaptionFile < CaptionFile
#  extension "dfxp"
  private

  def line_matches_caption?(line)
    line =~ /^(\s*)\<p((?:\s+[^\>]+\s*\=(?:\"[^\"]*\"|\'[^\']*\'))*\s*)\>(.*)\<\/p>\s*$/
  end

  def read_header
    while !line_matches_caption?(@file.peek_line)
      line = @file.gets or break
      @header << line
    end
  end

  def parse_header
  end

  def ingest_frame
    @frame = {}
    while !@file.eof? && @frame.empty?
      line = @file.gets
      #TODO: true XML parsing
      #TODO: parse additional attributes
      if line =~ /^(\s*)\<p((?:\s+[^\>]+\s*\=(?:\"[^\"]*\"|\'[^\']*\'))*\s*)\>(.*)\<\/p>\s*$/
        @frame["indent"] = $1
        params = $2
        @frame["content"] = $3
        params =~ /begin\s*\=\s*[\"\']([^\"\']+)[\"\']/ and @frame["start_time"] = read_time($1)
        params =~ /end\s*\=\s*[\"\']([^\"\']+)[\"\']/ and @frame["end_time"] = read_time($1)
      else        
        @garbage << line
      end
    end
    return @frame
  end

  def format_frame(frame=@frame)
    #TODO: put in attributes that actually exist
    "#{frame["indent"]}<p begin=\"#{format_time(frame["start_time"])}\" end=\"#{format_time(frame["end_time"])}\" region=\"speaker\">#{frame["content"]}</p>"
  end

end

class TTCaptionFile < XMLCaptionFile
  extension "tt", "xml"

  attr_accessor :framerate

  def initialize(file, *opt)
    options = {}
    options.merge!(opt.pop) if !opt.empty? && opt.last.is_a?(Hash)
    super(file, options)
    if @mode =~ /w/
      @framerate = options[:framerate] or raise "Must provide framerate for timed text"
    end
  end

  def parse_header
    @header.find{|line| line =~ /frameRate\s*=\s*[\"\']?(\d+)[\"\']?/}
    @framerate = ($1 || 30).to_f
    @header.find{|line| line =~ /frameRateMultiplier\s*=\s*[\"\']?(\d+)[\s\:]+(\d+)[\"\']?/}
    if $1.nil?
      @framerate_multiplier = 1000.0/1001
    else
      @framerate_multiplier = $1.to_f / ($2 || 1).to_f
    end
    @framerate = @framerate * @framerate_multiplier
  end

  def read_time(time_string)
    time_string.gsub(",",".").split(":").map(&:to_f).zip([3600,60,1,1/@framerate]).reduce(0){|secs,x| secs + x.first * x.last}
  end
  def format_time(seconds)
    frames = ((seconds % 1) * @framerate).round.to_i
    seconds = seconds.to_i
    sec = seconds % 60
    min = ((seconds-sec)/60) % 60
    hr = (seconds-60*min-sec)/3600
    return sprintf("%0.2d:%0.2d:%0.2d:%0.2d",hr,min,sec,frames)
  end
end

class DFXPCaptionFile < XMLCaptionFile
  extension "dfxp"

  def read_time(time_text)
    hms2sec(time_text)
  end

  def format_time(seconds)
    sec2hms(seconds)
  end
end


