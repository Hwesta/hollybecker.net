---
layout: default
title: "TIL: SASS & locale-gen"
excerpt: When deploying my newly Jekyll-ified site to my webserver, I ran into some locale problems with SASS generation and thought someone else can learn from my pain.
date: 2017-10-22
tags: til jekyll sass locale
---

<section id='intro' markdown='1'>
I decided to switch this site from a handful of HTML & CSS pages to a static site generator, Jekyll. When deploying it to my webserver, I ran into some locale problems with SASS generation and thought someone else can learn from my pain.

[Just the solution please](#summary)
</section>

<section markdown='1'>
I've never used Jekyll before and I haven't really used Ruby so I had a few problems installing gems into the right places that I sorted out with [Misty]'s help.  [Jekyll], [Bundler] & [SASS] all recommend `gem install`. Jekyll uses Bundler for project dependencies.  However, I later ran into what I think were conflicts between the gems installed in my user directory and the gems installed by Bundler for my project. My solution was to install Bundler & SASS at the system level (`pacman -S ruby ruby-bundle ruby-sass`), use Bundler for project dependencies, and use `bundle exec jekyll` for any Jekyll commands I needed.  The `rm -rf ~/.gem` to delete user directory gems was very cathartic.

[Misty]: https://twitter.com/mistydemeo
[Jekyll]: https://jekyllrb.com/docs/installation/#install-with-rubygems
[Bundler]: http://bundler.io/
[SASS]: http://sass-lang.com/install

The conversion to Jekyll was pretty easy and I was ready to deploy it to my webserver.  When trying to generate the site on the webserver I ran into this problem:

```
$ bundle exec jekyll build
Configuration file: /home/holly/hollybecker.net/_config.yml
            Source: /home/holly/hollybecker.net
       Destination: /home/holly/hollybecker.net/_site
 Incremental build: disabled. Enable with --incremental
      Generating... 
  Conversion error: Jekyll::Converters::Scss encountered an error while converting 'css/main.scss':
                    Invalid US-ASCII character "\xE2" on line 2
jekyll 3.6.0 | Error:  Invalid US-ASCII character "\xE2" on line 2
```

Huh?

`\xE2` is `â` but I don't have any of those in my project.  It's definitely not on line 2 of `css/main.scss` since that's the second line of the empty YAML frontmatter needed so Jekyll parses the file.  Also, this command works on my desktop and another Arch Linux server.  The versions of SASS, Jekyll and Bundler are the same.  The webserver is 32-bit, but a 32-bit VM Arch Linux VM didn't have this issue either.

Google led me to a [Jekyll issue] with the same problem I was having which was quite useful. It suggested specifying the encoding in several places, none of which worked.  It also helped track down that the problem wasn't in `css/main.scss` but in the imports and provided a neat tip on how to [grep for non-ASCII] with `grep --color='auto' -P -n "[\x80-\xFF]" file.xml`

[Jekyll issue]: https://github.com/jekyll/jekyll/issues/4268
[grep for non-ASCII]: https://stackoverflow.com/a/13702856

A-ha! Grepping for non-ASCII on the webserver found a lot of comments with en-dashes instead of hyphens.  An en-dash is `\xe2\x80\x93`, hence the misleading `\XE2` in the error earlier. However, the same grep command on my desktop didn't find anything.

Now I had a workaround - I could replace the en-dashes with hyphens - but I was curious what's going on.

I narrowed it down to a more minimal test case using the pre-Jekyll master branch.  The problem was just with SASS, not Jekyll or Bundler. I hadn't run into it previously because I ran SASS on my desktop and committed the results, instead of generating the site on the webserver.

```bash
$ sass sass/main.scss css/main.css 
Error: Invalid US-ASCII character "\xE2"
        on line 2 of sass/base/_variables.scss
        from line 14 of sass/main.scss
  Use --trace for backtrace.
```

This is clearly an encoding problem, so I looked at the locale related environment variables. My desktop looks fine:
```bash
holly@desktop$ env | grep LANG
LANG=en_CA.UTF-8
LANGUAGE=en_US:en_GB
```

But the webserver is very suspicious:
```bash
holly@webserver$ env | grep LANG
LANG=C
```

The `C` locale is [aimed at computers over people][C locale] and doesn't understand UTF-8.  However, setting the locale to something with UTF-8 support (`export LANG=en_CA.UTF-8`) didn't fix the problem.

[C locale]: https://unix.stackexchange.com/a/87763

I didn't realize this until the next morning, but I'd forgotten to check which locales were actually generated.  Neither `en_US.UTF-8` nor `en_CA.UTF-8` actually existed on the system and it was probably falling back to the only locale it knew about: `C`.

To fix this I generated the `en_US.UTF-8` locale (uncommented `en_US.UTF-8 UTF-8` in `/etc/locale.gen` and ran `locale-gen`) and confirmed it worked by listing all generated locales (`locale -a`).  I set the system locale in `/etc/locale.conf` to `LANG=en_US.UTF-8`, though once the locale was generated, I could have set the `LANG` in the terminal I was using as well.

After all this, it worked! Jekyll & SASS ran and correctly generated the CSS, even with unicode characters involved.

As for why this happened, this webserver had been installed in 2009 before Arch changed the default locale to one with UTF-8 support.  All the other servers I checked on had been installed more recently or had been updated to a UTF-8 locale and didn't have this problem.
</section>

### Summary

<section id='summary' markdown='1'>
When generating SASS, I had the error:

```bash
$ sass sass/main.scss css/main.css
Error: Invalid US-ASCII character "\xE2"
        on line 2 of sass/base/_variables.scss
        from line 14 of sass/main.scss
  Use --trace for backtrace.
```

The fix was to generate UTF-8 system locale and set it.

1. Check if locale exists: `locale -a`
2. If not, generate locale: Uncomment locale name in `/etc/locale.gen` and run `sudo locale-gen`
3. Set locale for the system: Edit `/etc/locale.conf` and log in again for it to take effect
4. Or set locale for the terminal
   * bash: `export LANG=en_US.UTF-8`
   * fish: `set -xg LANG en_US.UTF-8`
</section>