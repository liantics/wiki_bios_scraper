class PeopleController < ApplicationController
  def index
    @people = Biography.all
  end

end
