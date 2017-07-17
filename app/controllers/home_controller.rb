class HomeController < ApplicationController
  def index
    @data = TphData.all
  end
  
  def latest
    s = params.fetch(:t, 5*60)
    @data = TphData.where('timestamp > ?', s.seconds.ago)
    render :data
  end
end
