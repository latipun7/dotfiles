# Latipun's Dotfiles

[![Discord](https://img.shields.io/discord/340308951826694157?style=flat-square&logo=discord&label=chat+and+discuss)](https://discord.gg/Zw8d3wy "Emperor Ruppy's Kingdom")

This is my personalized dotfiles that I use on my machines. But what is dotfiles?
Simply, dotfiles are configuration files of Unix (and some Windows) programs that are
stored in the user's home directory. These files usually named with leading dot (`.`) hence the names are dotfiles (`.files`).

The interesting part of dotfiles are it can be shared to different machine to have
the same program configurations. Then the project like this are awesome while the
settings are personalized and opinionated, it can be inspiration for other people.
While it can be simply copy paste the dotfiles to different machines, the automation
script will be much more interesting and ease to use with just one or two to three
run scripts and all the configuration files installed. That's what the project like
this trying to achieve.

So, [fork it](https://github.com/latipun7/dotfiles/fork), customize to your personalized
settings, remove what you don't need, add what you need. Or create [new repo](https://github.com/new)
and make this repo and other dotfiles repo as inspirations.

## What in this Repo

This repo contains my personal configuration for Linux and Windows.

- Only support Ubuntu / Debian based Linux Distro with `apt`.
- Support both normal linux or WSL.
- _Windows dotfiles coming soon_.

## Installation

- Clone this repo and run `install.sh` if you are on Linux.

  ```bash
  git clone --recurse-submodules -j 8 https://github.com/latipun7/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh
  ```

  **Tip**: If script won't run after cloning it, see the permission. Make sure it has
  execution permission for user, otherwise run `chmod u+x ~/.dotfiles/install.sh`

- Exit current terminal session: `exit`
- Run `nvm install node` and then `bootstrap`.
- Now this configuration already installed in your machine.

## Resources

Here are list of resources for you to get started dive into this kind of project,
and this list is what actually inspired me to get started with it.

- [Awesome dotfiles][awe-dot] - A curated list of dotfiles resources.
- [Managing your dotfiles][manage] - Article of how to manage dotfiles with [dotbot][dotbot]
- [Anish's dotfiles][anish] - Dotbot author's personal dotfiles
- [Holman's dotfiles][holman] - Nice zsh dotfiles
- [Bash manual][bash] - Bash documentation to write your own scripts

## Information

I'm new with bash/shell scripting, so my script would be lot of dirty and not optimized
for performance. Suggestion and criticism are open.

[MIT License](./LICENSE) © 2020, Latipun7

<!-- Variables -->

[awe-dot]: https://github.com/webpro/awesome-dotfiles#readme "Awesome Dotfiles"
[manage]: https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/ "Managing your dotfiles"
[dotbot]: https://github.com/anishathalye/dotbot "Dotbot - dotfiles management tools"
[anish]: https://github.com/anishathalye/dotfiles "Anish's dotfiles"
[holman]: https://github.com/holman/dotfiles "Holman does dotfiles"
[bash]: https://www.gnu.org/software/bash/manual/bash.html "Bash Manual"
