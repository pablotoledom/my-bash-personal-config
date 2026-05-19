#!/bin/bash
# *************************************************************** #
#                           WELCOME                               #
#                                                                 #
#  Tested on:                                                     #
#   - macOS 14+ (Sonoma) — Apple Silicon & Intel                 #
#                                                                 #
#  Requirements:                                                  #
#   - Internet access required                                    #
#   - Homebrew will be installed automatically if not present     #
# *************************************************************** #
source ./show/welcome

user="$(whoami)"
echo "Hi ${user}!!"

# *************************************************************** #
#                  0- Install Homebrew                            #
# *************************************************************** #
source ./show/divbar
echo '0- Checking Homebrew...'
source ./show/divbar
sleep .5

if ! command -v brew &>/dev/null; then
    echo "  -> Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to PATH for this session
    if [ -d "/opt/homebrew/bin" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "  -> Homebrew already installed: $(brew --version | head -1)"
fi

mkdir -p ~/.local/bin ~/.local/share

# *************************************************************** #
#                       1- Copy fonts                             #
# *************************************************************** #
source ./show/divbar
echo '1- Copying Nerd Fonts...'
source ./show/divbar
sleep .5

mkdir -p ~/Library/Fonts
cp -r ./fonts/hack/*.ttf ~/Library/Fonts/
cp -r ./fonts/meslolgs/*.ttf ~/Library/Fonts/
cp -r ./fonts/powerline/*.ttf ~/Library/Fonts/
cp -r ./fonts/powerline/*.otf ~/Library/Fonts/
cp -r ./fonts/jetbrains/*.ttf ~/Library/Fonts/

echo "Fonts installed in ~/Library/Fonts"

# *************************************************************** #
#              2- Install terminal tools via Homebrew             #
# *************************************************************** #
source ./show/divbar
echo '2- Installing terminal tools via Homebrew...'
source ./show/divbar
sleep .5

brew install neovim
brew install bat
brew install lsd
brew install bash
brew install tmux

# 2.1 Install ble.sh (advanced bash autocompletion)
echo "  -> Installing ble.sh..."
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
make -C /tmp/ble.sh install PREFIX=~/.local
rm -rf /tmp/ble.sh

echo "  -> neovim, bat, lsd, bash and ble.sh installed"

# *************************************************************** #
#                  3- Install OH MY BASH                          #
# *************************************************************** #
source ./show/divbar
echo '3- Installing OH MY BASH...'
source ./show/divbar
sleep .5

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" "" --unattended

echo "Oh My Bash installed in ~/.oh-my-bash"

# *************************************************************** #
#                  4- Install RUNCOM files                        #
# *************************************************************** #
source ./show/divbar
echo '4- Installing RUNCOM files...'
source ./show/divbar
sleep .5

# 4.1 Create backups
[ -f ~/.zshrc ]        && mv -f ~/.zshrc ~/.zshrc.back
[ -f ~/.vimrc ]        && mv -f ~/.vimrc ~/.vimrc.back
[ -f ~/.bashrc ]       && mv -f ~/.bashrc ~/.bashrc.back
[ -f ~/.bash_profile ] && mv -f ~/.bash_profile ~/.bash_profile.back

# 4.2 Copy custom bashrc
cp -r ./copy_to_user_folder/.bashrc_macos ~/.bashrc

# 4.3 Add ~/.local/bin to PATH in .bashrc if not already present
if ! grep -q '\.local/bin' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# 4.4 Copy vimrc
cp -r ./copy_to_user_folder/.vimrc ~/

# 4.5 Create .bash_profile to load .bashrc and use Bash 5 from Homebrew
BREW_BASH="$(brew --prefix)/bin/bash"
cat > ~/.bash_profile << EOF
export BASH_SILENCE_DEPRECATION_WARNING=1

# Use Bash 5 from Homebrew if running macOS system Bash 3.x
if [[ \$BASH_VERSION == 3.* ]] && [[ -x "${BREW_BASH}" ]]; then
    exec "${BREW_BASH}" --login
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

# 5.4 Install vim-plug from internet
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 5.5 Install plugins headlessly
nvim --headless +PlugInstall +qall 2>/dev/null || true

# *************************************************************** #
#                         6- Done                                 #
# *************************************************************** #
source ./show/divbar
echo '6- Installation complete!'
source ./show/divbar

echo ""
echo "Installed via Homebrew: neovim, bat, lsd, bash"
echo "Fonts installed in ~/Library/Fonts"
echo ""
echo "IMPORTANT: Restart your terminal or run:"
echo "  source ~/.bashrc"
