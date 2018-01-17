require 'spec_helper'
require 'vimwiki_markdown/options'

module VimwikiMarkdown
  describe Options do
    let(:markdown_file_content) {wiki_template_title_markdown}
    let(:options) { Options.new }
    subject {options}

    context "no options passed" do
      before do
        allow(File).to receive(:open).and_return(StringIO.new("# title \n ## subtitle"))
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      end

      its(:force) { should be(true) }
      its(:syntax) { should eq('markdown') }
      its(:output_fullpath) { should eq("#{subject.output_dir}#{File.basename(subject.input_file, ".md")}.html") }
      its(:template_filename) { should eq('~/vimwiki/templates/default.tpl') }
    end

    context "file with tags in it" do
      before do
        allow(File).to receive(:open).and_return(StringIO.new(markdown_file_content))
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      end

      its(:template_filename) { should eq('~/vimwiki/templates/alt_template.tpl') }
      its(:title) { should eq('Super Cool Title')}
    end

  end
end
