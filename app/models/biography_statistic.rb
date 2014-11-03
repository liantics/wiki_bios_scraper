class BiographyStatistic < ActiveRecord::Base

  validates :name, presence: true
  validates :value, presence: true
  validates :statistic_type, presence: true

  JOINT_GENDERS = [
    ["female", "mostly_female"],
    ["male", "mostly_male"]
  ]

  PERCENTAGES_LIST = [
       ["female", "male", "female_to_male"],

       ["female_mostly_female", "male_mostly_male", "all_females_to_all_males"],

       ["female", "total_records", "female_to_total"],
       ["mostly_female", "total_records", "mostly_female_to_total"],
       ["female_mostly_female", "total_records", "all_females_to_total"],

       ["male", "total_records", "male_to_total"],
       ["mostly_male", "total_records", "mostly_male_to_total"],
       ["male_mostly_male", "total_records", "all_males_to_total"]
     ]

  def generate_statistics
    get_total_records
    generate_raw_counts
    generate_biography_class_specific_counts
    generate_percentages
  end

  private

  def get_total_records
    BiographyStatistic.where(name: "total_records").first_or_create do |statistic|
      statistic.value = Biography.all.length
      statistic.statistic_type = "count"
    end
  end

  def generate_raw_counts
    genders = get_genders
    genders.each do |gender|
      underscored_gender = underscore_string(gender)
      BiographyStatistic.where(name: underscored_gender.to_s).first_or_create do |statistic|
        statistic.value = count_of_gender(gender)
        statistic.statistic_type = "count"
      end

      JOINT_GENDERS.each do |joint_gender|
        generate_joint_bio_counts(joint_gender.first, joint_gender.second, "")
      end
    end
  end

  def generate_biography_class_specific_counts
    biography_class = get_biography_classes
    genders = get_genders
    biography_class.each do |bio_class|
      genders.each do |gender|
        underscored_gender = underscore_string(gender)
        generate_per_gender_counts(underscored_gender, bio_class)
      end

      JOINT_GENDERS.each do |joint_gender|
        generate_joint_bio_counts(joint_gender.first, joint_gender.second, bio_class)
      end
    end
  end

  def generate_percentages
    count_list = generate_count_list
    total_records = BiographyStatistic.find_by(name: "total_records").value

    percentages_to_generate = PERCENTAGES_LIST

    percentages_to_generate.each do |percentage|
      count_1 = percentage.first.to_sym
      count_2 = percentage.second.to_sym
      first_var = count_list[count_1]
      second_var = count_list[count_2]
      generate_percentage(count_list[count_1], count_list[count_2], percentage.third)
    end
  end

  def generate_percentage(count_1, count_2, statistic_name)
    if count_1 < count_2
      percentage = (count_1/count_2)*100
    else
      percentage = (count_2/count_1)*100
    end

    BiographyStatistic.where(name: statistic_name).first_or_create do |statistic|
      statistic.value = percentage
      statistic.statistic_type = "percentage"
    end
  end

  def generate_per_gender_counts(gender, bio_class)
    underscored_gender = underscore_string(gender)
    BiographyStatistic.where(name: underscored_gender.to_s + "_" + bio_class.to_s).first_or_create do |statistic|
      statistic.value = determine_gender_count_by_class(underscored_gender, "", bio_class.to_s)
      statistic.statistic_type = "count"
    end
  end

  def generate_joint_bio_counts(gender_1, gender_2, bio_class)
    gender1 = underscore_string(gender_1)
    gender2 = underscore_string(gender_2)
    statistic_name = generate_joint_count_name(gender1, gender2, bio_class)

    BiographyStatistic.where(name: statistic_name).first_or_create do |statistic|
      statistic.value = determine_gender_count_by_class(gender_1, gender_2, bio_class.to_s)
      statistic.statistic_type = "count"
    end
  end

  def generate_joint_count_name(gender1, gender2, bio_class)
    name = gender1 + "_" + gender2

    if bio_class != ""
      bio_class_portion = bio_class.to_s
      name = name + "_" + bio_class_portion
    end

    name
  end

  def underscore_string(gender)
    if to_s.respond_to?(gender)
      new_gender = gender.to_s.gsub(/ /, "_")
    else
      new_gender = gender.gsub(/ /, "_")
    end
    new_gender
  end

  def generate_count_list
    genders = get_genders
    counts = Hash.new
    genders.each do |gender|
      underscored_gender = underscore_string(gender)
      counts[underscored_gender.to_sym] = BiographyStatistic.find_by(name: underscored_gender).value
    end

    counts["female_mostly_female".to_sym] = counts[:female] + counts[:mostly_female]
    counts["male_mostly_male".to_sym] = counts[:male] + counts[:mostly_male]
    counts["total_records".to_sym] = BiographyStatistic.find_by(name: "total_records").value
    counts
  end

  def get_genders
    genders = Biography.all.pluck(:rough_gender).uniq
    genders.each do |gender|
      underscore_string(gender)
    end
  end

  def get_biography_classes
    Biography.all.pluck(:biography_class).uniq
  end

  def count_of_gender(gender)
    Biography.where(rough_gender: gender).length
  end

  def determine_gender_count_by_class(gender_1, gender_2, biography_class)
    biographies = Biography.arel_table
    if biography_class == ""
      Biography.where(
        biographies[:rough_gender].eq(remove_underscores(gender_1))
        .or(biographies[:rough_gender].eq(remove_underscores(gender_2)))
           ).length
    else
      Biography.where(
        biographies[:biography_class].eq(biography_class)
        .and(biographies[:rough_gender].eq(remove_underscores(gender_1))
        .or(biographies[:rough_gender].eq(remove_underscores(gender_2))))
      ).length
    end
  end

  def remove_underscores(gender)
    gender.gsub(/_/," ")
  end
end
