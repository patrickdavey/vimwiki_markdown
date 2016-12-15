# VimwikiMarkdown
[![Code Climate](https://codeclimate.com/github/patrickdavey/vimwiki_markdown/badges/gpa.svg)](https://codeclimate.com/github/patrickdavey/vimwiki_markdown)

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

### Fix for vimwiki links.
In vimwiki at the moment, it deletes any files in the site_html directory which do not match
against the markdown files (once they are translated into linked html).  Now, in vimwiki_markdown
we use ActiveSupports paramaterized method, as it's nicer on links.  If you want to have a
significant speed up, then you need to patch your vimwiki plugin to not delete files it
shouldn't be.  Here are links to the relevant bits:

1. [Add this function](https://github.com/patrickdavey/vimwiki-1/blob/9ebca2182fcf10e1bbf61abc8b4a535ce790480d/autoload/vimwiki/html.vim#L242-247)
2. [Make the is_html_uptodate look like this](https://github.com/patrickdavey/vimwiki-1/blob/9ebca2182fcf10e1bbf61abc8b4a535ce790480d/autoload/vimwiki/html.vim#L224-241)
3. For the moment, remove the call to deleting files `call s:delete_html_files(path_html)` - will work out a way around that later, not there now.
4. Might be some other things, check the diff in the above commits or open an issue.



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


## License

[MIT License](http://opensource.org/licenses/mit-license.php)
