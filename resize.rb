require "./utils"

files = %w(
  robin_soprano.mov
  johanna_soprano.mov
  jonathan_bass.mov
  josh_bass.mov
  alan_tenor.mp4
  ginny_alto.mp4
  ginny_soprano.mp4
  karen_alto.mp4
)

files.each do |file|
  resizer = Resizer.new(
    "rolled/originals/#{file}",
    "rolled/scaled/#{file}",
    "rolled/cropped/#{file}",
  )
  resizer.resize
end
