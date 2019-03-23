Duck volume in and out

```
sox -m
  -t wav "|sox -V1 inputfile.wav -t wav - fade t 0 2.2 0.4"
  -t wav "|sox -V1 inputfile.wav -t wav - trim 1.8 fade t 0.4 3.4 0.4 gain -6 pad 1.8"
  -t wav "|sox -V1 inputfile.wav -t wav - trim 4.8 fade t 0.4 0 0 pad 4.8"
```

Insert pauses into audio

```ruby
def extend_audio_command(input, working_file, output, fps, play_segments)
  cmd_lines = !working_file.present? && play_segments.length == 1 ? ["sox"] : ["sox -m"]
  cmd_lines << "'#{working_file}'" if working_file.present?
  pipes = play_segments.map do |seg|
    "|sox '#{input}' -t sox - #{audio_segment_filter(fps, seg)}"
  end
  cmd_lines += pipes.map{|pipe| "-v 1 -t sox \"#{pipe}\""}
  cmd_lines << "-t wav '#{output}'"
  return cmd_lines.join("\\\n  ")
end
```
