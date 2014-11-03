class BiographiesController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  #This is intentionally a painful, manual process, to prevent accidental overload of wikipedia. For each page you want to scrape, enter its URL in the startpage quotes, then go to the scrape website and load site_url/biographies
  START_PAGE = "http://en.wikipedia.org/wiki/Category:Disambig-Class_biography_articles"

  PAGES_SCRAPED = [
    "http://en.wikipedia.org/wiki/Category:FA-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:A-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:GA-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:B-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:C-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:Disambig-Class_biography_articles"
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
    @pages_in_this_quality_class = [START_PAGE]
    @biography_pages = []

    PageWalker.new.generate_biography_page_list(
      START_PAGE,
      @biography_pages,
      @pages_in_this_quality_class
    )

    @names = generate_names(@biography_pages.flatten)
    @urls = generate_urls(@names)

    biography_class = determine_class(START_PAGE)
    fill_database(biography_class)
  end

  def show
      @person = Biography.find(params[:id])
  end

  private

  def determine_class(page)
    initial_substring = page.gsub("http://en.wikipedia.org/wiki/Category:", "")
    biography_class = initial_substring.gsub("-Class_biography_articles", "")
    biography_class.to_s
  end

  def generate_names(name_list)
    if determine_class(START_PAGE) == "Book"
      name_list.map { |name| name.gsub("Book talk:", "") }
    else
      name_list.map { |name| name.gsub("Talk:", "") }
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
