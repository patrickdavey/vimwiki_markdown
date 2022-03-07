class VimwikiTOCFilter < HTML::Pipeline::TableOfContentsFilter
  def call
    result[:toc] = String.new('')

    headers = Hash.new(1)
    doc.css('h1, h2, h3, h4, h5, h6').each do |node|
      text = node.text
      id = ascii_downcase(text)
      id.gsub!(PUNCTUATION_REGEXP, '') # remove punctuation
      id.tr!(' ', '-') # replace spaces with dash

      uniq = headers[id] > 1 ? "-#{headers[id]}" : ''
      headers[id] += 1
      if header_content = node.children.first
        result[:toc] << %(<li><a href="##{id}#{uniq}">#{EscapeUtils.escape_html(text)}</a></li>\n)
        header_content.add_previous_sibling(%(<a id="#{id}#{uniq}" class="anchor" href="##{id}#{uniq}" aria-hidden="true">#{anchor_icon}</a>))
      end
    end
    result[:toc] = %(<ul class="section-nav">\n#{result[:toc]}</ul>) unless result[:toc].empty?
    doc
  end

  if RUBY_VERSION >= '2.4'
    def ascii_downcase(str)
      str.downcase(:ascii)
    end
  else
    def ascii_downcase(str)
      str.downcase
    end
  end
end
