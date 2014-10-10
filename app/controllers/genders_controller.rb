class GendersController < ApplicationController

  def index
    @last_bio_gender = Biography.last.rough_gender

    GenderFinder.new.genderize_database

    @refreshed_bio = refresh_last_bio
  end

  private

  def refresh_last_bio
    Biography.last.rough_gender

  end
end
