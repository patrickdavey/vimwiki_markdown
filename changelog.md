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
