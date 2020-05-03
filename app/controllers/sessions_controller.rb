class SessionsController < ApplicationController
    def new
    end


    def create
        email = params[:session][:email].downcase #Session>email
        password = params[:session][:password]
        if login(email,password)
            #flash[:success] = "ログインしました。"
            redirect_to @user
        else
            #flash[:denger] = "メールアドレス又はパスワードが違います。"
            render :new
        end
    end

    def destroy
    
    end
    
    private
    
    def login(email, password)
        @user = User.find_by(email: email)
        if @user && @user.authenticate(password)
          # ログイン成功
          session[:user_id] = @user.id
          return true
        else
          # ログイン失敗
          return false
        end
    end

end
