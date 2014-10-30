require 'pygments.rb'

module VimwikiMarkdown
  class Template

    def initialize(options)
      @options = options
      get_template_contents

      validate_template
    end

    def to_s
      fixtags(template)
    end


    private

    attr_reader :options, :template

    def get_template_contents
      file = File.open(options.template_filename, "r")
      @template = file.read
    end

    def fixtags(template)
      @template = template.gsub('%title%',title).gsub('%pygments%',pygments_wrapped_in_tags)
    end

    def pygments_wrapped_in_tags
      "<style type=\"text/css\">
        #{Pygments.css('.highlight')}
      </style>"
    end

    def title
      options.title
    end

    def validate_template
      raise MissingRequiredParam.new("vimwiki template must contain %pygments% placeholder token") unless @template =~ /%pygments%/
    end
  end
end
