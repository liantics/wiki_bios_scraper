class GenderFinder
  include StringManipulator
  require "sexmachine"

  def genderize_database
    names = Biography.where(rough_gender: "unknown").pluck(:id, :name)
    gender_detector = SexMachine::Detector.new

    find_gender_by_first_name(names, gender_detector)
  end

  def find_gender_by_first_name(names, gender_detector)
    names.each do |this_name|
      name_only = this_name.last
      split_name = name_only.split(" ")

      if split_name.first.downcase != "the"
        first_name = split_name.first
      else
        first_name = split_name.second
      end

      determine_rough_gender(this_name.first, first_name, gender_detector)
    end
  end

  def determine_rough_gender(id, name, gender_detector)
    entry = Biography.find(id)
    entry.rough_gender = gender_detector.get_gender(name)
    entry.rough_gender = add_or_remove_underscores("remove", entry.rough_gender.to_s)
    if entry.rough_gender == "andy"
      relabel_androgenous_genders(entry)
    end
    entry.save
  end

  def relabel_androgenous_genders(entry)
      entry.rough_gender = "androgynous or unknown"
  end
end
