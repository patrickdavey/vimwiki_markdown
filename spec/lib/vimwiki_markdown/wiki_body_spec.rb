require 'spec_helper'
require 'vimwiki_markdown/options'
require 'vimwiki_markdown/wiki_body'
require 'rspec-html-matchers'

module VimwikiMarkdown
  describe WikiBody do

    let(:wiki_body) { WikiBody.new(double(:options, input_file: 'blah', extension: 'md', root_path: '-')) }
    let(:markdown_file_content) { wiki_index_markdown }

    it "must convert wiki links" do
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return(markdown_file_content)
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      expect(wiki_body.to_s).to match(/<a href="books.html">Books<\/a>/)
    end

    it "must convert wiki links with separate titles correctly" do
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("[[http://www.google.com|google]]")
      expect(wiki_body.to_s).to match(/<a href="http:\/\/www.google.com">google<\/a>/)
    end

    it "must not put a break tag in a blockquote" do
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return(markdown_file_content)
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      expect(wiki_body.to_s).not_to match(/blockquote<br>/)
    end

    it "must leave normal content alone" do
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("hello")
      expect(wiki_body.to_s).to match(/hello/)
    end

    it "must convert multiple links on the same line correctly" do
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("[here](here) [there](there)")
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      expect(wiki_body.to_s).to match(/<a href="here.html">here<\/a>/)
      expect(wiki_body.to_s).to match(/<a href="there.html">there<\/a>/)
    end
  end

end
