# Environment User Configs

> [Versión en Español](LEAME.md)

Personal terminal environment setup: shell, editor, fonts and tools, deployable on Debian and macOS.

![alt Terminal colors](https://raw.githubusercontent.com/pablotoledom/my-bash-personal-config/main/images/screenshot.png)

## What it installs

- **Oh My Bash** with the Powerline theme
- **Nerd Fonts** (Hack, MesloLGS, JetBrains Mono, Powerline collection)
- **Neovim** with vim-plug and a pre-configured plugin set
- **lsd** — modern `ls` replacement with icons
- **bat** — `cat` with syntax highlighting
- **tmux** — terminal multiplexer
- **Bash 5** — replaces macOS system Bash 3.2
- **ble.sh** — advanced Bash line editor with autocompletion

## Shell prompt features

The custom `.bashrc` configures the Powerline prompt with:

- OS icon (Apple, Debian, Arch, Fedora, etc.)
- Git branch and state with color coding:
  - Green — clean
  - Bright green — staged changes
  - Orange — unstaged changes
  - Yellow — untracked files
  - Red — merge/rebase conflict
- Repository icon (GitHub / Bitbucket / generic Git)
- Phosphor green color scheme

## Scripts

### `install_on_debian_13.sh`

Installs the environment on Debian 13 (also tested on Ubuntu 22).

- Installs packages via `apt`: neovim, bat, lsd, tmux, bash-completion, curl, git, etc.
- Installs ble.sh by cloning from GitHub and building
- Installs Oh My Bash from GitHub
- Copies `copy_to_user_folder/.bashrc_debian` as `~/.bashrc`

**Requirements:** internet access, `sudo` privileges.

---

### `install_on_macos.sh`

Installs the environment on macOS 14+ (Apple Silicon and Intel) using Homebrew.

- Installs Homebrew if not already present
- Installs tools via `brew`: neovim, bat, lsd, bash, tmux
- Installs ble.sh by cloning from GitHub and building
- Installs Oh My Bash from GitHub
- Installs vim-plug from GitHub
- Copies `copy_to_user_folder/.bashrc_macos` as `~/.bashrc`
- Creates `~/.bash_profile` to use Bash 5 from Homebrew on login

**Requirements:** internet access.

---

### `install_on_macos_briked.sh`

Installs the environment on macOS 14+ (Apple Silicon and Intel) **without internet access**. All dependencies are bundled in `./thirdparty/macos/`.

- Installs pre-built binaries from `./thirdparty/macos/`: neovim, bat, lsd, tmux, bash 5
- Installs ble.sh from a local `.tar.xz` bundle
- Installs Oh My Bash from a local `.tar.gz` bundle
- Installs vim-plug from the local `plug.vim` file
- Installs pre-bundled Neovim plugins from `plugged.tar.gz`
- Copies `copy_to_user_folder/.bashrc_macos` as `~/.bashrc`
- Creates `~/.bash_profile` to use Bash 5 on login

**Requirements:** no internet needed. Bundled binaries support both `arm64` and `x86_64`.

---

## Project structure

```
.
├── install_on_debian_13.sh       # Debian/Ubuntu installer (online)
├── install_on_macos.sh           # macOS installer via Homebrew (online)
├── install_on_macos_briked.sh    # macOS installer offline (bundled)
├── copy_to_user_folder/
│   ├── .bashrc_debian            # Shell config for Debian/Ubuntu
│   ├── .bashrc_macos             # Shell config for macOS
│   ├── .vimrc                    # Vim config
│   ├── .vim/
│   │   ├── plugins.vim           # vim-plug plugin list
│   │   └── plugged.tar.gz        # Pre-bundled plugins (offline use)
│   └── .config/nvim/
│       └── init.vim              # Neovim init config
├── fonts/
│   ├── hack/                     # Hack Nerd Font
│   ├── meslolgs/                 # MesloLGS NF
│   ├── jetbrains/                # JetBrains Mono Nerd Font
│   └── powerline/                # Powerline font collection
├── thirdparty/macos/             # Offline bundles for macOS
└── show/
    ├── welcome                   # Welcome banner
    └── divbar                    # Section divider
```

## Author

**Jonathan Pablo Toledo M.**  
[TheRetroCenter.com](https://www.theretrocenter.com)
