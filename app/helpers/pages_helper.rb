module PagesHelper
  def full_page_title
    "Homophone.com " +
      (content_for?(:title) ? "| #{content_for(:title)}" : "- Your Complete List of Homophones")
  end

  def page_h
    "h3"
  end

  def btn_view_more options={}
    defaults = {
      class: "btn btn-primary"
    }
    link_to "Click for more homophones !", browse_path, defaults.merge(options)
  end
end
