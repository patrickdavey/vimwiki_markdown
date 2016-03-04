require 'spec_helper'
require 'vimwiki_markdown/options'
require 'vimwiki_markdown/wiki_body'
require 'rspec-html-matchers'

module VimwikiMarkdown
  describe WikiBody do

    let(:wiki_body) { WikiBody.new(double(:options)) }
    let(:markdown_file_content) { wiki_index_markdown }

    before do
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return(markdown_file_content)
    end

    it "must convert wiki links" do
      expect(wiki_body.to_s).to match(/<a href="books.html">Books<\/a>/)
    end

    it "must not put a break tag in a blockquote" do
      expect(wiki_body.to_s).not_to match(/blockquote<br>/)
    end

    it "must leave normal content alone" do
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("hello")
      expect(wiki_body.to_s).to match(/hello/)
    end
  end

end
