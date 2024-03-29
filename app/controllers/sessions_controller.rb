class SessionsController < ApplicationController
    def new
    end


    def create
        email = params[:session][:email].downcase #Session>email
        password = params[:session][:password]
        if login(email,password)
            flash[:success] = "ログインしました。"
            redirect_to @user
        else
            flash[:danger] = "メールアドレス又はパスワードが違います。"
            redirect_to login_path
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:success] = 'ログアウトしました。'
        redirect_to root_path
    
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
