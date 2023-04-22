<p align="center">
  <a href="#gh-dark-mode-only" target="_blank" rel="noopener noreferrer">
    <img src=".github/assets/night.svg" alt="git-extra-profiles.plugin.zsh">
  </a>

  <a href="#gh-light-mode-only" target="_blank" rel="noopener noreferrer">
    <img src=".github/assets/day.svg" alt="git-extra-profiles.plugin.zsh">
  </a>
</p>

Plugin for managing multiple `git` profiles.

![](.github/assets/preview.gif)

## Installation

### Using [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

```sh
git clone https://github.com/baliestri/git-profiles.plugin.zsh.git $ZSH_CUSTOM/plugins/git-profiles
```

Then add `git-profiles` to the plugins array in your zshrc file:

```sh
plugins=(... git-profiles)
```

### Using [zplug](https://github.com/zplug/zplug)

```sh
zplug "baliestri/git-profiles.plugin.zsh"
```

### Using [zinit](https://github.com/zdharma-continuum/zinit)

```sh
zinit light baliestri/git-profiles.plugin.zsh
```

### Using [zgenom](https://github.com/jandamm/zgenom)

```sh
zgenom load baliestri/git-profiles.plugin.zsh
```

### Using [zi](https://github.com/z-shell/zi)

```sh
zi light baliestri/git-profiles.plugin.zsh
```

## Usage

### Define where your profiles are stored

```sh
# ~/.zshrc

export GIT_PROFILES_FILE="$HOME/.config/git/profiles" # Fallback to $HOME/.git-profiles
```

### Add a new profile

```sh
# ~/.config/git/profiles

[profile "default"]
  name = Bruno Sales
  email = me@baliestri.dev
  # signingkey = 1234567890

[profile "work"]
  name = Bruno Sales
  email = work@baliestri.dev
  # signingkey = 1234567890
  path = "/home/baliestri/work"
```
