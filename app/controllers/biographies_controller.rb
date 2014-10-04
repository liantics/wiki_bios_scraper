class BiographiesController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  def index
    name_list = Array.new
    doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/Category:FA-Class_biography_articles"))

    @pages = doc.xpath("//a[contains(@href,'/wiki/Talk:')]/text()")
    @names = generate_names(@pages)
    @all_category_qualities = doc.xpath("//a[contains(@title,'Category:')]")
    next_url = doc.at_xpath("//a[contains(@href,'pagefrom')]/@href")
    @next_pages = "http://en.wikipedia.org/#{next_url}"
  end

  def show

  end

  private

  def generate_names(name_list)
    cleaned_names = Array.new

    name_list.each do |name|
      stripped_name = name.text.gsub("Talk:","")
      cleaned_names << stripped_name
    end

    cleaned_names
  end
end
