class BiographiesController < ApplicationController
  include StringManipulator
  include BiographyStatisticVariables

  require 'nokogiri'
  require 'open-uri'

  def index
    @number_of_biography_links_to_show = LINKS_TO_SHOW
    female_biographies = Biography.where(rough_gender: "female")
    @female_biography_links = female_biographies.order("RANDOM()").limit(LINKS_TO_SHOW)
  end

  def new
    start_pages = WikiBiographyClass.pluck(:class_url)
    start_pages.each do |start_page|
      @pages_in_this_quality_class = [start_page]
      @biography_pages = []

      PageWalker.new.generate_biography_page_list(
        start_page,
        @biography_pages,
        @pages_in_this_quality_class
      )

      @names = generate_names(@biography_pages.flatten, start_page)
      @urls = generate_urls(@names)

      biography_class = determine_class(start_page)
      fill_database(biography_class)
    end
  end

  def show
      @person = Biography.find(params[:id])
  end

  private

  def determine_class(page)
    strip_from_beginning_of_url = "http://en.wikipedia.org/wiki/Category:"
    strip_from_end_of_url = "-Class_biography_articles"

    substring = strip_string(page, strip_from_beginning_of_url).to_s
    strip_string(substring, strip_from_end_of_url).to_s
  end

  def generate_names(name_list, start_page)
    if determine_class(start_page) == "Book"
      name_list.map { |name| strip_string(name, "Book_talk:") }
    else
      name_list.map { |name| strip_string(name, "Talk:") }
    end
  end

  def generate_urls(name_list)
    puts "generating_urls"
    puts name_list
    name_list.map { |name| "http://en.wikipedia.org/wiki/#{name}"}
  end

  def fill_database(biography_class)
    puts "#{@names}"
    i = 0
    @names.each do |name|
      this_name = @names[i]
      this_url = @urls[i]
      this_biography_class = biography_class
      Biography.new.generate_entries(this_name, this_url, this_biography_class)
      i+=1
    end
  end
end
