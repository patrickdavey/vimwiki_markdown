require 'spec_helper'
require 'vimwiki_markdown/options'

module VimwikiMarkdown
  describe Options do

    before(:each) do
      allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
    end

    context "no options passed" do
      it "should have default values" do
        allow(File).to receive(:open).and_return(StringIO.new("# title \n ## subtitle"))
        options = Options.new()
        expect(options.force).to be(true)
        expect(options.syntax).to eq('markdown')
        expect(options.output_fullpath).to eq("~/vimwiki/site_html/index.html")
        expect(options.template_filename).to eq('~/vimwiki/templates/default.tpl')
      end
    end

    context "file with tags in it" do
      it "should get information from tags" do
        allow(File).to receive(:open).and_return(StringIO.new(wiki_template_title_markdown))
        options = Options.new()
        expect(options.template_filename).to eq('~/vimwiki/templates/alt_template.tpl')
        expect(options.title).to eq('Super Cool Title')
      end
    end

  end
end
