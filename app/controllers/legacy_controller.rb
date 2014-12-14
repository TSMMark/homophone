class LegacyController < ApplicationController

  def results
    type = params[:how]
    q = params[:searchfor]
    redirect_to "/search?type=#{type}&q=#{q}", :status => :moved_permanently
  end

  def default
    redirect_to "/", :status => :moved_permanently
  end

end
