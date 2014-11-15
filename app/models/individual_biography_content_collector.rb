class IndividualBiographyContentCollector
  def gather_page_text(biography_name)
    page_to_grab = generate_page_text_url(biography_name)
    biography_text_page = Nokogiri::HTML(open(page_to_grab))
    biography_text =
      biography_text_page.xpath("//textarea[@id='wpTextbox1']/text()")
    parse_biography_text(biography_text.text).html_safe
  end

  def generate_page_text_url(biography_name)
    URI.escape(
      "https://en.wikipedia.org/w/index.php?title=#{biography_name}&action=edit"
    )
  end

  def parse_biography_text(text_to_parse)
    text_to_parse.gsub(
      "[[", " ").gsub(
      "]]", " ").gsub(
      "{{", " ").gsub(
      "}}", "<br>" ).gsub(
      "==", "<br> <br>").gsub(
      "|thumb|", "<br> <br>"
    )
  end
end
