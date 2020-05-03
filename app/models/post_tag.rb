class PostTag < ApplicationRecord
  belongs_to :post,foreign_key: "post_id"
  belongs_to :tag,foreign_key: "tag_id"
end
