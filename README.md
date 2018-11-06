# CIAO: Curb Internet Addiction by Omission

**Bash command line tool for managing /etc/hosts or DNSCrypt cloaking**

## Usage

```
ciao add facebook.com        # starts blocking facebook.com network access
ciao remove facebook.com     # stop blocking facebook.com
ciao off                     # stop block *all* added domains
ciao on                      # start blocking *all* domains, again
```


## Installation

#### TL;DR

Open a terminal, then

```
git clone https://github.com/adamtait/ciao.git
./ciao/quick_install.sh
```

#### Full Install

1. clone this repo
2. source `cmd.sh` from your `.bashrc` or `.bash_profile`
3. run `./setup.sh`
4. update your `~/.ciao/config`


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

In my mind, an effort to _not required a password_ was a closely balanced
tradeoff. It would be inconvenient to require `sudo` and enter your
password on every change, especially if you change `ciao` often. On
the other hand, isn't the point that you _shouldn't_ be enabling &
disabling often? Requiring a password is a barrier, possibly aiding to
curbing your internet addiction.

The tie-breaker was requiring additional setup & reduced security by
changing `/etc/sudoers` (or better, `/etc/sudoers.d/`) in order to
remove the password requirement of `sudo`.

Furthermore, if you make a bunch of changes within a few seconds of
each other then `sudo` won't ask for a password after the first
success. That was the most common frustrating scenario, which `sudo`
already makes painless.


Also considered was using `sudo` only once to change the
ownership/permissions on `/etc/hosts`. Beyond the lower permissions
being a possible security hole (any app could re-direct traffic from
your banking website to a phishing scam site), it didn't actually
work. Appending to a permissable `/etc/hosts` file worked but
overwriting it did not. I didn't delve further to understand the
source.



#### not using a file watcher

When I first thought of this tool, I wanted the interface to be a
plain text file that I could easily edit and automatically have
changes reflected in /etc/hosts. Adding this feature would require
watching the file for changes, probably using a file watcher.

However, it wasn't worth the effort
to get sudo to work without a tty session available (watchman runs
without one).

There are other filesystem notification tools out there, and I haven't
tried them but suspect they would have similar challenges.


#### not using a cron

Setting focus time on schedule doesn't fit my lifestyle. I work &
goof-off at different hours each day. Additionally, it would require
special permissions (changes to /etc/sudoers or /etc/sudoers.d)
similar to a file watcher.


#### Overrides

Once I found out that _facebook.com_ makes blocking their DNS entries
very difficult (see [overrides/facebook.com](overrides/facebook.com)
for all the domains needed), I decided to add _overrides_. I suspect
that many other companies (like _google.com_ or _stumbleupon.com_)
that trying desperately to track you will have similarly long lists of
DNS entries that need to be blocked.

I welcome PRs for additional global overrides.


#### Support for DNSCrypt

I recently learned about [DNSCrypt](https://dnscrypt.info/) and have
found it to be an even better tool that `/etc/hosts` for managing DNS.
It offers so much more control, but
[in case you're not convinced - go read this](https://www.opendns.com/about/innovations/dnscrypt/).
However, it doesn't offer command line support for cloaking or
blocking domain names.

Fortunately with a [simple change in config](config.dnscrypt.example),
I was able to adapt CIAO to work with DNSCrypt also.
