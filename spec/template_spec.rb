require 'spec_helper'
require 'vimwiki_markdown/options'
require 'vimwiki_markdown/template'
require 'rspec-html-matchers'

module VimwikiMarkdown
  describe Template do

    context "template" do
      let(:options) { Options.new }

      subject { Template.new(options).to_s }
      before do
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
        allow(File).to receive(:open).with(options.template_filename,"r").and_return(StringIO.new(wiki_template))
      end

      it { should have_tag('title', text: 'Index') }
      it { should have_tag('h2', text: 'Index') }
    end
  end
end
