require 'json'

def resize(video_file)
  target_width = 540
  target_height = 720

  json = `/usr/local/bin/ffprobe -show_streams #{video_file} -print_format json`

  data = JSON.parse(json).first.last.find { |d| d["width"] && d["height"]}

  width = data["width"]
  height = data["height"]

  ratio = width < height ? target_width / width.to_f : target_height / height.to_f

  new_width = (width * ratio).to_i
  new_height = (height * ratio).to_i

  new_file_name = video_file.gsub(/\.(mp4|mov)/) { "-new.#{$1}" }
  original_file_name = video_file.gsub(/\.(mp4|mov)/) { "-original.#{$1}" }

  `ffmpeg -i #{video_file} -vf scale=#{new_width}x#{new_height}:flags=lanczos #{new_file_name}`
  `mv #{video_file} #{original_file_name}`
  `mv #{new_file_name} #{video_file}`
end
