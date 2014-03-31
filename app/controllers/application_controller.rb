class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :add_home_breadcrumb

  helper_method :breadcrumbs


  protected
  

  def add_home_breadcrumb
    add_breadcrumb "Home", :root_path
  end

  def current_path
    request.env['PATH_INFO'].to_s
  end
  helper_method :current_path

end
