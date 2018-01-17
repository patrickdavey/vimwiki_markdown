require 'bundler/setup'
require 'pry'
require 'rspec/its'
require 'vimwiki_markdown'

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    # be_bigger_than(2).and_smaller_than(4).description
    #   # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #   # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Limits the available syntax to the non-monkey patched syntax that is recommended.
  # For more details, see:
  #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://myronmars.to/n/dev-blog/2014/05/notable-changes-in-rspec-3#new__config_option_to_disable_rspeccore_monkey_patching
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end
end

def wiki_index_markdown
"
## Patrick Davey personal Wiki
* [[Books]] -- to read
* [[Vim Tips]]-- anything to do with vim.
* [[Git Tips]]-- anything to do with git.
* [[Bash Tips]]-- anything to do with bash.
* [[Mysql Tips]]-- anything to do with mysql.
* [[css - responsive - design Tips]]-- anything to do with css etc..
* [[Refinery]]-- useful Refinery Stuff
* [[Backbone]]-- useful Backbone Stuff
* [[Tmux]]-- useful Tmux Stuff
* [[Rails]]-- useful Rails Stuff
* [[Scratchpad]] temporary stuff.
* [[Server Setup]] -- checklist to setup a server.
* [[Todo]] -- things to do
* [[Quotes]] -- Nothing to do with programming!
* [[Movies to watch]] -- Movies to watch
* [[lent items]]
* [[bike stuff]]
* [[raspberrypi]]


## Languages
* [[Ruby]]-- useful Ruby Stuff
* [[iOS]]-- useful iOS Stuff
* [[JavaScript]]-- useful JS Stuff

> this is a blockquote
> without a linebreak
"
end

def wiki_template_title_markdown
"
%title super cool title\n
%template alt_template\n
## Todo\n
  1. add template functionality\n
  2. add title functionality\n
"
end

def wiki_template
<<-WIKITEMPLATE
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <link type="text/css" rel="stylesheet" href="./style.css" />
    <link type="text/css" rel="stylesheet" href="./styles/bootstrap.min.css" />
    <link type="text/css" rel="stylesheet" href="./overrides.css" />
    <link type="text/css" rel="stylesheet" href="./styles/shCore.css" />
    <link type="text/css" rel="stylesheet" href="./styles/shThemeDefault.css" />

    <!-- for testing %ROOT_PATH% substitutions -->
    <link type="text/css" rel="stylesheet" href="%root_path%rootStyle.css" />

    <script type="text/javascript" src="./scripts/shCore.js"></script>
    <script type="text/javascript" src="./scripts/shBrushRuby.js"></script>
    <script type="text/javascript" src="./scripts/shObjectiveC.js"></script>
    <script type="text/javascript" src="./scripts/shBrushBash.js"></script>
    <script type="text/javascript" src="./scripts/shBrushJScript.js"></script>
    <script type="text/javascript">
      SyntaxHighlighter.all();
    </script>
  <title>%title%</title>
  <meta http-equiv="Content-Type" content="text/html; charset=%encoding%">

  %pygments%
</head>
<body id="%title%">
  <div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container">
        <a class="brand" href="index.html">Wiki</a>
      </div>
    </div>
  </div>

  <div class="container">
    <div class="row">
      <div class="span12">
        <h2 id="title">%title%</h2>
        %content%
      </div>
    </div>
  </div>
</body>
</html>
WIKITEMPLATE
end

def template_missing_pygments
  wiki_template.gsub!('%pygments%','')
end
