class BiographiesController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  START_PAGES = [
    "http://en.wikipedia.org/wiki/Category:FA-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:A-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:GA-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:B-Class_biography_articles",
    "http://en.wikipedia.org/wiki/Category:C-Class_biography_articles"
  ]

  def index
    @pages_in_this_quality_class = [START_PAGES.second]
    @biography_pages = []

    PageWalker.new.generate_biography_page_list(
      START_PAGES.second,
      @biography_pages,
      @pages_in_this_quality_class
    )

    @names = generate_names(@biography_pages.flatten)
    @urls = generate_urls(@names)
  end

  def show
    def show
      @person = Biography.find(params[:id])
    end
  end

  private

  def generate_names(name_list)
    name_list.map { |name| name.gsub("Talk:", "") }
  end

  def generate_urls(name_list)
    name_list.map { |name| "http://en.wikipedia.org/wiki/#{name}"}
  end

  def fill_database
    i = 0
    @names.each do
      this_name = @names[i]
      this_url = @urls[i]
      Biography.new.generate_entries(this_name, this_url)
      i+=1
    end
  end
end
