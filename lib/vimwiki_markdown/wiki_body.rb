require 'active_support/inflector'
require 'github/markup'
require 'html/pipeline'
require 'pathname'

class VimwikiMarkdown::WikiBody

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

  def vimwiki_markdown_file_exists?(path)
    File.exist?(Pathname(options.input_file).dirname + path) ||
    File.exist?(Pathname(options.input_file).dirname + "#{path}.#{options.extension}") ||
    absolute_path_exists?(path)
  end

  def convert_wiki_style_links!
    # convert [[style]] links
    @markdown_body.gsub!(/\[\[(.*?)\]\]/) do
      link_title = Regexp.last_match[1]
      "[#{link_title}](#{link_title.parameterize}.html)"
    end
  end

  def absolute_path_exists?(path)
    path.absolute? && (
      File.exist?(options.input_file.dirname + options.root_path + path.to_s.sub(/^\//,"")) ||
      File.exist?(options.input_file.dirname + options.root_path + path.to_s.sub(/^\//,"").sub(/$/, ".#{options.extension}")))
  end
end
