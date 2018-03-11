# CIAO: Curb Internet Addiction by Omission

**Bash command line tool for managing /etc/hosts**

## Motivation

I spend too much time on my computers browsing endless news articles
and social notes, and not enough time focussing on what I sat down at
my computer to do (always something other than just _browsing_). I've
tried Chrome & Firefox browser extensions, which all have their own
quirks and it's too easy to change browsers to one that isn't
blocking. I've tried managing my own `/etc/hosts` file, but inevitably
I get comfortable changing it and change it too often. So, none of
these focus solutions has worked particularly well for me.

I had a few priorities when I thought about building _ciao_.

+ works on all browsers
  + I regularly switch between 3+ browsers, so I need it to be hard to circumvent
+ accessible from the command line
  + I spend most of my productive time there
+ easy to integrate with my existing command line setup
  + my https://github.com/adamtait/dotfiles has a lifecycle; _install_, then _setup_, then _session_
+ easy to edit
  + _accessible from the command line_ covered most of this, but I also wanted to have plain text interface
+ easy to turn on/off
  + sometimes I do actually want to surf


This tool (really, a set of tools) works great for me. If you get into
it and have any thoughts or feedback, PRs & issues are certainly
welcome!


## Installation

#### TL;DR

```
./quick_install.sh
```

#### Full Install

1. clone this repo
2. source `cmd.sh` from your `.bashrc` or `.bash_profile`
3. run `./setup.sh`


## Design Decisions

#### duplicating /etc/hosts

I thought about just updating `/etc/hosts` in place, but decided that
solution was prone to error. Duplicating `/etc/hosts` means that:

+ we can maintain a backup
+ we can manage a regular text file to control our blocked DNS entries

These benefits seemed worth the additional complexity of having to
maintain the duplicate and syncing between them.


#### requiring a password for each change

Changing `/etc/hosts` requires changing a `root` owned file with
limited write permissions. This means `sudo`.

In my mind, an effort to drop the password was a closely balanced
tradeoff. It would be inconvenient to require `sudo` and entering your
password on every change, especially if you change `ciao` often. On
the other hand, isn't the point that you _shouldn't_ be enabling &
disabling often? Requiring a password is a barrier, possibly aiding to
curbing your internet addiction.

The tie-breaker was requiring additional setup & reduced security by
changing `/etc/sudoers` (or better, `/etc/sudoers.d/`) in order to
remove the password requirement of `sudo`.


#### not using a file watcher

When I first thought of this tool, I wanted the interface to be a
plain text file that I could easily edit and automatically have
changes reflected in /etc/hosts. Adding this feature would require
watching the file for changes, probably using a file watcher.

I use [watchman](https://facebook.github.io/watchman/) elsewhere and
think it's a well-designed tool. However, it wasn't worth the effort
to get sudo to work without a tty session available (watchman runs
without one).

There are other filesystem notification tools out there, and I haven't
tried them but suspect they would have similar challenges.


#### not using a cron

Setting focus time on schedule doesn't really suit my style.
Additionally, it would require special permissions (changes to
/etc/sudoers or /etc/sudoers.d) similar to a file watcher.
