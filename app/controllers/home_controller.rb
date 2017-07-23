class HomeController < ApplicationController
  def index
  end
  
  def latest
    s = params.fetch(:t, 5*60)

    @data = TphData.where('timestamp > ?', s.seconds.ago)

    render :data
  end

  def range
    from = params.require(:from).to_datetime
    to = params.require(:to).to_datetime

    @data = TphData.where('timestamp >= ? and timestamp <= ?', from, to)

    render :data
  end
end
