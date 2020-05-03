class Post < ApplicationRecord
    mount_uploader :image, ImageUploader
    has_many :user
    has_many :post_tag
    has_many :tag ,through: :post_tag, source: :tag_id
    belongs_to :tag,foreign_key: "id"
    accepts_nested_attributes_for :tag
    

end
