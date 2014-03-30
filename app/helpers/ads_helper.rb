module AdsHelper

  def serve_ad(ad_server=nil)
    # production check
    if Rails.env.production? || ENV['ADS']
      ad_server ||= AdTools.new
      content_tag(:ins, "", ad_server.request_ad_data)
    else
      content_tag(:div, "[ad placeholder]", style: "background-color:white; min-height: 60px;")
    end
  end

  def should_serve_ad?(counter, frequency, start_at, total_results=999)
    total_results < start_at || (counter + start_at) % frequency == 0
  end
end
