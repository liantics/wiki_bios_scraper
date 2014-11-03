class BiographyStatisticsController < ApplicationController
  def index
    @percentage_statistics = BiographyStatistic.where(statistic_type: "percentage")
    @count_statistics = BiographyStatistic.where(statistic_type: "count")
  end

  def new
    @started = "starting"
    BiographyStatistic.new.generate_statistics
    @done = "done"
  end
end
