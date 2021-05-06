class Upload < ApplicationRecord
    attr_accessor :tags_string

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
end
