# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vimwiki_markdown/version'

Gem::Specification.new do |spec|
  spec.name          = "vimwiki_markdown"
  spec.version       = VimwikiMarkdown::VERSION
  spec.authors       = ["Patrick Davey"]
  spec.email         = ["patrick.davey@gmail.com"]
  spec.summary       = %q{Converts a github flavoured markdown vimwiki file into html.}
  spec.description   = %q{Converts a vimwiki markdown file to html.  It parses [[links]] and has support for syntax highlighting.}
  spec.homepage      = "https://github.com/patrickdavey/wimwiki_markdown"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rspec-html-matchers"
  spec.add_development_dependency "guard-rspec"

  spec.add_runtime_dependency     "activesupport", "~> 4.1.6"
  spec.add_runtime_dependency     "github-markup"
  spec.add_runtime_dependency     "github-markdown"
  spec.add_runtime_dependency     "github-linguist", "~> 3.1.5"
  spec.add_runtime_dependency     "redcarpet", "~> 3.1.2"
  spec.add_runtime_dependency     "html-pipeline"
end
