class GendersController < ApplicationController

  def index
    @genders = Biography.all.pluck(:rough_gender).uniq
  end

  def new
    last_bio_gender = Biography.last.rough_gender
    if last_bio_gender == "unknown"
      if GenderFinder.new.try(:genderize_database)
        @complete = "Done generating."
      end
    end
  end
end
