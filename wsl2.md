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

We will be using Ubuntu 22.04 LTS.

 * get appx file from https://docs.microsoft.com/en-us/windows/wsl/install-manual
 * open app bundle file (Ubuntu2204-220620.AppxBundle) using e.g. 7-zip and extract the correct appx file for your platform (e.g. Ubuntu_2204.0.10.0_x64.appx)
 * open appx and extract root file system "install.tar.gz" to location for your wsl instance, e.g. `c:\wdsl\dev01`
 * get launcher from https://github.com/yuk7/wsldl and place beside root tar named as `dev01.exe`
 * installation will start and create "ext4.vhdx", delete install.tar.gz afterwards
 * run distro by running `dev01.exe`

Create `/etc/wsl.conf` with the following content:

```bash
[automount]
enabled = true
root = /mnt/
options = "metadata,umask=002,fmask=011"
mountFsTab = false

[network]
hostname = dev01
```

Exit WSL and stop the distribution with `wsl -t dev01`, and restart it.

Add your user and add it to the sudo group

```bash
sudo adduser nscheer
sudo gpasswd -a nscheer sudo
```

If you like, switch sudo group to not require a password, by adding `NOPASSWD:`

```bash
export EDITOR=nano
sudo visudo
# adjust the following line:
# %sudo   ALL=(ALL:ALL) NOPASSWD: ALL
```

Leave WSL again and set startup user using `dev01.exe config --default-user nscheer`

Run WSL again and do basic stuff...

```bash
sudo apt update
sudo apt upgrade
sudo apt install keychain htop git procps wget curl unzip mlocate
```

## Docker

```bash
# install docker: https://docs.docker.com/engine/install/ubuntu/
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# user to docker group
sudo gpasswd -a nscheer docker

# switch to iptables for docker to be happy
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# create add /etc/docker/daemon.json with:
{
    "log-driver": "json-file",
    "log-opts":
    {
        "max-size": "10m",
        "max-file": "3"
    },
    "log-level": "warning"
}

# start docker service (add it to your .bash_aliases to do it on "startup")
sudo service docker start
```

## very simple two line git prompt

add to ***.bash_aliases***:

```bash
# current git branch in prompt.
parse_git_branch() {
   git branch --show-current 2>/dev/null
}

# simple git prompt
export PS1="\$(date +%T)\[\033[32m\] \$(parse_git_branch)\[\033[00m\] \w\n\u@\h$ "
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

