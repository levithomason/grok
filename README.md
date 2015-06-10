Grokfiles
=========

## BigFatWarning™

*This repo is specialized for my machine. I plan to release a generic version
for everyone, soon.*

Grokfiles provisions and syncs your dev environment.

```bash
bash <(curl -fsSL https://raw.github.com/levithomason/grokfiles/master/install)
```
>  OSX Settings     Desktop Apps      CLI Tools     dotfiles      Custom Modules

## Quick Start

**Provision** a new Mac:  
Run the bash curl script above or clone and run `bash ./bootstrap`. 

**Reset/Update** one of your Macs:  
Run `grok` after bootstrapping.

## Why Grok?

Grok is a branded [dotfiles](https://dotfiles.github.io/) setup.  I started
following [Steven Skoczen](https://github.com/skoczen/dotfiles) and forking
[Paul Miller](https://github.com/paulmillr/dotfiles).  After comparing the 
[other greats](https://dotfiles.github.io/) and switching to zsh, I forked
[Zach Holman's](http://github.com/ryanb) dotfiles.  Zach's rig really impressed
me and I credit mostly his work. I then setup [boxen](https://boxen.github.com)
to provision an entire rig.

Eventually, I wanted something for my machines, something easy to understand.
Something I could **grok**.

## Features
Here are some of the things grok does.  Better docs will happen.

### OSX Settings

See `/topic/osx`

### Desktop Apps

See `/topic/homebrew`.

### CLI Tools

See `/topic/homebrew`.

### dotfiles

See `/bootstrap/` for initial setup and symlinking of your `~/.*` files.  
See `/topic/zsh/zshrc.symlink` for what happens when your shell starts.

### ...custom scripts

I needed to sync WebStorm settings, all of them, and the plugin didn't work.
After reading the JetBrains
[docs](https://www.jetbrains.com/webstorm/help/project-and-ide-settings.html#d552893e149) 
on settings, it's pretty easy.

See `/topics/webstorm/` for how I sync them with DropBox.

## Learn More

### ~/.grokfiles
Everything lives here.  You're original `~/.*` files are symlinked here, too.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

### Topics

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

#### Adding topics
If you're adding a new area to your dotfiles — like, "Java" — simply add a 
`java` directory to `/topics` and put files in it as described above.

### ~/.grokfiles/bin

Anything in `/bin` will be made available on your `$PATH`.

### ~/.grokfiles/functions

Functions and their respective completions (files starting with `_`) live here.
All functions will be made available in your shell.

Take a look at the a couple for an example.

### ~/.grokfiles/lib

This is everything grok needs to run.  Scripts that are needed throughout grok
are placed here. It'd be a good idea to understand what these are doing.

## Road Map
- better organized docs!
- change topics to modules and give quick start:
    - how they work
    - creating a module
- consistent logging, replace all `GROK:` logs.
- formalize a `grok` sync folder with prompt for Google Drive / DropBox
- refactor naming to grok
- flatten structure for easy of understanding, prefix non-module folders `_`
- grok cli
  - ~~update (pull changes, run)~~
  - search/install/uninstall desktop app (alias brew cask, record changes)
  - edit (open project in $EDITOR, replace system alias `odot`)
- convert scripts to zsh
