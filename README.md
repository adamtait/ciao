# DNS blocker

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

I had a few priorities when I thought about building _DNS blocker_.

+ works on all browsers
  + I regularly switch between 3+ browsers, so I need it to be hard to circumvent
+ accessible from the command line
  + I spend most of my productive time there
+ easy to integrate with my existing command line setup
  + my https://github.com/adamtait/dotfiles has a lifecycle; _install_, then _setup_, then _session_
+ easy to edit
  + _accessible from the command line_ covered most of this, but I also wanted to have clean text interface
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


#### changing permissions on /etc/hosts

This was a tough one for me. I really wanted to maintain the `644`
permissions on `/etc/hosts` but since we need to update `/etc/hosts`
on each change and `/etc/hosts` has _root ownership_ and _644
permissions_, I needed to make a decision about how frequently to use
`sudo`.

Initially, I thought there might be an additional barrier added (a
good thing!) by requesting that the user give their password on every
change.

I also wanted to use [watchman](https://facebook.github.io/watchman/)
to watch changes to the _shadow blocked sites list_ and allow plain
text updates that didn't require a command line tool. However,
`watchman` made this impossible. From what I can tell, `watchman` runs
in the background and gives an error when running a script that
contains `sudo` amounting to _no terminal to request input from_.

Once I discovered the _watchman can't use sudo_ issue, I had a
tradeoff; dump `watchman` or change the permissions on `/etc/hosts`
permanently. I opted for the latter since I liked having `watchman`
there, and entering my password to change `/etc/hosts` wasn't hard (or
much of a barrier) before I wrote this tool.


#### using [watchman](https://facebook.github.io/watchman/)

There are other filesystem notification tools out there, but I was
already using [watchman](https://facebook.github.io/watchman/) so this
decision was mostly made.
