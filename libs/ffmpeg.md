Downsample to 1 Hz frame rate

`ffmpeg -i data/rocking.mp4 -r 1 data/rocking-strobe.mp4`

Concatenate two video clips (omits audio):

`ffmpeg -t 10 -i data/rocking.mp4 -t 10 -i data/rocking-strobe.mp4 -filter_complex "concat=n=2" data/rocking-strobe-clip.mp4`
