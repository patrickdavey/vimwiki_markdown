# VimwikiMarkdown
[![Code Climate](https://codeclimate.com/github/patrickdavey/vimwiki_markdown/badges/gpa.svg)](https://codeclimate.com/github/patrickdavey/vimwiki_markdown) [![Build Status](https://travis-ci.org/patrickdavey/vimwiki_markdown.svg?branch=master)](https://travis-ci.org/patrickdavey/vimwiki_markdown)

This gem allows vimwiki pages written in (github enhanced) markdown
to be converted to HTML.

It is currently a work in progress (but working for me ;)

## Requirements

Ruby installed on your computer & up to date version of vimwiki

    https://www.ruby-lang.org/en/installation/

Install the vimwiki_markdown gem

    $ gem install vimwiki_markdown

## Setup

Ensure that your vimiwiki directive in your .vimrc is setup for markdown.  For
this we use the custom_wiki2html parameter.  My .vimrc looks like this:

    let g:vimwiki_list = [{'path': '~/vimwiki', 'template_path': '~/vimwiki/templates/',
              \ 'template_default': 'default', 'syntax': 'markdown', 'ext': '.md',
              \ 'path_html': '~/vimwiki/site_html/', 'custom_wiki2html': 'vimwiki_markdown',
              \ 'template_ext': '.tpl'}]

The most important part is the *'custom_wiki2html': 'vimwiki_markdown'*

### Install issues.
There have been some issues with getting dependencies installed. Before opening an issue, please check if you can use [rvm](http://rvm.io/) to install the gem, as RVM is magic and makes everything work ;)

### VimWiki Template

It is a requirement that your template file contain a placeholder
for the syntax highlighting code to be placed.  In order to do this,
open up your default.tpl (or whatever your template file is called)
and ensure that before the closing </head> tag you put
`%pygments%`

A sample tpl file is available here https://raw.githubusercontent.com/patrickdavey/vimwiki_markdown/master/example_files/default.tpl

#### Optional %root_html% marker.

You can also have a `%root_html%` marker in your template file, thanks
to [this commit](https://github.com/patrickdavey/vimwiki_markdown/commit/8645883b96df9962aba616d0d12961285cd3f4d7).
It will get rewritten with the relative path to the root
of the site (e.g. `./` or `../../` etc)

## Contributing

Pull requests are very welcome, especially if you want to implement some of the
more interesting vimwiki links (e.g. :local etc.)

1. Fork it ( https://github.com/patrickdavey/vimwiki_markdown/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Known Issues

In the `vimwiki_markdown` gem, links are written out using Rails' paramaterized method. That is, a link like "my awesome link" is turned into "my-awesome-link". Vimwikis built-in support for
checking whether a file needs to be re-generated or not uses a mixture of timestamp and whether the output file exists. Unfortunately, vimwiki _doesn't_ paramaterize their output files, so, quite often there's
a mismatch in terms of whether a file exists. I had patched previous version of vimwiki, but, I haven't done it with the latest version. If you _want_ to look at it, there's [some information in a previous version of this README](https://github.com/patrickdavey/vimwiki_markdown/blob/4cf18a3fb329895e2062a1a56c83074d215e93c4/README.md#fix-for-vimwiki-links), but, you're on your own ;)

## License

[MIT License](http://opensource.org/licenses/mit-license.php)
