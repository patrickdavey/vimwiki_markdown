require 'spec_helper'
require 'vimwiki_markdown/options'
require 'vimwiki_markdown/template'
require 'vimwiki_markdown/exceptions'
require 'rspec-html-matchers'
require 'date'

module VimwikiMarkdown
  describe Template do
    let(:options) { Options.new }

    context "template" do

      subject { Template.new(options).to_s }
      before do
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
        allow(File).to receive(:open).with(options.template_filename,"r").and_return(StringIO.new(wiki_template))
      end

      it { should have_tag('title', text: 'Index') }
      it { should have_tag('h2', text: 'Index') }
    end

    context "missing pygments" do
      before do
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      end

      it "should raise an invalid exception for missing pygments" do
        allow(File).to receive(:open).with(options.template_filename,"r").and_return(StringIO.new(template_missing_pygments))
        expect { Template.new(options).to_s }.to raise_exception(MissingRequiredParamError)
      end
    end

    context "dark pygments" do
      before do
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      end

      it "should raise an invalid exception for missing pygments" do
        allow(File).to receive(:open).with(options.template_filename, "r").and_return(StringIO.new(dark_pygments))
        expect(Rouge::Themes::Github).to receive(:dark!) { true }
        Template.new(options).to_s
      end
    end

    context "using %root_path%" do
      before do
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      end

      it "correctly substitute %root_path%" do
        allow(File).to receive(:open).with(options.template_filename,"r").and_return(StringIO.new(wiki_template))

        rendered_template = Template.new(options).to_s
        expect(rendered_template).not_to include("%root_path%")
        expect(rendered_template).to include("./rootStyle.css")
      end
    end

    context "using %date" do
      before do
        allow(Options).to receive(:arguments).and_return(Options::DEFAULTS)
      end

      it "replaces %date% with todays date" do
        allow(File).to receive(:open).with(options.template_filename,"r").and_return(StringIO.new(wiki_template))
        rendered_template = Template.new(options).to_s
        expect(rendered_template).to include(Date.today.strftime("%e %b %Y"))
      end
    end
  end
end
