class PageWalker
  def generate_biography_page_list(start_page, biography_pages, page_array)
    @biography_pages = biography_pages
    @page_array = page_array
    traverse_pages(start_page)
  end

  private

  def traverse_pages(start_page)
    traversal_doc = Nokogiri::HTML(open(start_page))
    biography_page_list = generate_biography_pages(traversal_doc)
    generate_biographies_list(traversal_doc, biography_page_list)
    next_url = generate_next_url(traversal_doc)

    if next_url
      if next_url.include? "pagefrom"
        traversal_next_page = "http://en.wikipedia.org/#{next_url}"
        @page_array << traversal_next_page
        traverse_pages(traversal_next_page)
      end
    end
  end

  def generate_biography_pages(traversal_doc)
    traversal_doc.xpath("//a[contains(@href,'/wiki/Talk:')]/text()")
  end

  def generate_next_url(traversal_doc)
    url = traversal_doc.xpath("//div[@id='mw-pages']/a[contains(@href,'pagefrom')]/@href")
    if ! url.empty?
      url.first.value
    end
  end

  def generate_biographies_list(traversal_doc, biography_page_list)
    biography_page_list.each do |page|
      @biography_pages << page.text
    end
  end
end
