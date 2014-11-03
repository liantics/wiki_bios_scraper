class PageWalker
  def generate_biography_page_list(start_page, biography_pages, page_array)
    @biography_pages = biography_pages
    @page_array = page_array

    if start_page_already_traversed?(start_page) == []
      traverse_pages(start_page)
      set_traversal_status(start_page)
    end
  end

  private

  def start_page_already_traversed?(start_page)
    WikiBiographyClass.where( class_url: start_page).pluck(:traversal_status)
  end

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

  def set_traversal_status(start_page)
    traversed_page = WikiBiographyClass.new
    traversed_page.class_url = start_page
    traversed_page.traversal_status = true
    traversed_page.class_type = determine_class(start_page)
    traversed_page.save
  end

  def determine_class(page)
    initial_substring = page.gsub("http://en.wikipedia.org/wiki/Category:", "")
    biography_class = initial_substring.gsub("-Class_biography_articles", "")
    biography_class.to_s
  end

  def generate_biography_pages(traversal_doc)
    traversal_doc.xpath("//a[contains(@href,'/wiki/Talk:')]/text()")

    #Books use a different href format this should be automated in the future.
    #traversal_doc.xpath("//a[contains(@href,'/wiki/Book_talk:')]/text()")
  end

  def generate_next_url(traversal_doc)
    url = traversal_doc.xpath("//div[@id='mw-pages']/a[contains(@href,'pagefrom')]/@href")
    if ! url.empty?
      url.first.value
    end
  end

  def generate_biographies_list(traversal_doc, biography_page_list)
    @biography_pages << biography_page_list.map { |page| page.text }
  end
end
