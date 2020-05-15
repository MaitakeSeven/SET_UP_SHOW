class Tag < ApplicationRecord
    #has_many :post
    has_many :post_tags,dependent: :destroy
    has_many :posts, through: :post_tags, source: :post
    
end
