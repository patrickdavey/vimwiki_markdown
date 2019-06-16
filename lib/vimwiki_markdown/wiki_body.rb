require 'active_support/inflector'
require 'github/markup'
require 'html/pipeline'
require 'pathname'
require "vimwiki_markdown/vimwiki_link"

class VimwikiMarkdown::WikiBody

  def initialize(options)
    @options = options
  end

  def to_s
    @markdown_body = get_wiki_markdown_contents
    fixlinks
    html = GitHub::Markup.render_s(
      GitHub::Markups::MARKUP_MARKDOWN,
      markdown_body,
      options: { commonmarker_opts: [:UNSAFE] }
    )

    pipeline = HTML::Pipeline.new([
      HTML::Pipeline::SyntaxHighlightFilter,
      HTML::Pipeline::TableOfContentsFilter
    ], { scope: "highlight"})
    result = pipeline.call(html)
    result[:output].to_s
  end


  private

  attr_reader :options, :markdown_body

  def get_wiki_markdown_contents
    file = File.open(options.input_file, "r")
    file.read
  end

  def fixlinks
    convert_wiki_style_links_with_title_bar!
    convert_wiki_style_links!
    convert_markdown_local_links!
  end

  def convert_wiki_style_links_with_title_bar!
    wiki_bar = /\[\[(?<source>.*)\|(?<title>.*)\]\]/
    @markdown_body.gsub!(wiki_bar) do
      source = Regexp.last_match[:source]
      title = Regexp.last_match[:title]
      "[#{title}](#{source})"
    end
  end

  def convert_wiki_style_links!
    @markdown_body.gsub!(/\[\[(.*?)\]\]/) do
      link= Regexp.last_match[1]
      "[#{link}](#{link})"
    end
  end

  def convert_markdown_local_links!
    @markdown_body = @markdown_body.gsub(/\[.*?\]\(.*?\)/) do |match|
      VimwikiMarkdown::VimwikiLink.new(match, options.input_file, options.extension, options.root_path).to_s
    end
  end
end
