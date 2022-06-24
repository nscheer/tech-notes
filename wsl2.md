# wsl2 setup

## important files/folders

You may want to backup these first from your old setup :)

* ~/.bash_aliases
* ~/.gitconfig
* ~/.gitignore
* ~/.ssh
* ~/.nanorc



## WSL commands (on Windows)

```bash
# list all distros
wsl -l -v

# stop distro
wsl -t dev01

# shutdown wsl (will restart automatically when starting a distro)
wsl --shutdown

# unregister distro
# WARNING: Deletes the vhdx without previous confirmation!
wsl --unregister dev01
```



## Basic installation

```bash
# note: AppxBundle needs unpacking to x64 appx first
# get appx file from
# https://docs.microsoft.com/en-us/windows/wsl/install-manual

# open with e.g. 7-zip and extract appx, and from there the root tar (e.g. install.tar.gz) to e.g. c:\wsl\dev01

# get launcher from https://github.com/yuk7/wsldl and place beside root tar named as dev01.exe

# run launcher dev01.exe to register distribution (name of exe will be name of distro)

# installation will start and create ext4.vhdx, delete install.tar.gz afterwards

# run distro by running dev01.exe

# create /etc/wsl.conf and restart wsl
[automount]
enabled = true
root = /mnt/
options = "metadata,umask=002,fmask=011"
mountFsTab = false

# add user
sudo adduser nscheer

# add user to sudo group
sudo gpasswd -a nscheer sudo

# switch sudo group to nopasswd (add "NOPASSWD:")
export EDITOR=nano
visudo
# %sudo   ALL=(ALL:ALL) NOPASSWD: ALL

# set startup user id for distro
dev01.exe config --default-user nscheer

# basic stuff 
sudo apt install keychain htop git procps wget curl unzip mlocate
```

## ssh-config xdebug

add to ***.ssh/config***:

```bash
Host dev
    Hostname my-dev-host
    User nscheer
    ForwardAgent yes
    # tunnel for php debugging
    RemoteForward 9003 localhost:9003
```

## Keychain

add to ***.bash_aliases***:

```bash
# run keychain on demand
kc() {
    /usr/bin/keychain --nogui /mnt/c/Users/nicolai/.ssh/id_ed25519
    source $HOME/.keychain/$HOSTNAME-sh
}

# run keychain always
/usr/bin/keychain --nogui /mnt/c/Users/nicolai/.ssh/id_ed25519
source $HOME/.keychain/$HOSTNAME-sh

# note: key must have permissions set to 600!
```

## Docker

```bash
sudo apt install daemonize

# user to docker group
gpasswd -a nicolai docker

# install docker:
https://docs.docker.com/engine/install/debian/

# switch to iptables for docker to be happy
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
```

add to **.bash_aliases**:

```bash
# run command
DOCKER_PID=$(pidof dockerd)

if [ "$DOCKER_PID" == "" ]; then
    echo "- starting docker"
    sudo daemonize -v -a -e /var/log/docker.stderr.log -o /var/log/docker.stdout.log -l /var/lock/docker.lock /usr/bin/dockerd
else
    echo "- docker is running"
fi
```

## git prompt

Very simple git prompt:

add to ***.bash_aliases***:

```bash
# current git branch in prompt.
parse_git_branch() {
   git branch --show-current 2>/dev/null
}

# simple git prompt
export PS1="\$(date +%T)\[\033[32m\] \$(parse_git_branch)\[\033[00m\] \w\n$ "
```

## Optimize Disk

```bash
# optimize vhd (needs hyper-v tools from Windows features)
# run
# sudo fstrim -a
# in wsl first
wsl --shutdown
optimize-vhd .\ext4.vhdx -Mode Full

# info for vhd
Get-VHD .\ext4.vhdx | Format-List
```

