module StatisticsEntry
  extend ActiveSupport::Concern

  def create_statistic_entry(statistic_name, entry_type, entry_meta_data)
    BiographyStatistic.where(name: statistic_name).first_or_create do |statistic|
      if entry_type == "percentage"
        statistic.value = entry_meta_data.first
      else
        statistic.value = determine_gender_count(
          entry_meta_data.first,
          entry_meta_data.second,
          entry_meta_data.third
        )
      end

      statistic.statistic_type = entry_type
    end
  end
end
