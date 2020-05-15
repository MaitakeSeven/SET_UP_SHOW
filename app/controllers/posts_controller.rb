class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
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
    else
      redirect_to login_path
    end
  end

  # GET /posts/1/edit
  def edit
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
    #@tag1 = Tag.new(name: tag1_params)
      
    #@tag2 = Tag.new(name: tag2_params)
      
    #@tag3 = Tag.new(name: tag3_params)

    respond_to do |format|
      if  @post.save
            format.html { redirect_to @post, notice: 'Post was successfully created.' }
            format.json { render :show, status: :created, location: @post } 
            
        @newarray.each do |tag|
          @check = Tag.find_by(name: tag.name)
          @new_post = Post.find_by(title: @post.title)
          unless @check
              if tag.save
                @new_tag = Tag.find_by(name: tag.name)
                  @new_post.post_tags.find_or_create_by(tag_id: @new_tag.id)
              else
                redirect_to :new
              end
          else
            @new_post.post_tags.find_or_create_by(tag_id: @check.id)
          end
        end
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
  end
  
  def tags
    @post = Post.find(params[:id])
    @tag = Tag.new(tag_params)
    @check01 = Tag.where(name: @tag[:name])#配列

    if @check01.length == 1
      @post.post_tags.find_or_create_by(tag_id: @check01.first.id)
    else
      if@tag.save
        @new_tag = Tag.find_by(name: @tag.name)
        @post.post_tags.find_or_create_by(tag_id: @new_tag.id)
      end
    end
    redirect_to post_path
  end

  def tag_d
      @p_t = PostTag.find_by(post_id: params[:id],tag_id: params[:tag_id])
      @p_t.destroy
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
