Grok
====

Grok makes it easy to develop from multiple Macs (home, work, laptop, etc).

```bash
bash <(curl -fsSL https://raw.github.com/levithomason/grok/master/install)
```
Grok asks before doing anything nuclear and gives options like backup, overwrite or skip.

## Examples

    # cli tools
    $ grok install cli hero-toolbelt

    # desktop apps
    $ grok install app slack

    # pull the repo and run grok
    $ grok update

_______________________________________________________________________________
  
## BigFatWarning™

*This repo is specialized for my machine.*

Grok will configure your osx settings, desktop apps, cli tools, dotfiles, run 
custom scripts, and make you hate me for turning your machine into something
only I know how to use.

## Quick Start

**Install**  
Run the bash curl script above or clone and run `bash ./bootstrap`. 

**Modify**  
Hack on `~/.grokfiles`.  Run `grok` to execute changes. Push when you're happy. 

**Update**  
Run `grok` at anytime to pull the latest changes and configure your machine.

## Why Grok?

Grok is a branded [dotfiles](https://dotfiles.github.io/) setup.  I started
following [Steven Skoczen](https://github.com/skoczen/dotfiles) and forking
[Paul Miller](https://github.com/paulmillr/dotfiles).  After comparing the 
[other greats](https://dotfiles.github.io/) and switching to zsh, I forked
[Zach Holman's](http://github.com/ryanb) dotfiles.  Zach's rig really impressed
me and I credit mostly his work. I then setup [boxen](https://boxen.github.com)
to provision an entire rig.  This went on a few years.

Then, I wanted something easy to use, that did it all, something I could *grok*.

## Features
Here are some of the things Grok does.  Better docs will happen.

**OSX Settings**  
See `/topic/osx`

**Desktop Apps**  
See `/topic/homebrew`.

**CLI Tools**  
See `/topic/homebrew`.

**dotfiles**  
See `/bootstrap/` for initial setup and symlinking of your `~/.*` files.  
See `/topic/zsh/zshrc.symlink` for what happens when your shell starts.

**...custom scripts**  
I needed to sync WebStorm settings, all of them, and the plugin didn't work.
After reading the JetBrains
[docs](https://www.jetbrains.com/webstorm/help/project-and-ide-settings.html#d552893e149) 
on settings, it's pretty easy.  Custom topics let you manage things like this.

See `/topics/webstorm/` for how I sync them with DropBox.

## Learn More

### ~/.grokfiles...
Everything lives here.  Your original `~/.*` files are symlinked here, too.

Grok organizes dotfiles by topic. Think of a topic as a domain where files are 
loaded in sane order:

    /topics                   load order
      /foo-topic              ----------
        path.zsh              1st
        *.zsh                 2nd  (except path/completion)
        completion.zsh        3rd
        install.sh            only on `bootstrap`
        *.symlink             only on `bootstrap`

#### /topics/foo-topic...

##### /path.zsh
>Loaded first, expected to setup `$PATH`.

##### /\*.zsh
>Anything with an extension of `.zsh` will get automatically included into your 
shell.  Runs after `path.zsh` files and before `completion.zsh` files.

##### /completion.zsh
>Loaded last, expected to setup autocomplete.

##### /install.sh
>This file is only loaded during the initial `bootstrap` or by running `grok`.

##### /\*.symlink
>Anything with an extension of `.symlink` will get symlinked without extension 
>into `$HOME`.  This is so you can keep all of those versioned in your dotfiles 
>but still keep those autoloaded files in your home directory.
>
>This only happens when running `/bootstrap`. 

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

This is everything grok needs to run.  Scripts that are needed throughout Grok
are placed here. It'd be a good idea to understand what these are doing.
