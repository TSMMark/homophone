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

  def card_ad_tools
    @card_ad_tools ||=  AdTools.new(
                          max_ads: 3,
                          default_format: "auto",
                          format_sequence: %w(horizontal auto horizontal)
                        )
  end
  helper_method :card_ad_tools
  
  def should_serve_ad?(counter, frequency, start_at, total_results=999)
    puts "card_ad_tools.card_ad_count #{card_ad_tools.card_ad_count}"
    puts "card_ad_tools.max_ads #{card_ad_tools.max_ads}"
    (card_ad_tools.card_ad_count < card_ad_tools.max_ads) &&
      (total_results < start_at ||
      (counter + start_at) % frequency == 0)
  end
  helper_method :should_serve_ad?
  
end
