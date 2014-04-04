class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  
  def no_back_button
    @display_back_button = false
  end

  def current_path
    request.env['PATH_INFO'].to_s
  end
  helper_method :current_path

  def display_back_button?
    @display_back_button = true if @display_back_button.nil?
  end
  helper_method :display_back_button?

end
