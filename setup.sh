#!/bin/sh

sudo bash <<EOF
# updating apt
apt update
# PACKAGE INSTALLATION apt
apt install git curl wget snapd dconf-cli zsh tilix gcc g++ g++-12 make cmake python3 python3-pip python3-venv\
 exa clang clangd -y

# enabling snapd
systemctl enable --now snapd

# SNAP INSTALLATION
snap install code --classic
snap install nvim --classic
snap install hugo 
snap install firefox
snap install brave
snap install ruby
snap install alacritty --classic
EOF

# FONTS INSTALLATION
cp -r ./fonts/* /home/$USER/.local/share/fonts/.
sudo fc-cache /home/$USER/.local/share/fonts

# fastfetch INSTALLATION (get the last release from github)
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.2.3/fastfetch-2.2.3-Linux.deb
sudo apt install ./fastfetch-2.2.3-Linux.deb
rm -rf fastfetch-2.2.3-Linux.deb

# ZSH INSTALLATION
# make zsh default
chsh -s $(which zsh)
# install oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" &
# replacing the rc with my custom rc
cp ./zsh/zshrc /home/$USER/.zshrc
# custom plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
source /home/$USER/.zshrc

# TILIX INSTALLATION
# loading custom settings for tilix
dconf load /com/gexperts/Tilix/< ./tilix/tilix.dconf

# NEOVIM INSTALLATION
# installing packer-nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 /home/$USER/.local/share/nvim/site/pack/packer/start/packer.nvim
# loading custom settings for neovim
cp -r nvim /home/$USER/.config/.
# installing plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
