class SessionsController < ApplicationController
  
  def new
    session[:return_to] = request.referer unless URI(request.referer).path == current_path
  end

  def create
    @user = User.find_by_email(params[:email])

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
