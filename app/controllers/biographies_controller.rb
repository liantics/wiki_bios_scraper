class BiographiesController < ApplicationController
  include StringManipulator

  require 'nokogiri'
  require 'open-uri'
  #Generating new biography entries is intentionally a painful, manual process, to prevent accidental overload of wikipedia. For each page you want to scrape, add it to the WikiBiographyClass table via the console. You'll need to specify the following:
  #
  #class_type is the portion of the URL between the : and the -Class, in quotes.
  #class_url is the url, in quotes.
  #traversal_status = false.
  #
  #It's best to add one at a time, then wait a few minutes after the scrape is complete before running another one.
  #You probably don't want wikipedia to block your IP address.

  PAGES_SCRAPED = [
    "http://en.wikipedia.org/wiki/Category:FA-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:A-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:GA-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:B-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:C-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:Disambig-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:Book-Class_biography_articles"
  ]

  PAGES_NOT_SCRAPED_YET = [
    "http://en.wikipedia.org/wiki/Category:stub-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:start-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:Template-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:NA-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:Unassessed_biography_articles",
    "http://en.wikipedia.org/wiki/Category:List-Class_biography_articles"
  ]

  LINKS_TO_SHOW = 2000

  def index
    @number_of_biography_links_to_show = LINKS_TO_SHOW
    female_biographies = Biography.where(rough_gender: "female")
    @female_biography_links = female_biographies.order("RANDOM()").limit(LINKS_TO_SHOW)
  end

  def new
    start_pages = WikiBiographyClass.all.pluck(:class_url)
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
    string_1 = "http://en.wikipedia.org/wiki/Category:"
    string_2 = "-Class_biography_articles"

    substring = strip_string.call(page, string_1).to_s
    biography_class = strip_string.call(substring.to_s, string_2).to_s
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
