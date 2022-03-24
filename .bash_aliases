
# be strict about errors
set -uo pipefail

# some more aliases
alias ll='ls -lh --group-directories-first'
alias la='ls -Alh --group-directories-first'
alias l='ls -lh --group-directories-first'
alias dc='docker-compose'
#export PATH=$PATH:...

# run keychain on demand
kc() {
	/usr/bin/keychain --nogui /mnt/c/Users/nscheer/.ssh/id_ed25519
	source $HOME/.keychain/$HOSTNAME-sh
}

# run keychain always
#kc

export editor=nano

# custom functions

# creates a branch, switches to it and pushes it to origin (including tracking)
# such that subsequent pushes/pulls work seamlessly
git_branch() {
  git checkout -b $1; 
  git push -u origin $1;
}

# pull with rebase
git_pull() {
  git pull --rebase --all
}


# git aliases (direct)
alias gs='git status'
alias gss='git status -s'
alias gsw='git switch'
alias gm='git merge --ff'
alias g='git checkout'
alias gpu='git_pull'

# git aliases (frequently used command flows)
alias gb='git_branch'


# current git branch in prompt.
parse_git_branch() {
   git branch --show-current 2>/dev/null
}

# simple git prompt
export PS1="\$(date +%T)\[\033[32m\] \$(parse_git_branch)\[\033[00m\] \w\n$ "

# configure x11
export GDK_SCALE=1
#export LIBGL_ALWAYS_INDIRECT=1
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

# run docker
DOCKER_PID=$(pidof dockerd)

if [ "$DOCKER_PID" == "" ]; then
	echo "- starting docker"
	sudo daemonize -v -a -e /var/log/docker.stderr.log -o /var/log/docker.stdout.log -l /var/lock/docker.lock /usr/bin/dockerd
else
	echo "- docker is running"
fi

# add local scripts to path
export PATH=$PATH:~/bin

# some space...
echo

# start @ home
cd ~
