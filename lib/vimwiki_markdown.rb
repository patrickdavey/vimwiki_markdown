require "vimwiki_markdown/version"
require "vimwiki_markdown/options"
require "vimwiki_markdown/template"
require "vimwiki_markdown/vimwiki_link"
require "vimwiki_markdown/wiki_body"
require "vimwiki_markdown/exceptions"

module VimwikiMarkdown
  def self.convert_wikimarkdown_to_html
    ::I18n.enforce_available_locales = false

    options = Options.new
    template_html = Template.new(options)
    body_html = WikiBody.new(options)
    combined_body_template = template_html.to_s.gsub('%content%', body_html.to_s)

    File.write(options.output_fullpath, combined_body_template)

  rescue MissingRequiredParamError => e
    warn e.message
    exit(0)
  end
end
