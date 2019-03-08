require 'rouge'
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
      @template = @template.gsub('%root_path%', root_path)
    end

    def pygments_wrapped_in_tags
      "<style type=\"text/css\">
        #{::Rouge::Themes::Github.render(scope: '.highlight')}
      </style>"
    end

    def root_path
      options.root_path
    end

    def title
      options.title
    end

    def validate_template
      raise MissingRequiredParamError.new("ERROR: vimwiki template must contain %pygments% placeholder token.  Please visit https://github.com/patrickdavey/vimwiki_markdown for more information") unless @template =~ /%pygments%/
    end
  end
end
