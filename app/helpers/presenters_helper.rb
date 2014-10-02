module PresentersHelper

  MAX_ITEMS = 5

  def render_pagination(presenter)
    total_pages = presenter.total_pages
    current_page = presenter.page

    surrounding = (MAX_ITEMS - 2) / 2

    prev_page = presenter.prev_page
    next_page = presenter.next_page

    before_items = ((current_page - surrounding)..(prev_page || 1))
    after_items = ((next_page || total_pages)..(current_page + surrounding))

    pagination_items = [
      1,
      current_page,
      total_pages,
      before_items.to_a,
      after_items.to_a
    ].flatten.uniq.select{ |i| i > 0 && i <= total_pages }.sort

    render("pagination/links", {
      :presenter => presenter,
      :total_pages => total_pages,
      :current_page => current_page,
      :pagination_items => pagination_items,
      :prev_page => prev_page,
      :next_page => next_page
    })
  end

end
