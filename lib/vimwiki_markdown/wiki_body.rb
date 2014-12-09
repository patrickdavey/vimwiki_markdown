require 'active_support/inflector'
require 'github/markup'
require 'html/pipeline'

class VimwikiMarkdown::WikiBody

  def initialize(options)
    @options = options
  end

  def to_s
    @markdown_body = get_wiki_markdown_contents
    fixlinks
    github_markup = GitHub::Markup.render('README.markdown', markdown_body)
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::SyntaxHighlightFilter
    ]
    result = pipeline.call(github_markup)
    result[:output].to_s
  end


  private

  attr_reader :options, :markdown_body

  def get_wiki_markdown_contents
    file = File.open(options.input_file, "r")
    file.read
  end

  def fixlinks
    #convert wiki_links to markdown links
    # [This link](http://example.net/)
    @markdown_body.gsub!(/\[\[(.*?)\]\]/) do
      link_title = Regexp.last_match[1]
      "[#{link_title}](#{link_title.parameterize}.html)"
    end
  end
end
