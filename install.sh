#!/bin/sh

# mount dotfiles at $HOME/dotfiles
ln -s /workspaces/.codespaces/.persistedshare/dotfiles $HOME/dotfiles

# source the my_zshrc from dotfiles
echo "" >> $HOME/.zshrc
echo "source $HOME/dotfiles/my_zshrc" >> $HOME/.zshrc

# make the dir if it doesn't exist
mkdir -p $HOME/.local/bin

# configure git (change user.*)
sudo git config --system user.name A2Y-D5L
sudo git config --system user.email 00.disk-turbo@icloud.com
git config --global core.whitespace blank-at-eol,blank-at-eof,space-before-tab
git config --global pull.rebase false
git config --global init.defaultbranch main
git config --global core.pager more
git config --global fetch.prune true

# delete merged local branches
git config --global alias.gone "! git checkout main && git fetch -pa && git pull &&  git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '\$2 == \"[gone]\" {print \$1}' | xargs -r git branch -D"

# Codespaces sets the env vars for you
# I override these values in my_zshrc with a "full PAT" if it exists
# GITHUB_PAT only works in the Codespace repo by default
# sudo git config --system credential.helper '!f() { sleep 1; echo "username=${GIT_COMMITTER_NAME}"; echo "password=${GITHUB_TOKEN}"; }; f'

# this is a cool feature that lets you use "git clone b://dotfiles"
# instead of "git clone https://github.com/A2Y-D5L/dotfiles"
git config --global url.https://github.com/A2Y-D5L/.insteadOf b://
git config --global url.https://github.com/cse-labs/.insteadOf c://
git config --global url.https://github.com/.insteadOf g://
git config --global url.https://github.com/k8s-labs/.insteadOf k://
git config --global url.https://github.com/retaildevcrews/.insteadOf r://

# login to GitHub container registry if $PAT set
if [[ -n $PAT ]]; then
  docker login ghcr.io -u A2Y-D5L -p $PAT
fi
