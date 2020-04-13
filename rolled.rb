
files = %w(
  rolled/cropped/alan_tenor.mp4
  rolled/cropped/ginny_soprano.mp4
  rolled/cropped/robin_soprano.mov
  rolled/cropped/johanna_soprano.mov
  rolled/cropped/jonathan_bass.mov
  rolled/cropped/ginny_alto.mp4
  rolled/cropped/josh_bass.mov
  rolled/cropped/karen_alto.mp4
)

# filter_complex = %w(
#   [0:v]crop=540:720[one]
#   [1:v]crop=540:720[two]
#   [2:v]crop=540:720[three]
#   [3:v]crop=540:720[four]
#   [4:v]crop=540:720[five]
#   [5:v]crop=540:720[six]
#   [6:v]crop=540:720[seven]
#   [7:v]crop=540:720[eight]
#   [one][two]hstack[top_left]
#   [three][four]hstack[bottom_left]
#   [five][six]hstack[top_right]
#   [seven][eight]hstack[bottom_right]
#   [top_left][top_right]hstack[top]
#   [bottom_left][bottom_right]hstack[bottom]
#   [top][bottom]vstack,format=yuv420p[v]
# ).join("; ")

filter_complex = %w(
  [0:v][1:v]hstack[top_left]
  [2:v][3:v]hstack[bottom_left]
  [4:v][5:v]hstack[top_right]
  [6:v][7:v]hstack[bottom_right]
  [top_left][top_right]hstack[top]
  [bottom_left][bottom_right]hstack[bottom]
  [top][bottom]vstack,format=yuv420p[v]
).join("; ")

deets = %Q{-filter_complex "#{filter_complex}" -map "[v]" -ac 2 output.mp4}

inputs = files.map { |f| "-i #{f}" }.join(" ")

command = %Q{ffmpeg #{inputs} #{deets}}

`rm output.mp4`

puts command
`#{command}`

`open output.mp4`
