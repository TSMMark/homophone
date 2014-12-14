module PagesHelper

  def now
    @now ||= Time.now
  end

  def full_page_title
    tagline = (content_for?(:title) ? content_for(:title) : "Your Complete List of Homophones")
    "#{tagline} at Homophone.com"
  end

  def page_h
    "h3"
  end

  def btn_view_more(options = {})
    defaults = {
      :class => "btn btn-primary"
    }
    link_to("More homophones", browse_path, defaults.merge(options))
  end

end
