module StringManipulator

  def strip_string(original_string, string_to_strip)
    original_string.gsub(string_to_strip, "")
  end

  def add_or_remove_underscores(operation, the_string)
    if operation == "add"
      replace_character = " "
      with_character = "_"
    elsif operation == "remove"
      replace_character = "_"
      with_character = " "
    else
      replace_character = " "
      with_character = " "
    end

    if to_s.respond_to?(the_string)
      new_string = the_string.to_s.gsub(replace_character, with_character)
    else
      new_string = the_string.gsub(replace_character, with_character)
    end

    new_string
  end

  def craft_any_statistic_name(gender_1, gender_2 = "", bio_class = "")
    name = add_or_remove_underscores("add", gender_1)

    if gender_2 != ""
      gender_2_portion = add_or_remove_underscores("add", gender_2.to_s)
      name = name + "_" + gender_2_portion
    end

    if bio_class != ""
      bio_class_portion = bio_class.to_s
      name = name + "_" + bio_class_portion
    end

    name
  end
end
