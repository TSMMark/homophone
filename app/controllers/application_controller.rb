class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  add_flash_types :warning, :danger, :success, :info


  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  helper_method :current_user

  def signed_in?
    @is_signed_in ||= session[:user_id] && session[:user_id] > 0
  end
  helper_method :signed_in?


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

  def card_ad_tools
    @card_ad_tools ||=  AdTools.new(
                          max_ads: 3,
                          default_format: "auto",
                          format_sequence: %w(horizontal auto horizontal)
                        )
  end
  helper_method :card_ad_tools
  
  def should_serve_ad?(counter, frequency, start_at, total_results=999)
    (card_ad_tools.card_ad_count < card_ad_tools.max_ads) &&
      (total_results < start_at ||
      (counter + start_at) % frequency == 0)
  end
  helper_method :should_serve_ad?

end
