module PagesHelper

  def now
    @now ||= Time.now
  end

  def full_page_title
    tagline = (content_for?(:title) ? content_for(:title) : "Homophones - Complete List of All English Homophones")
    "#{tagline} at Homophone"
  end

  def page_description
    if content_for?(:desc)
      content_for(:desc)
    else
      default_page_description
    end
  end

  def default_page_description
    "A homophone is a word that sounds like another word, but has a different spelling and meaning. " +
    "Here you can explore and learn more about specific examples of homophones in the English language."
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
