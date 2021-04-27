#!/usr/bin/env bash

# shellcheck source=_functions.sh
source "$DOTFILES/linux/bin/lib/_functions.sh"

# Installing standard apps thru Ubuntu APT repository
step "Install Apps via APT Repository"
packages=(
  "curl" "gcc" "git" "python3" "neovim" "zsh" "jq" "mc" "ncdu" "libcurses-perl"
  "cmatrix" "cowsay" "fortune" "lolcat" "neofetch" "sl" "coreutils" "gzip"
  "apt-transport-https" "ca-certificates" "gnupg" "lsb-release" "texinfo"
)
sudo apt install "${packages[@]}" -y

###############################################################################
# Install nginx
# https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-a-prebuilt-ubuntu-package-from-the-official-nginx-repository
if [ ! -f /etc/apt/sources.list.d/nginx.list ]; then
  step "Install nginx"

  echo "deb https://nginx.org/packages/mainline/ubuntu/ $(lsb_release -cs) nginx" |
    sudo tee /etc/apt/sources.list.d/nginx.list &>/dev/null
  echo "deb-src https://nginx.org/packages/mainline/ubuntu/ $(lsb_release -cs) nginx" |
    sudo tee -a /etc/apt/sources.list.d/nginx.list &>/dev/null
  curl -fsLS https://nginx.org/keys/nginx_signing.key | sudo apt-key add -

  sudo apt update
  sudo apt install nginx -y
fi

##############################################################################
# Install docker
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
  step "Install docker"

  curl -fsLS https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |
    sudo tee /etc/apt/sources.list.d/docker.list &>/dev/null

  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io -y

  # https://docs.docker.com/engine/install/linux-postinstall/#configuring-remote-access-with-systemd-unit-file
  sudo mkdir -p /etc/systemd/system/docker.service.d
  echo -e '[Service]\nExecStart=\nExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375' |
    sudo tee -a /etc/systemd/system/docker.service.d/override.conf &>/dev/null
  sudo systemctl daemon-reload
  sudo systemctl restart docker.service
fi

###############################################################################
# Install postgres
# https://www.postgresql.org/download/linux/ubuntu/
if [ ! -f /etc/apt/sources.list.d/pgdg.list ]; then
  step "Install postgres"
  echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" |
    sudo tee /etc/apt/sources.list.d/pgdg.list &>/dev/null
  curl -fsLS https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

  sudo apt update
  sudo apt install postgresql -y
fi

###############################################################################
# Install/Upgrade fnm
# https://github.com/Schniz/fnm#using-a-script-macoslinux
step "Install/Upgrade FNM"
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

###############################################################################
# Install/Upgrade Ponysay
# https://github.com/erkin/ponysay/#installation-on-gnulinux-or-other-unix-implementations
step "Install/Upgrade Ponysay"
if [ ! -d "$HOME/.ponysay" ]; then
  git clone -q --depth 1 https://github.com/erkin/ponysay.git "$HOME/.ponysay"
else
  git -C "$HOME/.ponysay" pull -q --depth 1
fi
cd "$HOME/.ponysay" || return
sudo ./setup.py \
  --freedom=partial \
  --with-custom-env-python="$(command -v python3)" \
  install

###############################################################################
# Install/Upgrade FZF
# https://github.com/junegunn/fzf#installation
step "Install/Upgrade fzf"
if [ ! -d "$HOME/.fzf" ]; then
  git clone -q --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
else
  git -C "$HOME/.fzf" pull -q --depth 1
fi
"$HOME/.fzf/install"

###############################################################################
# Install/Upgrade bpytop
# https://github.com/aristocratos/bpytop#installation
step "Install/Upgrade bpytop"
pip3 install bpytop --upgrade

###############################################################################
# Install/Upgrade bat
# https://github.com/sharkdp/bat/releases
step "Install/Upgrade bat"
curl -fsLS https://github.com/sharkdp/bat/releases/download/v0.18.0/bat_0.18.0_arm64.deb | sudo dpkg -i

###############################################################################
# Install/Upgrade bat
# https://github.com/sharkdp/bat/releases
step "Install/Upgrade bat"
curl -fsLS https://github.com/sharkdp/bat/releases/download/v0.18.0/bat_0.18.0_arm64.deb | sudo dpkg -i

###############################################################################
# Install/Upgrade asciiquarium
# https://askubuntu.com/a/927442
step "Install/Upgrade asciiquarium"
if ! hash asciiquarium 2>/dev/null; then
  sudo env PERL_MM_USE_DEFAULT=1 cpan -I Term::Animation
fi

curl -fsLS https://robobunny.com/projects/asciiquarium/asciiquarium_1.1.tar.gz | tar -zx -C /tmp
sudo cp /tmp/asciiquarium_1.1/asciiquarium /usr/local/bin/
sudo chmod +x /usr/local/bin/asciiquarium

###############################################################################
# Install this for server non Raspi
if [[ "$(uname -a)" != *raspi* ]]; then
  # TODO: Setup certbot
  step "Install certbot (coming soon)"
fi
