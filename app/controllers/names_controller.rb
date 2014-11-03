class NamesController < ApplicationController
  def index
    @people = Biography.all
    @initial_women = find_potential_women
    @verified_women = generate_verified_list(@initial_women)
  end

  private

  def find_potential_women
    female = Biography.where(rough_gender: "female")
    mostly_female = Biography.where(rough_gender: "mostly_female")
    potential_women = female + mostly_female
    return potential_women
  end

  def generate_verified_list(collection)
    verified_gender = collection.map{|item| item.verified_gender == "verified"}
  end

  def filter_mostly_females
  end
end
