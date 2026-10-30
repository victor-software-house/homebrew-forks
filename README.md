# homebrew-forks

Personal Homebrew tap for patched/forked formulae and casks.

## Usage

```bash
brew tap victor-software-house/forks
```

## Formulae

| Formula | Description | Upstream |
|:--------|:------------|:---------|
| `tmux` | tmux with kitty keyboard protocol support | [jixiuf/tmux](https://github.com/jixiuf/tmux) |

## Casks

| Cask | Description | Upstream |
|:-----|:------------|:---------|
| `herdr-vsh` | [Herdr VSH](https://github.com/victor-software-house/herdr-app), the Herdr desktop app with Ghostty-like terminal rendering | [herdrdev/herdr-app](https://github.com/herdrdev/herdr-app) |

`.github/workflows/update-herdr-vsh.yml` moves the cask to each new release every six hours.

## Install

```bash
brew install victor-software-house/forks/tmux
brew install --cask victor-software-house/forks/herdr-vsh
```
