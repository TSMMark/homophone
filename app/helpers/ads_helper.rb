module AdsHelper

  def serve_ad(ad_server=nil)
    # production check
    ad_server ||= Extensions::AdTools.new
    content_tag(:ins, "", ad_server.request_ad_data)
  end

  def should_serve_ad?(counter, frequency, start_at, total_results=999)
    total_results < start_at || (counter + start_at) % frequency == 0
  end
end
