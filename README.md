# dotfiles

Configure UNIX-ish systems (including cygwin) the way I like them.

## Installing (the hard way)

```terminal
git clone git@github.com:carej/dotfiles.git ~/.dotfiles
~/.dotfiles/install.bash
```

## Installing (the easy way)

```terminal
curl https://raw.githubusercontent.com/carej/dotfiles/master/install.bash | bash -c
```

## Prerequisites

* On Windows systems with [Cygwin](https://www.cygwin.com/), [Beyond Compare](http://www.scootersoftware.com/index.php) should be symlinked to /usr/local/bin/bcomp
* Byobu/tmux was tested & confirmed to work with [Byobu](http://byobu.co/) 5.104 & [tmux](https://tmux.github.io/) 2.1
 * This required custom build & installation on RHEL 7 as of 21 March 2016
