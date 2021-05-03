class Upload < ApplicationRecord
    has_one_attached :image

    validates   :title, :presence => true,
                :length => { maximum: 30 }
    validates_presence_of    :ascii

    validate :image_size_and_type

    def image_size_and_type
        if image.attached? == false
            errors.add(:image, "is missing!")
        elsif !image.content_type.in?(%('image/jpeg image/png'))
            errors.add(:image, "must be jpeg or png.")
        elsif image.byte_size < 1.kilobyte || image.byte_size > 5.megabytes
            errors.add(:image, "must be between 1kb and 5mb in size.")
        end
    end
end
