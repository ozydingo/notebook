Downsample to 1 Hz frame rate

`ffmpeg -i data/rocking.mp4 -r 1 data/rocking-strobe.mp4`

Concatenate two video clips (omits audio):

`ffmpeg -t 10 -i data/rocking.mp4 -t 10 -i data/rocking-strobe.mp4 -filter_complex "concat=n=2" data/rocking-strobe-clip.mp4`

Looping / pausing frames

`... trim=start_frame=$FRAME:end_frame={$FRAME + 1}, loop={$NUM_LOOP_FRAMES-1}:1:0, setpts=N/FRAME_RATE/TB ...`

Filtering multiple segments with individual segment filters

```
ffmpeg -i $INPUT \
  -filter_complex " \
  [0:v] fifo, split=$NUM [v0] [v1] ... ; \
  [v0] ... [vout0]; \
  [v1] ... [vout1]; \
  ... ; \
  [v0] [v1] ... concat=n=$NUM, setpts=N/FRAME_RATE/TB, \
  "
```
