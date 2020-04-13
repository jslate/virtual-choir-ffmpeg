require 'json'
require 'open3'
require 'pry'

class Resizer
  DEFAULT_TARGET_WIDTH = 320
  DEFAULT_TARGET_HEIGHT = 360

  def initialize(
    video_file_name,
    scaled_file_name,
    cropped_file_name,
    target_height: DEFAULT_TARGET_HEIGHT,
    target_width: DEFAULT_TARGET_WIDTH)

    @video_file_name = video_file_name
    @scaled_file_name = scaled_file_name
    @cropped_file_name = cropped_file_name
    @target_height = target_height
    @target_width = target_width
  end

  def resize
    d = dimensions
    width = d[:width]
    height = d[:height]
    ratio = width < height ? @target_width / width.to_f : @target_height / height.to_f

    new_width = (width * ratio).to_i
    new_height = (height * ratio).to_i

    run_command(%(
      ffmpeg  -noautorotate -i #{@video_file_name} \
      #{scale(new_width, new_height)} \
      #{@scaled_file_name}
    ))

    run_command(%(
      ffmpeg -i #{@scaled_file_name} \
      #{crop(@target_width, @target_height)} \
      #{@cropped_file_name}
    ))
  end

  def scale(new_width, new_height)
    "-vf scale=#{new_width}:#{new_height}:flags=lanczos"
  end

  def crop(new_width, new_height)
    "-vf crop=#{new_width}:#{new_height}"
  end

  def dimensions
    json = run_command("/usr/local/bin/ffprobe -show_streams #{@video_file_name} -print_format json")
    data = JSON.parse(json).first.last.find { |d| d["width"] && d["height"]}
    # rotated = (JSON.parse(json).first.last.find { |d| d["tags"] }["tags"]["rotate"].to_i / 90).odd?
    # rotated ? { width: data["height"], height: data["width"] } : { width: data["width"], height: data["height"] }
    { width: data["width"], height: data["height"] }
  end

  def run_command(command)
    puts "running command #{command}"
    stdout, stderr, status = Open3.capture3(command)
    unless status.success?
      puts "Error occured, exiting! #{stderr}"
      exit(1)
    end
    stdout
  end
end
