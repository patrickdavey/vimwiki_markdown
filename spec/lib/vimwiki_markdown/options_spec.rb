require 'spec_helper'
require 'vimwiki_markdown/options'

module VimwikiMarkdown
  describe Options do
    let(:options) { Options.new }

    context "no options passed" do
      before do
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      end

      its(:force) { should be(true) }
      its(:syntax) { should eq('markdown') }
      its(:output_fullpath) { should eq("#{subject.output_dir}#{subject.title.parameterize}.html") }
      its(:template_filename) { should eq('/home/patrick/vimwiki/templates/default.tpl') }
    end

    context "with an already existing html output" do
      let(:path) { options.output_fullpath }

      before do
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      end

      it "#unmodified? should return false if the file does not exist" do
        allow(File).to receive(:exist?).with(path) { false }
        expect(options.unmodified?).to be(false)
      end

      it "#unmodified? should return true" do
        allow(File).to receive(:exist?).with(path) { true }
        allow(File).to receive(:mtime).with(path) { Date.today }
        allow(File).to receive(:mtime).with(options.input_file) { Date.today - 1 }
        expect(options.unmodified?).to be(true)
      end
    end
  end
end
