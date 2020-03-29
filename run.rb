
files = %w(
  barb.mov
  ginny.mp4
  johanna.mov
  jonathan.mov
  josh.mov
  karen.mp4
  nancy.mov
  robin.mov
)

filter_complex = %w(
  [0:v]crop=540:720[barb]
  [1:v]crop=540:720[ginny]
  [2:v]crop=540:720[johanna]
  [3:v]crop=540:720[jonathan]
  [4:v]crop=540:720[josh]
  [5:v]crop=540:720[karn]
  [6:v]crop=540:720[nancy]
  [7:v]crop=540:720[robin]
  [barb][ginny]hstack[top_left]
  [johanna][jonathan]hstack[bottom_left]
  [josh][karn]hstack[top_right]
  [nancy][robin]hstack[bottom_right]
  [top_left][top_right]hstack[top]
  [bottom_left][bottom_right]hstack[bottom]
  [top][bottom]vstack,format=yuv420p[v]
).join("; ")

deets = %Q{-filter_complex "#{filter_complex}" -map "[v]" -ac 2 output.mp4}

inputs = files.map { |f| "-i #{f}" }.join(" ")

command = %Q{ffmpeg #{inputs} #{deets}}

puts command
`#{command}`
