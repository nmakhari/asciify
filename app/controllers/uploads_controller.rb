require 'rubygems'
require 'rmagick'

class UploadsController < ApplicationController
  def index
    @uploads = Upload.all.reverse_order
  end

  def show
    @upload = Upload.find(params[:id])
  end

  def info
  end

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params.merge!(ascii: convert_to_ascii))
    if @upload.save
      redirect_to @upload
    else
      render('new')
    end
  end

  private
  
  def upload_params
    params.require(:upload).permit(:title, :image)
  end

  def prepare_image
    img = Magick::Image.from_blob(upload_params[:image].read).first
    width = img.columns
    height = img.rows
    # resize the image
    ratio = (height.to_f / width) / 2.to_f
    new_width = 150
    new_height = new_width * ratio
    img.scale!(new_width, new_height)
    # greyscale the image
    img.quantize(256, Magick::GRAYColorspace)
  end

  def convert_to_ascii
    return "no image provided" unless upload_params[:image].present?
    ascii_map = {0 => " ", 1 => ".", 2 => ",", 3 => ":", 4 => ";", 5 => "o", 6 => "x", 7 => "%", 8 => "#", 9 => "@"}
    img = prepare_image
    previous_row = 0
    ascii_string = ""
    img.each_pixel do |pixel, col, row|
      if row != previous_row
        previous_row = row
        ascii_string.concat("\n")
      end
      ascii_string.concat(ascii_map[(255 - (pixel.intensity / 256) ) * 10/256])
    end
    ascii_string
  end
end
