# PHPStorm on WSL2

```bash
# shitload of deps for phpstorm
sudo apt install libxss1 fontconfig libxrender1 libxtst6 librust-gobject-sys-dev libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libx11-xcb1 libdrm libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libpangocairo-1.0-0 libasound2 libcups2 libxshmfence1

# add sury (https://deb.sury.org/)
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
sudo apt update
sudo apt install php7.3-{cli,xmlreader,curl,gd,redis,intl,zip,xdebug,bcmath,mysqlnd,imap,mcrypt,mysqli,pspell,soap,sqlite3,ssh2,stomp,tidy,xmlrpc,mbstring}

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

## PhpStorm

Just download, unzip and run "bin/phpstorm.sh": https://www.jetbrains.com/phpstorm/download/#section=linux

add to ***.bash_aliases***:

```bash
# run phpstorm
alias phpstorm='pkill -9 -f phpstorm; LC_TIME=de_DE /home/nicolai/phpstorm/bin/phpstorm.sh > /dev/null 2>&1 &'
```
