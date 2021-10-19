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
wsl --unregister dev02
```



## Basic installation

```bash
# note: AppxBundle needs unpacking to x64 appx first
# get appx file from
# https://docs.microsoft.com/en-us/windows/wsl/install-manual

# open with 7-zip and extract root tar (e.g. install.tar.gz) to e.g. c:\wsl\dev01

# get launcher from https://github.com/yuk7/wsldl and place beside root tar named as dev01.exe

# run launcher dev01.exe to register distribution (name of exe will be name of distro)

# create /etc/wsl.conf and restart wsl
[automount]
enabled = true
root = /mnt/
options = "metadata,umask=002,fmask=011"
mountFsTab = false

# add user
sudo adduser nicolai

# add user to sudo group
sudo gpasswd -a nicolai sudo

# switch sudo group to nopasswd (add "NOPASSWD:")
export EDITOR=nano
visudo
# %sudo   ALL=(ALL:ALL) NOPASSWD: ALL

# set startup user id for distro
dev01.exe config --default-user nicolai

# basic stuff 
sudo apt install keychain htop git procps wget curl unzip libxss1 mlocate fontconfig libxrender1 libxtst6

# shitload of deps for phpstorm
sudo apt install librust-gobject-sys-dev libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libx11-xcb1 libdrm libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libpangocairo-1.0-0 libasound2 libcups2 libxshmfence1

# add sury (https://deb.sury.org/)
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
sudo apt update
sudo apt install php7.3-{cli,xmlreader,curl,gd,redis,intl,zip,xdebug,bcmath,mysqlnd,imap,mcrypt,mysqli,pspell,soap,sqlite3,ssh2,stomp,tidy,xmlrpc,mbstring}

# add debian backports and install newer git
# https://backports.debian.org/Instructions/
# add
# "deb http://deb.debian.org/debian buster-backports main"
# to /etc/apt/sources.list.d/backports.list
sudo apt update
sudo apt install git/buster-backports

# install node
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt -y install nodejs

# add de_DE.UTF-8 as locale (select none as default)
# https://wiki.debian.org/Locale
sudo dpkg-reconfigure locales
```



## custom fonts

```bash
# copy wanted fonts (for me these are Consolas and Segoe UI) via drag & drop from Windows to some wsl folder
# add *.ttf to /usr/local/share/fonts
# then, refresh font cache
sudo fc-cache

# then in PhpStorm:
# Appearance & Behaviour: use custom font Segoe UI, size 13
# Editor -> Font: Use Consolas 13, spacing 1.2
```



## add dev01 to PhpStorm

This is only needed, if you plan on staying on Windows with PhpStorm :)

```bash
"C:\Users\nicolai\AppData\Roaming\JetBrains\PhpStorm2020.3\options\wsl.distributions.xml"
```

```xml
<descriptor>
    <id>DEV01</id>
    <microsoft-id>dev01</microsoft-id>
    <executable-path>c:/wsl/dev01/dev01.exe</executable-path>
    <presentable-name>dev01</presentable-name>
</descriptor>
```



## X-Server on Windows

### vcxsrv

Just use vcxsrv: https://sourceforge.net/projects/vcxsrv/

Run configuration using xlaunch.exe, and save a config.xlaunch like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<XLaunch WindowMode="MultiWindow" ClientMode="NoClient" LocalClient="False" Display="-1" LocalProgram="xcalc" RemoteProgram="xterm" RemotePassword="" PrivateKey="" RemoteHost="" RemoteUser="" XDMCPHost="" XDMCPBroadcast="False" XDMCPIndirect="False" Clipboard="True" ClipboardPrimary="False" ExtraParams="" Wgl="True" DisableAC="True" XDMCPTerminate="False"/>
```

Important: Deactivate "Primary Selection" for clipboard and activate "Disable access control" (WSL2 is "external"). Will need to revisit this later for making access more secure. Meanwhile, be sure to allow firewall access for vcxsrv.

### x410

Supports windowed mode, where apps that monitor keyboard/mouse focus are triggered correctly (e.g. PHPStorm saving files when window looses focus).

Firewall: https://x410.dev/cookbook/wsl/protecting-x410-public-access-for-wsl2-via-windows-defender-firewall/

### setting DISPLAY

Add this to your ***.bash_aliases*** to configure DISPLAY:

```bash
# configure x11
# change scale, if needed
export GDK_SCALE=1
export LIBGL_ALWAYS_INDIRECT=1
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

```



## ssh-config xdebug

add to ***.ssh/config***:

```bash
Host dev
    Hostname my-dev-host
    User nicolai
    ForwardAgent yes
    # tunnel for php debugging
    RemoteForward 9003 localhost:9003
```



## PhpStorm

Just download, unzip and run "bin/phpstorm.sh": https://www.jetbrains.com/phpstorm/download/#section=linux

add to ***.bash_aliases***:

```bash
# run phpstorm
alias phpstorm='pkill -9 -f phpstorm; LC_TIME=de_DE /home/nicolai/phpstorm/bin/phpstorm.sh > /dev/null 2>&1 &'
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



## composer

```bash
# get latest 1.x composer
sudo wget https://getcomposer.org/composer-1.phar -O /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
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

