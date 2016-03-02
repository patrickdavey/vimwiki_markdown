require 'active_support/inflector'
require 'github/markup'
require 'html/pipeline'
require 'pathname'

class VimwikiMarkdown::WikiBody
  MARKDOWN_LINK_REGEX = /\[(?<title>.*)\]\((?<path>.*)\)/

  def initialize(options)
    @options = options
  end

  def to_s
    @markdown_body = get_wiki_markdown_contents
    fixlinks
    github_markup = GitHub::Markup.render('README.markdown', markdown_body)
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::SyntaxHighlightFilter,
      HTML::Pipeline::TableOfContentsFilter
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
    convert_markdown_local_links!
    convert_wiki_style_links!
  end

  def convert_markdown_local_links!
    @markdown_body.gsub!(MARKDOWN_LINK_REGEX) do |match|
      title = Regexp.last_match[:title]
      path = Regexp.last_match[:path]

      if vimwiki_markdown_file_exists?(path)
        warn("\n\nXXXX file #{path} exists")
        path = Pathname.new(path)
        "[#{title}](#{path.dirname + path.basename(options.extension).to_s.parameterize}.html)"
      else
        warn("\n\nfile #{path} doesn't exist")
        "[#{title}](#{path})"
      end
    end
  end

  def vimwiki_markdown_file_exists?(path)
    File.exist?(Pathname(options.input_file).dirname + path) ||
    File.exist?(Pathname(options.input_file).dirname + "#{path}.#{options.extension}")
  end

  def convert_wiki_style_links!
    # convert [[style]] links
    @markdown_body.gsub!(/\[\[(.*?)\]\]/) do
      link_title = Regexp.last_match[1]
      "[#{link_title}](#{link_title.parameterize}.html)"
    end
  end
end
