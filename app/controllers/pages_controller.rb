class PagesController < ApplicationController

  skip_before_filter :add_home_breadcrumb, only: [:home]

  def home

  end

end
