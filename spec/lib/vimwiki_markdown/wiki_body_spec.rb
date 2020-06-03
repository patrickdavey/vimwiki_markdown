require 'spec_helper'
require 'vimwiki_markdown/options'
require 'vimwiki_markdown/wiki_body'
require 'rspec-html-matchers'

module VimwikiMarkdown
  describe WikiBody do

    let(:wiki_body) { WikiBody.new(double(:options, input_file: 'blah', extension: 'md', root_path: '-', output_dir: ".")) }
    let(:markdown_file_content) { wiki_index_markdown }

    it "must convert wiki links" do
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return(markdown_file_content)
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      expect(wiki_body.to_s).to match(/<a href="books.html">Books<\/a>/)
      expect(wiki_body.to_s).to match(/<a href="bash-tips.html">Bash Tips<\/a>/)
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

    it "must convert html content correctly" do
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("<p>hello world</p>")
      expect(wiki_body.to_s).to include("<p>hello world</p>")
    end

    it "must convert unsafe html content correctly" do
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return('<iframe src="test"></iframe>')
      expect(wiki_body.to_s).to include('<iframe src="test"></iframe>')
    end

    it "must convert multiple links on the same line correctly" do
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("[here](here) [there](there)")
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      expect(wiki_body.to_s).to match(/<a href="here.html">here<\/a>/)
      expect(wiki_body.to_s).to match(/<a href="there.html">there<\/a>/)
    end

    it "must enrich task list unchecked" do
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("- [ ] This is one line")
      expect(wiki_body.to_s).to match(/<li class="done0"> This is one line<\/li>/)
    end

    it "must enrich task list checked" do
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("- [X] This is a checked line")
      expect(wiki_body.to_s).to match(/<li class="done4"> This is a checked line<\/li>/)
    end

    it "must enrich task list parent 1" do
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("- [.] This is a parent 1 line")
      expect(wiki_body.to_s).to match(/<li class="done1"> This is a parent 1 line<\/li>/)
    end

    it "must enrich task list parent 2" do
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("- [o] This is a parent 2 line")
      expect(wiki_body.to_s).to match(/<li class="done2"> This is a parent 2 line<\/li>/)
    end

    it "must enrich task list parent 3" do
      allow_any_instance_of(VimwikiMarkdown::VimwikiLink).to receive(:vimwiki_markdown_file_exists?).and_return(true)
      allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("- [O] This is a parent 3 line")
      expect(wiki_body.to_s).to match(/<li class="done3"> This is a parent 3 line<\/li>/)
    end

    describe "syntax highlighting" do
      it "must give correct classes" do
        allow(wiki_body).to receive(:get_wiki_markdown_contents)
          .and_return("```bash\n  find ./path -type f -exec sed -i 's/find_this/replace_this/g' {} \\;\n```\n")
        expect(wiki_body.to_s).to match(/highlight/)
      end
    end
  end
end
