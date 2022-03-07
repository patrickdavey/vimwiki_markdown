require 'active_support/inflector'
require 'github/markup'
require 'html/pipeline'
require 'pathname'
require "vimwiki_markdown/vimwiki_link"
require "vimwiki_markdown/vimwiki_toc_filter"

class VimwikiMarkdown::WikiBody

  def initialize(options)
    @options = options
  end

  def to_s
    hack_replace_commonmarker_proc!

    @markdown_body = get_wiki_markdown_contents
    fixlinks
    html = GitHub::Markup.render_s(
      GitHub::Markups::MARKUP_MARKDOWN,
      markdown_body,
      options: { commonmarker_opts: [:UNSAFE] }
    )

    pipeline = HTML::Pipeline.new([
      HTML::Pipeline::SyntaxHighlightFilter,
      VimwikiTOCFilter
    ], { scope: "highlight"})
    @result = pipeline.call(html)
    @result = @result[:output].to_s
    enrich_li_class!
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
      VimwikiMarkdown::VimwikiLink.new(match, options.input_file, options.extension, options.root_path, options.output_dir).to_s
    end
  end

  def hack_replace_commonmarker_proc!
    GitHub::Markup::Markdown::MARKDOWN_GEMS["commonmarker"] = proc { |content, options: {}|
      commonmarker_opts = [:GITHUB_PRE_LANG].concat(options.fetch(:commonmarker_opts, []))
      commonmarker_exts = options.fetch(:commonmarker_exts, [:autolink, :table, :strikethrough])
      CommonMarker.render_html(content, commonmarker_opts, commonmarker_exts)
    }
  end

  def enrich_li_class!
    syms_hash = { " ]" => 0, ".]" => 1, "o]" => 2, "O]" => 3, "X]" => 4 }
    checkbox = /<li>\s*\[[\s.oOX]\]/
    checkbox_start = /<li>\s*\[/
    @result.gsub!(checkbox) do |m|
      m.sub(checkbox_start, '<li class="done')
        .sub(/[\s.oOX\]]*$/, syms_hash) << '">'
    end
    @result
  end
end
