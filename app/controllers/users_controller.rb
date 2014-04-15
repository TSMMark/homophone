class UsersController < ApplicationController

  load_and_authorize_resource only: [:edit, :update]

  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, success: 'User was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @user }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  private


  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
