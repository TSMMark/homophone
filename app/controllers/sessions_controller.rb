class SessionsController < ApplicationController

  def new
    if request.referer && URI(request.referer).path != current_path
      session[:return_to] = request.referer
    end
  end

  def create
    @user = User.find_by_email(params[:email].downcase)

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to session.delete(:return_to), info: "Welcome back!"
    else
      render action: 'new', warning: "Email or password invalid."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to request.referer, info: "You're logged out."
  end

end
