module GenderPercentages
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> e9853d2... Respond to Pull Request Comments
=======
>>>>>>> 3efa2cf... Respond to pull request comments
  def generate_this_percentage(count_1, count_2, statistic_name)
    if count_1 < count_2
      percentage = (count_1 / count_2) * 100
    else
      percentage = (count_2 / count_1) * 100
    end

    entry_meta_data = [percentage]
    create_statistic_entry(statistic_name, "percentage", entry_meta_data)
  end
end
