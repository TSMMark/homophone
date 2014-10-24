class PagesController < ApplicationController

  before_filter :no_back_button, only: :home

  def home; end

  def about; end

  def browse; end

end
