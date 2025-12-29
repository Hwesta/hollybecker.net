---
layout: blog-post
title: The case of the missing 32-bit Ruby package
summary: On a 32-bit Arch server I recently started getting a LoadError from Ruby when importing date_core, even though the package was installed. Where did it go and why is this happening?
excerpt: On a 32-bit Arch server I recently started getting a LoadError from Ruby when importing date_core, even though the package was installed. Where did it go and why is this happening?
date: 2023-08-03
tags: til ruby
---

I have access to a 32-bit Arch server that hosts this website and I use Ruby on it to run `jekyll` for static site generation. I don't touch it very often, but recently I started getting this exception:

```bash
$ irb
irb(main):001:0> require "date_core"
<internal:/usr/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require': cannot load such file -- date_core (LoadError)
        from <internal:/usr/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from (irb):1:in `<main>'
        from /usr/lib/ruby/gems/3.0.0/gems/irb-1.4.2/exe/irb:11:in `<top (required)>'
        from /usr/bin/irb:25:in `load'
        from /usr/bin/irb:25:in `<main>'
```

I reproduced it with just the `require`, but I first encountered it running `bundle exec jekyll build`. The error is happening because Ruby is trying to load `date_core` (which is a compiled-from-C `.so` file) and can't find it on any of the load paths. It's the same error you get if you try to import nonsense like `require "aoeuaoeu"`.

tl;dr This can be worked around by setting Ruby's `$LOAD_PATH` to explicitly include the directory

```bash
export RUBYLIB=/usr/lib/ruby/3.0.0/x86-linux/
```

but it's weird that it's happening at all.

----

I eventually tracked the problem down to `date_core.so` being in `/usr/lib/ruby/3.0.0/x86-linux/` which was not on Ruby's path so it couldn't find it to load it.

```bash
$ ls /usr/lib/ruby/3.0.0/x86-linux/date_core.so
/usr/lib/ruby/3.0.0/x86-linux/date_core.so   # This is in the directory x86-linux
$ ruby -e 'puts $LOAD_PATH'
/usr/lib/ruby/site_ruby/3.0.0
/usr/lib/ruby/site_ruby/3.0.0/i686-linux
/usr/lib/ruby/site_ruby
/usr/lib/ruby/vendor_ruby/3.0.0
/usr/lib/ruby/vendor_ruby/3.0.0/i686-linux
/usr/lib/ruby/vendor_ruby
/usr/lib/ruby/3.0.0
/usr/lib/ruby/3.0.0/i686-linux  # The directory it's looking in is i686-linux
```

The path that Ruby does look in also exists and has other installed Ruby packages in it. It's very strange that 32-bit `.so` files for Ruby packages are in both `i686` and `x86-linux` and that Ruby only seems to know about one of them.

```bash
$ ls /usr/lib/ruby/3.0.0/x86-linux/
bigdecimal.so  cgi  date_core.so
$ ls /usr/lib/ruby/3.0.0/i686-linux/
continuation.so  dbm.so  digest.so  etc.so    fiber.so   gdbm.so  json        nkf.so       openssl.so   psych.so  racc      rbconfig.rb  ripper.so  stringio.so  syslog.so
coverage.so      digest  enc        fcntl.so  fiddle.so  io       monitor.so  objspace.so  pathname.so  pty.so    rbconfig  readline.so  socket.so  strscan.so   zlib.so
```

For each directory, I found a package that owned files there so I could look at their build scripts and compare them: ruby-date & ruby-digest.

```bash
$ yay -Qo /usr/lib/ruby/3.0.0/x86-linux/date_core.so /usr/lib/ruby/3.0.0/i686-linux/digest.so
/usr/lib/ruby/3.0.0/x86-linux/date_core.so is owned by ruby-date 3.2.2-4.0
/usr/lib/ruby/3.0.0/i686-linux/digest.so is owned by ruby-digest 3.1.0-5.8
```

Arch Linux has officially deprecated 32-bit support, so this is where the research became harder. I think ArchLinux32 use the same packages as ArchLinux unless something needs to be different. I didn't find anything suspicious in the [32-bit specific](https://git.archlinux32.org/packages/tree/extra/ruby-date/PKGBUILD) [packaging scripts](https://git.archlinux32.org/packages/tree/extra/ruby-digest/PKGBUILD) so I looked at the upstream `PKGBUILD`s.

I think [both](https://gitlab.archlinux.org/archlinux/packaging/packages/ruby-date/-/blob/main/PKGBUILD#L29) [packages](https://gitlab.archlinux.org/archlinux/packaging/packages/ruby-digest/-/blob/main/PKGBUILD#L35) use `local _platform="$(gem env platform | cut -d':' -f2)"` to generate the platform-specific version, but it's producing different results. Since previously I didn't get the exception, I looked in the pacman logs to find the version difference - `ruby-date (3.2.2-3.6 -> 3.2.2-4.0)` which means it was only a change in how it was packaged - but both before and after use `gem env platform` so it's probably not that.

I couldn't find a definite answer, but my suspicion is that the different packages (and package versions) are built on different computers, and on some of them `gem env platform` produces `i686` and on others `x86-linux`, but I'm not sure why.

I didn't get any further than this - the server was reinstalled with a 64-bit Arch which didn't have the same problems. If you run into the same problem or figure out what was going on, please let me know!