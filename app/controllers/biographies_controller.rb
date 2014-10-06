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

    PageWalker.new.generate_biography_page_list(START_PAGES.second, @biography_pages, @pages_in_this_quality_class)

    @names = generate_names(@biography_pages)
  end

  def show
  end

  private

  def generate_names(name_list)
    cleaned_names = []

    name_list.each do |name|
      stripped_name = name.gsub("Talk:","")
      cleaned_names << stripped_name
    end

    cleaned_names
  end
end
