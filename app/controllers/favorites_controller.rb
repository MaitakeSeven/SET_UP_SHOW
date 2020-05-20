class FavoritesController < ApplicationController
    before_action :require_user_logged_in
    
    def create
    post = Post.find(params[:post_id])
    current_user.fav_in(post)
    flash[:success] = 'お気に入り登録しました。'
    redirect_to root_path
    end
    
    
    def destroy
    post = Post.find(params[:post_id])
    current_user.fav_out(post)
    flash[:danger] = 'お気に入りを解除しました。'
    redirect_to root_path
    end 
    
    def create_show
    post = Post.find(params[:post_id])
    current_user.fav_in(post)
    flash[:success] = 'お気に入り登録しました。'
    redirect_to post
    end
    
    
    def destroy_show
    post = Post.find(params[:post_id])
    current_user.fav_out(post)
    flash[:danger] = 'お気に入りを解除しました。'
    redirect_to post
    end 
end
