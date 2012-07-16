---
layout: post
title: Node.js one-line install
category: code
---

For those that might find it useful, I wrote a
[tiny shell script](https://github.com/carlos8f/s8f.org/blob/gh-pages/node) to
install the latest build of [Node.js](http://nodejs.org/) on \*nix systems. It
uses [isaac's wonderful nave utility](https://github.com/isaacs/nave) to do all
the work. The only difference is that you won't have to download, link or
meddle with the script itself!

This script will build node in `~/.nave/src ` and install it in
`/usr/local`. A `sudo` passord may be required.

Usage
=====

```
$ curl s8f.org/node | sh
```

enjoy!