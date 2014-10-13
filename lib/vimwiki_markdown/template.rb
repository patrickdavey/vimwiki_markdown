require 'pygments.rb'

module VimwikiMarkdown
  class Template

    def initialize(options)
      @options = options
      get_template_contents

    end

    def to_s
      fixtags(template)
    end


    private

    attr_reader :options, :template

    def get_template_contents
      file = File.open(options.template_filename, "r")
      @template = file.read
      file.close
    end

    def fixtags(template)
      @template = template.gsub('%title%',title).gsub('%pygments%', Pygments.css('.highlight'))
    end

    def title
      options.title
    end
  end
end
