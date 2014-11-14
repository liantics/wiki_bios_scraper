include StringManipulator
include GenderCounters
include GenderPercentages
include StatisticsEntry
include BiographyStatisticVariables

class BiographyStatistic < ActiveRecord::Base

  validates :name, presence: true
  validates :value, presence: true
  validates :statistic_type, presence: true

  def generate_statistics
    @gender_list = get_genders
    get_total_records
    generate_counts
    generate_percentages
  end

  private

  def get_total_records
    BiographyStatistic.where(name: "total_records").first_or_create do |statistic|
      statistic.value = Biography.all.length
      statistic.statistic_type = "count"
    end
  end

  def generate_counts
    generate_raw_counts
    generate_biography_class_specific_counts
  end

  def generate_percentages
    count_list = generate_list_of_values_to_compare
    total_records = BiographyStatistic.find_by(name: "total_records").value

    PERCENTAGES_LIST.each do |percentage|
      count_1 = percentage.first.to_sym
      count_2 = percentage.second.to_sym

      generate_this_percentage(
        count_list[count_1],
        count_list[count_2],
        percentage.third
      )
    end
  end
end
