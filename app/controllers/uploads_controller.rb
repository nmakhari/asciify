require 'rubygems'
require 'rmagick'

class UploadsController < ApplicationController

  def index
    @pagy, @uploads = pagy(Upload.with_attached_image.all.reverse_order)
  end

  def show
    @upload = Upload.find(params[:id])
  end

  def new
    @upload = Upload.new
  end

  def create
    # create the original object without tag string in params
    @upload = Upload.new(upload_params.merge!(ascii: get_image_ascii).except(:tags_string))

    # accept a comma separated list of tags
    tag_list = upload_params[:tags_string].delete(' ').split(',')
    current_tag_titles = []
    tag_list.each do |tag|
      next if tag.in?(current_tag_titles)
      existing_tag = Tag.find_by title: tag
      if existing_tag.present?
        @upload.tags << existing_tag
        current_tag_titles.append(existing_tag.title)
      else
        new_tag = Tag.new(title: tag)
        if new_tag.save
          @upload.tags << new_tag
          current_tag_titles.append(new_tag.title)
        end
      end
    end

    if @upload.save
      redirect_to @upload
    else
      render('new')
    end
  end

  def search
    @uploads = Upload.ransack(title_cont: params[:q]).result(distinct: true)
    @tags = Tag.ransack(title_cont: params[:q]).result(distinct: true)

    respond_to do |format|
      format.html {}
      format.json {
        @uploads = @uploads.limit(3)
        @tags = @tags.limit(3)
      }
    end
  end

  def get_image_ascii
    return "no image provided" unless upload_params[:image].present?
    convert_to_ascii
  end
  private

  def upload_params
    params.require(:upload).permit(:title, :image, :tags_string)
  end

  def convert_to_ascii
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
end
