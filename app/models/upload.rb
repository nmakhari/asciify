require 'rubygems'
require 'rmagick'

class Upload < ApplicationRecord
    attr_accessor :tags_string

    ASCII_MAP = {0 => " ", 1 => ".", 2 => ",", 3 => ":", 4 => ";", 5 => "o", 6 => "x", 7 => "%", 8 => "#", 9 => "@"}.freeze
    IMG_WIDTH = 150.freeze

    has_one_attached :image
    has_and_belongs_to_many :tags

    validates   :title, :presence => true,
                :length => { maximum: 30 }
    validates_presence_of    :ascii

    validate :validate_image_size_and_type
    
    validates_length_of :tags, :maximum => 5

    def validate_image_size_and_type
        if image.attached? == false
            errors.add(:image, "is missing!")
        elsif !image.content_type.in?(%('image/jpeg image/png'))
            errors.add(:image, "must be jpeg or png.")
        elsif image.byte_size > 10.megabytes
            errors.add(:image, "must be at most 10mb in size.")
        end
    end

    # simplifies the serialization of the job by only storing the method
    # rather than the entire object
    def self.generate_ascii_string(id)
        target = find(id)
        target.update(ascii: target.generate_ascii_string)
    end

    def prepare_image
        active_storage_disk_service = ActiveStorage::Service::DiskService.new(root: Rails.root.to_s + '/storage/')
        image_path = active_storage_disk_service.send(:path_for, self.image.blob.key)
        img = Magick::ImageList.new(image_path)
        width = img.columns
        height = img.rows
        # resize the image
        ratio = (height.to_f / width) / 2.to_f
        new_width = IMG_WIDTH
        new_height = new_width * ratio
        img.scale!(new_width, new_height)
        # greyscale the image
        img.quantize(256, Magick::GRAYColorspace)
    end

    def generate_ascii_string
        img = prepare_image
        previous_row = 0
        ascii_string = ""
        img.each_pixel do |pixel, col, row|
        if row != previous_row
            previous_row = row
            ascii_string.concat("\n")
        end
        ascii_string.concat(ASCII_MAP[(255 - (pixel.intensity / 256) ) * 10/256])
        end
        ascii_string
    end
end
