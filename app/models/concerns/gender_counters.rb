module GenderCounters
  extend ActiveSupport::Concern

  def get_genders
    Biography.all.pluck(:rough_gender).uniq
  end

  def get_biography_classes
    Biography.all.pluck(:biography_class).uniq
  end

  def generate_raw_counts
    @gender_list.each do |gender|
      statistic_name = craft_any_statistic_name(gender)

      BiographyStatistic.where(name: statistic_name.to_s).first_or_create do |statistic|
        statistic.value = determine_gender_count(gender)
        statistic.statistic_type = "count"
      end

      generate_joint_gender_counts("")
    end
  end

  def generate_biography_class_specific_counts
    biography_class = get_biography_classes

    biography_class.each do |bio_class|
      @gender_list.each do |gender|
        statistic_name = craft_any_statistic_name(gender).to_s
        entry_meta_data = [gender, "", bio_class.to_s]
        create_statistic_entry(statistic_name, "count", entry_meta_data)
      end

      generate_joint_gender_counts(bio_class)
    end
  end

  def generate_joint_gender_counts(biography_class)
    JOINT_GENDERS.each do |joint_gender|
      statistic_name = craft_any_statistic_name(
        joint_gender.first,
        joint_gender.second,
        biography_class
      ).to_s

      entry_meta_data = [joint_gender.first, joint_gender.second, biography_class.to_s]
      create_statistic_entry(statistic_name, "count", entry_meta_data)
    end
  end

  def determine_gender_count(gender_1, gender_2 = "", biography_class = "")
    biographies = Biography.arel_table
    if biography_class == ""
      Biography.where(
        biographies[:rough_gender].matches_any([gender_1, gender_2])
      ).length
    else
      Biography.where(
        biographies[:biography_class].eq(biography_class)
        .and(biographies[:rough_gender].matches_any([gender_1, gender_2]))
      ).length
    end
  end

  def generate_list_of_values_to_compare
    counts = Hash.new
    @gender_list.each do |gender|
      statistic_name = craft_any_statistic_name(gender)
      counts[statistic_name.to_sym] = BiographyStatistic.find_by(name: statistic_name).value
    end

    counts["female_mostly_female".to_sym] = counts[:female] + counts[:mostly_female]
    counts["male_mostly_male".to_sym] = counts[:male] + counts[:mostly_male]
    counts["total_records".to_sym] = BiographyStatistic.find_by(name: "total_records").value
    counts
  end
end
