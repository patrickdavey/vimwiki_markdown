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
      its(:template_filename) { should eq('/home/patrick/vimwiki/templates/default.tpl') }
    end
  end
end
