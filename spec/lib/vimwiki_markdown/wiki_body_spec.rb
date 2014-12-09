require 'spec_helper'
require 'vimwiki_markdown/options'
require 'vimwiki_markdown/wiki_body'
require 'rspec-html-matchers'

module VimwikiMarkdown
  describe WikiBody do

    let(:options) { Options.new }
    let(:wiki_body) { WikiBody.new(options) }
    before do
      allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return(wiki_index_markdown)
    end

    it "must convert wiki links" do
      expect(wiki_body.to_s).to match(/<a href="books.html">Books<\/a>/)
    end

    it "must not put a break tag in a blockquote" do
      binding.pry
      expect(wiki_body.to_s).not_to match(/blockquote<br>/)
    end

  end
end
