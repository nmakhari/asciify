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
        elsif image.byte_size > 10.megabytes
            errors.add(:image, "must be at most 10mb in size.")
        end
    end
end
