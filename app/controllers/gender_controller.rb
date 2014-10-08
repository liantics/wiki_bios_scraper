class GenderController :: ActionController

  def assign_rough_genders
    GenderFinder.new.genderize_database
  end
end
