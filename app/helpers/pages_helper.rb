module PagesHelper

  def now
    @now ||= Time.now
  end

  def full_page_title
    tagline = (content_for?(:title) ? content_for(:title) : "Homophone Dictionary")
    "#{tagline} at Homophone.com"
  end

  def page_description
    if content_for?(:desc)
      content_for(:desc)
    else
      default_page_description
    end
  end

  def default_page_description
    "Homophone Dictionary – your complete list of homophones with definitions"
  end

  def page_h
    "h3"
  end

  def btn_view_more(options = {})
    defaults = {
      :class => "btn btn-primary"
    }
    link_to(raw("More homophones #{plain_icon("book")}"), browse_path, defaults.merge(options))
  end

end
