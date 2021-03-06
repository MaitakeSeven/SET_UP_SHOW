class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  PER = 9
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.page(params[:page]).per(PER)
    @tag = Tag.new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @tag = Tag.new
  end

  # GET /posts/new
  def new
    if logged_in?
      @post = Post.new
      @name1　= ""
      @name2  = ""
      @name3  = ""
    else
      redirect_to login_path
    end
  end

  # GET /posts/1/edit
  def edit
    if @post.user.id == current_user.id
    else
      redirect_to root_path
    end
  end


  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @namearray = [tag1_params,tag2_params,tag3_params]
    @newarray = []
      @namearray.each do |name|
        unless name == nil
            @tag = Tag.new(name: name)
            @newarray.push(@tag)
        end
      end

    
    ActiveRecord::Base.transaction do
      @post.save!
                @newarray.each do |tag|
                    @check = Tag.find_by(name: tag.name)
                    @new_post = Post.find_by(title: @post.title)
                      unless @check
                            if tag.save!
                              @new_tag = Tag.find_by(name: tag.name)
                              @new_post.post_tags.find_or_create_by(tag_id: @new_tag.id)
                            end
                      else
                        @new_post.post_tags.find_or_create_by(tag_id: @check.id)
                      end
                end
    if @newarray.length ==0
      a = Tag.new(name: nil)
      a.save!
    end 
      flash[:success] = '投稿に成功しました。'
    end
      redirect_to @post
    rescue => e
      flash.now[:danger] = '投稿に失敗しました。'
      puts e.message
      @name1 =  tag1_params
      @name2  = tag2_params
      @name3  = tag3_params
      if @name1 == nil && @name2 == nil && @name3 == nil
        @em = "タグを1つ以上入力してください。"
      end 
      render :new
      #redirect_to new_post_path
  end


  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.user.id == current_user.id
      respond_to do |format|
        if @post.update(post_params)
          flash[:success] = '投稿を更新しました。'
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        else
          flash[:danger] = '投稿に失敗しました。'
          format.html { render :edit }
        end
      end
    else
      redirect_to root_path
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if @post.user.id == current_user.id
    @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url }
        #format.json { head :no_content }
        flash[:success] = '投稿を削除しました。'
      end
    else
      redirect_to root_path
    end
  end
  
  def tags
    @post = Post.find(params[:id])
    @tag = Tag.new(tag_params)
    @check01 = Tag.where(name: @tag[:name])#配列
        if count_tags(@post) > 4
          flash[:danger] = 'タグの追加に失敗しました。'
          render :show
          return
        end
    unless @tag.name == nil || @tag.name == ""
      if @check01.length == 1
        @post.post_tags.find_or_create_by(tag_id: @check01.first.id)
        flash[:success] = 'タグの追加に成功しました。'
        redirect_to post_path
      else
          if@tag.save
            @new_tag = Tag.find_by(name: @tag.name)
            @post.post_tags.find_or_create_by(tag_id: @new_tag.id)
            flash[:success] = 'タグの追加に成功しました。'
            redirect_to post_path
          else
            flash[:danger] = 'タグの追加に失敗しました。'
            render :show
            return
          end
      end
    else
      flash[:danger] = 'タグの追加に失敗しました。'
      render :show
      return
    end
  end

  def tag_d
      @post = Post.find(params[:id])
      if @post.tags.count > 1
      @p_t = PostTag.find_by(post_id: params[:id],tag_id: params[:tag_id])
      @p_t.destroy
      flash[:success] = 'タグの削除に成功しました。'
      else

      end
      redirect_to post_path(params[:id])
      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post)
            .permit(
              :user_id,
              :image,
              :title,
              :comment,)
    end
    
    def tag1_params
        unless params[:name1] == ""
          params.require(:name1)
        end
    end
    
    def tag2_params
        unless params[:name2] == ""
          params.require(:name2)
        end
    end
    
    def tag3_params
        unless params[:name3] == ""
          params.require(:name3)
        end
    end
    
    def tag_params
        params.require(:tag).permit(:name)
    end 
    
    def dtag_params
      params.require(:tag_id)
    end 
end
