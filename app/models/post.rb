class Post < ApplicationRecord
  
      validates :image, presence: true
      validates :title, presence: true, length: { maximum:10 }
      validates :comment, presence: true, length: { maximum:50 }
      
      mount_uploader :image, ImageUploader
      
      belongs_to :user
      
      has_many :post_tags,dependent: :destroy
      has_many :tags, through: :post_tags, source: :tag
      
      has_many :favorites,dependent: :destroy

end
