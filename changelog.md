## 0.2.0 [March 6th 2016]
* Adds the ability for `[[source|title]]` style links to be parsed correctly
* Allows links with subdirectories `[[path/in/a/subdir/file]]` links to work
* Also allows vimwiki links formatted with markdown syntax to work, this
  feature is currently implemented on the dev branch. This means you can
  link to [my markdownfile](blah.md) and it'll be parsed correctly

## 0.1.3 [August 11th 2015]
* Adding the TableOfContents filter so that bookmarks are created.

## 0.1.1 [April 22nd 2015]
* Aaaaannnnd reverting that change.  While it totally works, it probably
  is overkill to have Druby running.  The major issue is that vimwiki
  deletes the old files as the filenames do not match.  Have added a
  note in the README to tell people how to make it faster.

## 0.1.0 [April 18th 2015]
* Quite a major change, we now spin up a Druby server in the background
  and then send the files across the wire to it.  This is somewhat
  invasive, but, on the plus side, takes the compilation time from
  several minutes down to seconds as we're not having to start
  up and require a whole bunch of files all the time.

## 0.0.4 [Dec 9th 2014]
* Use Github::Markup to prerender the markdown

## 0.0.3 [Oct 30th 2014]

* Raise warning if pygments placeholder is not present

## 0.0.2 [Sept 2014]

* Initial beta release of the vimwiki_markdown gem
