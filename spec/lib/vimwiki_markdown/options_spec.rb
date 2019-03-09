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
      its(:output_fullpath) { should eq("#{subject.output_dir}#{subject.title.parameterize}.html") }
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
    end
  end
end
