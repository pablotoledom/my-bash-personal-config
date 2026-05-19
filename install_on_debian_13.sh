#!/bin/bash
# *************************************************************** #
#                           WELCOME                               #
#                                                                 #
#  Tested on:                                                     #
#   - Ubuntu 22                                                   #
#                                                                 #
# *************************************************************** #
source ./show/welcome

# Get user in session and say hello
user="$(whoami)" 
echo "Hi ${user}!!"

# *************************************************************** #
#                       1- Copy fonts                             #
# *************************************************************** #
source ./show/divbar
echo '1- Copying Nerd Fonts...'
source ./show/divbar
sleep .5

# 1.1 Create fonst type directories
sudo mkdir -p /usr/share/fonts/TTF
sudo mkdir -p /usr/share/fonts/OTF

# 1.2 Copy all fonts
sudo cp -r ./fonts/hack/*.ttf /usr/share/fonts/TTF
sudo cp -r ./fonts/meslolgs/*.ttf /usr/share/fonts/TTF
sudo cp -r ./fonts/powerline/*.ttf /usr/share/fonts/TTF
sudo cp -r ./fonts/powerline/*.otf /usr/share/fonts/OTF
sudo cp -r ./fonts/jetbrains/*.ttf /usr/share/fonts/TTF

fc-cache -fv

# *************************************************************** #
#                  2- Install terminal tools                      #
# *************************************************************** #
echo '2- Installing terminal tools...'
source ./show/divbar
sleep .5

# 2.1 Install software with apt
sudo apt -y install locate
sudo apt -y install p7zip-full
sudo apt -y install zsh
sudo apt -y install tmux
sudo apt -y install neovim
sudo apt -y install curl
sudo apt -y install wget
sudo apt -y install git
sudo apt -y install bat
sudo apt -y install lsd
sudo apt -y install bash-completion
sudo apt -y install gawk

# 2.2 Install autocompletation tool
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
rm -R -f ble.sh

# *************************************************************** #
#                  3- Install OH MY BASH                          #
# *************************************************************** #
source ./show/divbar
echo '3- Installing OH MY BASH...'
sleep .5

bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"

# *************************************************************** #
#                  4- Install RUNCOM files                        #
# *************************************************************** #
source ./show/divbar
echo '4- Installing RUNCOM files...'
sleep .5

# 4.1 Create backup RUNCOM files
mv -f ~/.zshrc ~/.zshrc.back
mv -f ~/.vimrc ~/.vimrc.back
mv -f ~/.bashrc ~/./.bashrc.back

# # 4.2 Copy custom Bash RUNCOM to user directory
cp -r ./copy_to_user_folder/.bashrc_debian ~/

# # 4.2 Copy other user config files to user directory
cp -r ./copy_to_user_folder/.vimrc ~/

# *************************************************************** #
#               5- Copy neovim configuration                      #
# *************************************************************** #
source ./show/divbar
echo '5- Installing VIM plugins...'
source ./show/divbar
sleep .5

# 5.1 Create .vim directories
mkdir -p  ~/.vim/plugged

# 5.2 Copy plugins list
cp -r ./copy_to_user_folder/.vim/plugins.vim ~/.vim/plugins.vim

# 5.3 Copy configuration init file
mkdir -p ~/.config/nvim
cp -r ./copy_to_user_folder/.config/nvim/init.vim ~/.config/nvim/init.vim

# 5.4 Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 5.5 Copy nvim plugins
cd ./copy_to_user_folder/.vim/
tar -zxvf plugged.tar.gz
cp -r plugged/* ~/.vim/plugged
rm -R -f plugged
cd ../..