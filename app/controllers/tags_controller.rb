class TagsController < ApplicationController
def edit
    @tag = Tag.new(tag_params)
    @check01 = Tag.where(name: @post.tag[:name])#配列
        if @check01.length == 1#重複していない？
           @new_tag = Tag.find_by(name: @post.tag[:name])
        else
          @d_tag = Tag.order(updated_at: :desc).limit(1).last
          @d_tag.destroy
          @new_tag = Tag.find_by(name: @post.tag[:name])
        end
          @new_post = Post.find_by(title: @post[:title])
          @new_post.post_tags.find_or_create_by(tag_id: @new_tag.id)
    redirect_to post_path
end

def find
@tag = Tag.find(tag_d_params)
@posts = @tag.posts
end

def destroy
  @tag = Tag.find(params[:id])
  @tag.destroy
  redirect_to root_path
end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end 
    
    def tag_d_params
      params.repuire(:format)
    end
end
