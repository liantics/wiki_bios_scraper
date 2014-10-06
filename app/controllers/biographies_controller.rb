class BiographiesController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  def index
    start_page = "http://en.wikipedia.org/wiki/Category:FA-Class_biography_articles"

    @page_array = Array.new
    @page_array << start_page
    @bio_pages = Array.new

    traverse_pages(start_page)

    @names = generate_names(@bio_pages)
  end

  def show
  end

  def traverse_pages(start_page)
    traversal_doc = Nokogiri::HTML(open(start_page))
    bio_page_list = generate_bio_pages(traversal_doc)
    generate_page_list(traversal_doc, bio_page_list)
    next_url = generate_next_url(traversal_doc)

    if next_url
      if next_url.include? "pagefrom"
        traversal_next_page = "http://en.wikipedia.org/#{next_url}"
        @page_array << traversal_next_page
        traverse_pages(traversal_next_page)
      end
    end
  end

  def generate_bio_pages(traversal_doc)
    traversal_doc.xpath("//a[contains(@href,'/wiki/Talk:')]/text()")
  end

  def generate_next_url(traversal_doc)
    url = traversal_doc.xpath("//div[@id='mw-pages']/a[contains(@href,'pagefrom')]/@href")
    if ! url.empty?
      url.first.value
    end
  end

  def generate_page_list(traversal_doc, bio_pages)
    traversal_doc.xpath("//a[contains(@href,'/wiki/Talk:')]/text()")

    bio_pages.each do |page|
      @bio_pages << page.text
    end
  end

  def start_page_list
    start_page = Array.new
    start_pages = ["http://en.wikipedia.org/w/index.php?title=Category:FA-Class_biography_articles", "http://en.wikipedia.org/wiki/Category:A-Class_biography_articles", "http://en.wikipedia.org/wiki/Category:GA-Class_biography_articles", "http://en.wikipedia.org/wiki/Category:B-Class_biography_articles", "http://en.wikipedia.org/wiki/Category:C-Class_biography_articles"]
    return start_pages
  end

  private

  def generate_names(name_list)
    cleaned_names = Array.new

    name_list.each do |name|
      stripped_name = name.gsub("Talk:","")
      cleaned_names << stripped_name
    end

    cleaned_names
  end
end
