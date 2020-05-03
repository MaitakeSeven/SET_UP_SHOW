class Tag < ApplicationRecord
    has_many :post
    has_many :post_tag
    validates :name, uniqueness: true 
end
