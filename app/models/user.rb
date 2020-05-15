class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum:50 }
    validates :email, presence: true,length: { maximum:255 },
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    has_many :posts
    
    has_many :favorites,dependent: :destroy
    has_many :favorite_now, through: :favorites, source: :post
    
    def fav_in(other_post)
        self.favorites.find_or_create_by(post_id: other_post.id)
    end 
    
    def fav_out(other_post)
        favorite = self.favorites.find_by(post_id: other_post.id)
        favorite.destroy   if favorite
    end 
    
    def fav_now(other_post)
        self.favorite_now.include?(other_post)
    end 
end
