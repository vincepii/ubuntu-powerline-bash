#! /bin/bash

function add_line() {
  LINE="$1"
  FILE=$2
  grep -F -q "${LINE}" ${FILE} || (echo -e '\n# Powerline shell changes' >> ${FILE} && echo ${LINE} >> ${FILE})
}

sudo apt-get install python-pip git jq

pip install setuptools
pip install --user git+git://github.com/powerline/powerline

LINE='if [ -d "$HOME/.local/bin" ] ; then PATH="$HOME/.local/bin:$PATH"; fi'
add_line "${LINE}" ~/.profile

wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts
mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

LINE='if [ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh; fi'
add_line "${LINE}" ~/.bashrc

# Use the "default_leftonly" theme
CFG_FILE=~/.local/lib/python2.7/site-packages/powerline/config_files/config.json
jq '(.ext.shell.theme = "default_leftonly")' "${CFG_FILE}" > tmp.$$.json && mv tmp.$$.json ${CFG_FILE}
