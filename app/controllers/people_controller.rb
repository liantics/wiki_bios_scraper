class PeopleController < ApplicationController
  def index
    @people = Biography.all

    @number_of_biographies = @people.length
    @number_of_females = Biography.where(rough_gender: "female").length
    @number_of_males = Biography.where(rough_gender: "male").length
    @number_of_unknown = Biography.where(rough_gender: "androgynous or unknown").length

    @percentage_female = (@number_of_females.to_f/@number_of_males.to_f)*100
  end

end
