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


    describe "markdown style links" do
      let(:wiki_body) { WikiBody.new(instance_double("Options", template_ext: "md", input_file: "blah.md")) }

      it "must convert normal links correctly" do
        allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("[google](http://www.google.com)")
        expect(wiki_body.to_s).to have_tag('a', :with => { :href => "http://www.google.com" })
      end

      context "with an existing markdown file matching name" do
        let(:wiki_body) { WikiBody.new(instance_double("Options", {
          input_file: temp_wiki_dir + "input.md",
          template_ext: "md"
        })) }
        let(:existing_file) { "test.md" }
        let(:existing_file_no_extension) { File.basename(existing_file, ".md") }
        let(:temp_wiki_dir) { Pathname.new(Dir.mktmpdir("temp_wiki_")) }

        before(:each) do
          # here we create a stub test filename in the directory,
          FileUtils.touch(temp_wiki_dir + existing_file)
        end

        after(:each) do
          FileUtils.rm_r(temp_wiki_dir)
        end

        it "must convert markdown links correctly" do
          allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("[test](#{existing_file_no_extension})")
          expect(wiki_body.to_s).to have_tag('a', :with => { :href => "#{existing_file_no_extension}.html" })
          allow(wiki_body).to receive(:get_wiki_markdown_contents).and_return("[test](test.md)")
          expect(wiki_body.to_s).to have_tag('a', :with => { :href => "test.html" })
        end
      end
    end
  end

end
