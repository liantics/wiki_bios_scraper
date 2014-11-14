include StringManipulator
include GenderCounters
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

  def get_genders
    Biography.all.pluck(:rough_gender).uniq
  end

  def get_biography_classes
    Biography.all.pluck(:biography_class).uniq
  end

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
      generate_a_percentage(count_list[count_1], count_list[count_2], percentage.third)
    end
  end

  def generate_a_percentage(count_1, count_2, statistic_name)
    if count_1 < count_2
      percentage = (count_1/count_2)*100
    else
      percentage = (count_2/count_1)*100
    end

    entry_meta_data = [percentage]
    create_statistic_entry(statistic_name, "percentage", entry_meta_data)
  end

  def create_statistic_entry(statistic_name, entry_type, entry_meta_data)
    BiographyStatistic.where(name: statistic_name).first_or_create do |statistic|

      if entry_type = percentage
        statistic.value = entry_meta_data.first
      else
        statistic.value = determine_gender_count(entry_meta_data.first, entry_meta_data.second, entry_meta_data.third)
      end

      statistic.statistic_type = entry_type
    end
  end
end
