class Tag < ApplicationRecord
    has_and_belongs_to_many :uploads

    validates   :title, :presence => true,
                :length => { maximum: 30 }
end
