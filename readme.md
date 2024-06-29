# `Latipun's Dotfiles 🏡`

[![Discord][discord-image]][discord-url]

> **☕ Home sweet home 🏡**
>
> Automate bootstrap my personalized system configurations on home directory.
> Used as source of inspirations to customize (ricing) your machine 🍙.

## Screenshots

![welcome screen](https://user-images.githubusercontent.com/20012970/191744493-87f1bfee-5758-4919-ab37-ff1338e904c3.gif)

_**more at [screenshot history 📸](https://github.com/latipun7/dotfiles/discussions/10)**_

## What in this Repo

This repo contains my personal configuration for Linux, Android, and Windows
managed by amazing [chezmoi](https://chezmoi.io).

Currently this is designed for my **Arch Linux** as server, Arch Linux for my
daily driver desktop, **Android** via Termux, and **Windows**.
_I don't have MacOS yet, but I'm considering that too in this dotfiles._

**Important ⚠:** You need [nerd fonts][nerd-fonts] in your system.
Install the font of your choosing and use that font as monospace font.
Personally, I use `Cascadia Code` + `Symbols Nerd Font`.

Here's the list of what included in this dotfiles:

- [`Hyprland`](https://hyprland.org/) - Beautiful tiling Wayland compositor.
- [`LazyVim`](https://www.lazyvim.org) - NeoVim as an IDE.
- [`WezTerm`](https://wezfurlong.org/wezterm/) - Cross-platform terminal emulator.
- [`Yazi`](https://yazi-rs.github.io/) - Blazing fast terminal file manager.
- [`tmux`](https://github.com/tmux/tmux) - Terminal multiplexer _(no Windows)_.
- [`zsh`](https://zsh.sourceforge.io/) - Interactive unix-like shell _(no Windows)_.
- [`lf`](https://github.com/gokcehan/lf) - Cross-platform terminal file manager.
- And [many more](./home).

## Installation

Simply run:

```bash
bash -c "$(curl -fsLS https://s.id/install-dotfiles)"
```

For _**Windows, TBA**_.

## Resources

Here are list of resources for you to get started dive into this kind of project,
and this list is what actually inspired me to get started with it.

- [Awesome dotfiles][awe-dot] - A curated list of dotfiles resources.
- [Bash manual][bash] - Bash documentation to write your own scripts.

## Hacking to the Gate~! 🧑‍💻🎶

[MIT License](./license) © Latif Sulistyo

<!-- Variables -->

[discord-image]: https://img.shields.io/discord/758271814153011201?label=Developers%20Indonesia&logo=discord&style=flat-square
[discord-url]: https://discord.gg/njSj2Nq "Chat and discuss at Developers Indonesia"
[awe-dot]: https://github.com/webpro/awesome-dotfiles#readme "Awesome Dotfiles"
[bash]: https://www.gnu.org/software/bash/manual/bash.html "Bash Manual"
[nerd-fonts]: https://www.nerdfonts.com/ "NerdFonts"
