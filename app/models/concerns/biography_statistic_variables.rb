module BiographyStatisticVariables
  extend ActiveSupport::Concern

    JOINT_GENDERS = [
      ["female", "mostly female"],
      ["male", "mostly male"]
    ]

    PERCENTAGES_LIST = [
        ["female", "male", "female_to_male"],

        ["female_mostly_female", "male_mostly_male", "all_females_to_all_males"],

        ["female", "total_records", "female_to_total"],
        ["mostly_female", "total_records", "mostly_female_to_total"],
        ["female_mostly_female", "total_records", "all_females_to_total"],

        ["male", "total_records", "male_to_total"],
        ["mostly_male", "total_records", "mostly_male_to_total"],
        ["male_mostly_male", "total_records", "all_males_to_total"],

        ["androgynous_or_unknown", "total_records", "androgynous_or_unknown_to_total"]
      ]

end
