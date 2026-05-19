#!/bin/bash
# *************************************************************** #
#                           WELCOME                               #
#                                                                 #
#  Tested on:                                                     #
#   - macOS 14+ (Sonoma) — Apple Silicon & Intel                 #
#                                                                 #
#  Requirements:                                                  #
#   - No admin privileges required                               #
#   - No internet / GitHub access needed                         #
#   - Bundled files in ./thirdparty/macos/ are required          #
# *************************************************************** #
source ./show/welcome

user="$(whoami)"
echo "Hi ${user}!!"

# Detect architecture (use sysctl to get real hardware, ignoring Rosetta)
ARCH="$(sysctl -n hw.machine 2>/dev/null || uname -m)"
if [ "$ARCH" = "arm64" ]; then
    NVIM_TARBALL="nvim-macos-arm64.tar.gz"
    NVIM_DIR="nvim-macos-arm64"
    BAT_TARBALL="bat-aarch64-apple-darwin.tar.gz"
    BAT_DIR="bat-v0.26.1-aarch64-apple-darwin"
    LSD_TARBALL="lsd-aarch64-apple-darwin.tar.gz"
    LSD_DIR="lsd-v1.2.0-aarch64-apple-darwin"
    BASH5_BIN="bash-5.2.37-arm64"
    TMUX_TARBALL="tmux-3.6a-macos-arm64.tar.gz"
else
    NVIM_TARBALL="nvim-macos-x86_64.tar.gz"
    NVIM_DIR="nvim-macos-x86_64"
    BAT_TARBALL="bat-x86_64-apple-darwin.tar.gz"
    BAT_DIR="bat-v0.26.1-x86_64-apple-darwin"
    LSD_TARBALL="lsd-x86_64-apple-darwin.tar.gz"
    LSD_DIR="lsd-v1.2.0-x86_64-apple-darwin"
    BASH5_BIN="bash-5.2.37-x86_64"
    TMUX_TARBALL="tmux-3.6a-macos-x86_64.tar.gz"
fi

THIRDPARTY="./thirdparty/macos"

# *************************************************************** #
#                  0- Create local bin directory                  #
# *************************************************************** #
source ./show/divbar
echo '0- Setting up ~/.local/bin ...'
source ./show/divbar
sleep .5

mkdir -p ~/.local/bin
mkdir -p ~/.local/share

# Add ~/.local/bin to PATH if not already present
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# *************************************************************** #
#                       1- Copy fonts                             #
# *************************************************************** #
source ./show/divbar
echo '1- Copying Nerd Fonts...'
source ./show/divbar
sleep .5

# On macOS user fonts go in ~/Library/Fonts (no sudo required)
mkdir -p ~/Library/Fonts
cp -r ./fonts/hack/*.ttf ~/Library/Fonts/
cp -r ./fonts/meslolgs/*.ttf ~/Library/Fonts/
cp -r ./fonts/powerline/*.ttf ~/Library/Fonts/
cp -r ./fonts/powerline/*.otf ~/Library/Fonts/
cp -r ./fonts/jetbrains/*.ttf ~/Library/Fonts/

echo "Fonts installed in ~/Library/Fonts"

# *************************************************************** #
#              2- Install terminal tools                          #
# *************************************************************** #
source ./show/divbar
echo '2- Installing terminal tools from thirdparty...'
source ./show/divbar
sleep .5

TMPDIR_TOOLS="$(mktemp -d)"

# 2.1 Install Neovim
echo "  -> Installing neovim ($ARCH)..."
tar -xzf "$THIRDPARTY/$NVIM_TARBALL" -C "$TMPDIR_TOOLS"
mkdir -p ~/.local/nvim
cp -r "$TMPDIR_TOOLS/$NVIM_DIR/"* ~/.local/nvim/
ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/nvim

# 2.2 Install bat
echo "  -> Installing bat ($ARCH)..."
tar -xzf "$THIRDPARTY/$BAT_TARBALL" -C "$TMPDIR_TOOLS"
cp "$TMPDIR_TOOLS/$BAT_DIR/bat" ~/.local/bin/bat
chmod +x ~/.local/bin/bat

# 2.3 Install lsd
echo "  -> Installing lsd ($ARCH)..."
tar -xzf "$THIRDPARTY/$LSD_TARBALL" -C "$TMPDIR_TOOLS"
cp "$TMPDIR_TOOLS/$LSD_DIR/lsd" ~/.local/bin/lsd
chmod +x ~/.local/bin/lsd

# 2.5 Install tmux
echo "  -> Installing tmux ($ARCH)..."
tar -xzf "$THIRDPARTY/$TMUX_TARBALL" -C "$TMPDIR_TOOLS"
cp "$TMPDIR_TOOLS/tmux" ~/.local/bin/tmux
chmod +x ~/.local/bin/tmux

rm -rf "$TMPDIR_TOOLS"

# Remove macOS quarantine flag so binaries can run without admin approval
xattr -d com.apple.quarantine ~/.local/bin/bat 2>/dev/null || true
xattr -d com.apple.quarantine ~/.local/bin/lsd 2>/dev/null || true
xattr -d com.apple.quarantine ~/.local/bin/tmux 2>/dev/null || true
xattr -d com.apple.nvim/bin/nvim 2>/dev/null || true
find ~/.local/nvim -name "nvim" -exec xattr -d com.apple.quarantine {} \; 2>/dev/null || true

echo "  -> neovim, bat, lsd and tmux installed in ~/.local/bin"

# 2.4 Install Bash 5 (required for ble.sh performance)
echo "  -> Installing Bash 5 ($ARCH)..."
if [ -f "$THIRDPARTY/$BASH5_BIN" ]; then
    cp "$THIRDPARTY/$BASH5_BIN" ~/.local/bin/bash
    chmod +x ~/.local/bin/bash
    xattr -d com.apple.quarantine ~/.local/bin/bash 2>/dev/null || true
    echo "  -> Bash 5 installed in ~/.local/bin/bash"
else
    echo "  -> WARNING: $BASH5_BIN not found, ble.sh may be slow with system Bash 3.2"
fi

# 2.5 Install ble.sh (advanced bash autocompletion)
echo "  -> Installing ble.sh..."
TMPDIR_BLE="$(mktemp -d)"
tar -xJf "$THIRDPARTY/ble.sh.tar.xz" -C "$TMPDIR_BLE"
BLE_SRC="$(ls -d "$TMPDIR_BLE"/ble-*/)"
"$BLE_SRC/ble.sh" --install PREFIX=~/.local
rm -rf "$TMPDIR_BLE"

# *************************************************************** #
#                  3- Install OH MY BASH (offline)                #
# *************************************************************** #
source ./show/divbar
echo '3- Installing OH MY BASH (offline)...'
source ./show/divbar
sleep .5

TMPDIR_OMB="$(mktemp -d)"
tar -xzf "$THIRDPARTY/oh-my-bash.tar.gz" -C "$TMPDIR_OMB"

# Remove previous installation if it exists
rm -rf ~/.oh-my-bash

# Move extracted directory to ~/.oh-my-bash
mv "$TMPDIR_OMB/oh-my-bash-master" ~/.oh-my-bash
rm -rf "$TMPDIR_OMB"

echo "Oh My Bash installed in ~/.oh-my-bash"

# *************************************************************** #
#                  4- Install RUNCOM files                        #
# *************************************************************** #
source ./show/divbar
echo '4- Installing RUNCOM files...'
source ./show/divbar
sleep .5

# 4.1 Create backups
[ -f ~/.zshrc ]   && mv -f ~/.zshrc ~/.zshrc.back
[ -f ~/.vimrc ]   && mv -f ~/.vimrc ~/.vimrc.back
[ -f ~/.bashrc ]  && mv -f ~/.bashrc ~/.bashrc.back
[ -f ~/.bash_profile ] && mv -f ~/.bash_profile ~/.bash_profile.back

# 4.2 Copy configuration files
cp -r ./copy_to_user_folder/.bashrc_macos ~/.bashrc

# 4.3 Add ~/.local/bin to PATH in .bashrc if not already present
if ! grep -q '\.local/bin' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# 4.4 Copy vimrc
cp -r ./copy_to_user_folder/.vimrc ~/

# 4.5 Create .bash_profile to load .bashrc and use Bash 5
cat > ~/.bash_profile << 'EOF'
export BASH_SILENCE_DEPRECATION_WARNING=1

# Usar Bash 5 si estamos en Bash 3.x del sistema
if [[ $BASH_VERSION == 3.* ]] && [[ -x ~/.local/bin/bash ]]; then
    exec ~/.local/bin/bash --login
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
EOF

# *************************************************************** #
#               5- Configure Neovim and vim-plug                  #
# *************************************************************** #
source ./show/divbar
echo '5- Configuring Neovim and plugins...'
source ./show/divbar
sleep .5

# 5.1 Create .vim directories
mkdir -p ~/.vim/plugged
mkdir -p ~/.vim/autoload

# 5.2 Copy plugins list
cp -r ./copy_to_user_folder/.vim/plugins.vim ~/.vim/plugins.vim

# 5.3 Copy nvim init config
mkdir -p ~/.config/nvim
cp -r ./copy_to_user_folder/.config/nvim/init.vim ~/.config/nvim/init.vim

# 5.4 Install vim-plug from thirdparty (no internet required)
cp "$THIRDPARTY/plug.vim" ~/.vim/autoload/plug.vim

# 5.5 Copy pre-bundled plugins
cd ./copy_to_user_folder/.vim/
tar -zxvf plugged.tar.gz
cp -r plugged/* ~/.vim/plugged
rm -rf plugged
cd ../..

# *************************************************************** #
#                         6- Done                                 #
# *************************************************************** #
source ./show/divbar
echo '6- Installation complete!'
source ./show/divbar

echo ""
echo "Tools installed in ~/.local/bin:"
ls -1 ~/.local/bin/ 2>/dev/null
echo ""
echo "Fonts installed in ~/Library/Fonts"
echo ""
echo "IMPORTANT: Restart your terminal or run:"
echo "  source ~/.bashrc"
echo ""
echo "If macOS blocks a binary with 'cannot be opened', run:"
echo "  xattr -d com.apple.quarantine ~/.local/bin/<name>"
echo "  or go to System Settings > Privacy & Security"
