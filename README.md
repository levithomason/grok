# Grokfiles

Grokfiles keeps your dotfiles, OSX settings, and your desktop apps in git.

```bash
bash <(curl -fsSL https://raw.github.com/levithomason/grokfiles/master/install)
```
>Clone to ~/.grokfiles and run bootstrap.

Run **grok** to sync your:
- osx settings
- desktop apps
- command lind tools
- dotfiles

## ~/.grokfiles

Everything lives here.  You're original `~/.*` files are symlinked here, too.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

## Topics

Dotfiles organizes dotfiles by topic. Think of a topic as a domain.

Files are loaded in sane order:

    /topics                   load order
      /foo-topic              ----------
        path.zsh              1st
        *.zsh                 2nd  (except path/completion)
        completion.zsh        3rd
        install.sh            only on `bootstrap`
        *.symlink             only on `bootstrap`

**topic/...**

**path.zsh**
Loaded first, expected to setup `$PATH`.

**\*.zsh**
Anything with an extension of `.zsh` will get automatically included into your 
shell.  Runs after `path.zsh` files and before `completion.zsh` files.

**completion.zsh**
Loaded last, expected to setup autocomplete.

**install.sh**
This file is only loaded during the initial `bootstrap` or by running `grok`.

**\*.symlink**
Anything with an extension of `.symlink` will get symlinked without extension 
into `$HOME`.  This is so you can keep all of those versioned in your dotfiles 
but still keep those autoloaded files in your home directory.

This only happens when running `/bootstrap`. 

### Adding topics
If you're adding a new area to your dotfiles — like, "Java" — simply add a 
`java` directory to `/topics` and put files in it as described above.

## Structure

### /bin

Anything in `/bin` will be made available on your `$PATH`.

### /functions

Functions and their respective completions (files starting with `_`) live here.
All functions will be made available in your shell.

Take a look at the a couple for an example.

## Road Map
- refactor naming to grokfiles
- grokfiles cli
  - ~~update (pull changes, run)~~
  - search/install/uninstall desktop app (alias brew cask, record changes)
  - edit (open project in $EDITOR, replace system alias `odot`)
- convert scripts to zsh

## Imitating Greats

I got my dotfiles start following
[Steven Skoczen](https://github.com/skoczen/dotfiles) and forking
[Paul Miller](https://github.com/paulmillr/dotfiles).  After comparing the 
[other greats](https://dotfiles.github.io/) and switching to zsh, I forked
[Zach Holman's](http://github.com/ryanb) dotfiles.  Zach's rig really impressed
me and I credit mostly his work.  Eventually, I wanted something light and 
specific.

These are my dotfiles, heavily inspired (and copied) from theirs.
