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
    @next_page = "http://en.wikipedia.org#{next_url}"

    @num_pages = 5
    @iterations = 1
    @page_array = Array.new()
    @page_array << @next_page
    traverse_pages(@next_page, @num_pages, @iterations)
    11.times do
      @page_array.pop
    end

    #@num_pages_text = doc.at_xpath("//a[contains(@href,'pagefrom')]/text()")
    #@old_num_pages = generate_num_pages(@num_pages_text)
  end

  def show
  end

  def traverse_pages(start_page, num_pages, iterations)

    while iterations < num_pages
      traversal_doc = Nokogiri::HTML(open(start_page))

      next_url = traversal_doc.at_xpath("//a[contains(@href,'pagefrom')]/@href")
      traversal_next_page = "http://en.wikipedia.org/#{next_url}"

      @page_array << traversal_next_page

      iterations += 1
      traverse_pages(traversal_next_page, num_pages, iterations)
    end
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

  def generate_num_pages(page_count)
    page_count.text.gsub("next ","").to_i
  end
end
