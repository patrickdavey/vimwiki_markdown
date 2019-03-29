require 'spec_helper'
require 'vimwiki_markdown/options'

module VimwikiMarkdown
  describe Options do
    subject { Options.new }

    context "no options passed" do
      before do
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      end

      its(:force) { should be(true) }
      its(:syntax) { should eq('markdown') }
      its(:template_filename) { should eq('~/vimwiki/templates/default.tpl') }

      describe "extension" do
        it "deals with a different wiki extension correctly" do
          allow(Options).to receive(:arguments).and_return(
            ["1", #force - 1/0
             "markdown",
             "wiki",
             "~/vimwiki/site_html/",
             "~/vimwiki/index.wiki",
             "~/vimwiki/site_html/style.css",
             "~/vimwiki/templates/",
             "default",
             ".tpl",
             "-"]
          )

          expect(Options.new.title).to eq("Index")
        end
      end

      describe "#output_fullpath" do
        it "must rewrite files so that they match the paramaterized title" do
          expect(Options.new.output_fullpath).to eq("#{subject.output_dir}#{subject.title.parameterize}.html")
        end

        it "must correctly deal with filenames with spaces in them" do
          allow_any_instance_of(Options).to receive(:input_file) { "~/foo/name with spaces.md" }
          expect(Options.new.output_fullpath).to eq("#{subject.output_dir}name-with-spaces.html")
        end

        it "must correctly deal with filenames with capitalization issues" do
          allow_any_instance_of(Options).to receive(:input_file) { "~/foo/NAME WITH SPACES.md" }
          expect(Options.new.output_fullpath).to eq("#{subject.output_dir}name-with-spaces.html")
        end

        it "must correctly deal with filenames with spaces and a different extension" do
          allow_any_instance_of(Options).to receive(:extension) { "wiki" }
          allow_any_instance_of(Options).to receive(:input_file) { "~/foo/name with spaces.wiki" }
          expect(Options.new.output_fullpath).to eq("#{subject.output_dir}name-with-spaces.html")
        end
      end
    end
  end
end
