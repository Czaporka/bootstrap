# Bootstrap

## Description
Overengineered solution for installing my poor collection of dotfiles and scripts to freshly provisioned machines.

## Current state / TODO list
- [x] Installing scripts
- [ ] Installing dotfiles

## Example
```
user@host:~/bootstrap$ make install-script-make-env.sh
user@host:~/bootstrap$ ll ~/.local/bin/make-env
-rwxrwxr-x 1 user user 2418 Jan 10 13:37 /home/user/.local/bin/make-env*
```

## Usage
Installing stuff is done via GNU `make`.

Type `make <TAB>` to view the list of available targets.

> The Makefile is written in such a way that adding a new file to `scripts/` or `dotfiles/` will result in a new target generated for it automatically.
>
### Currently available targets for dotfiles:
* `install-dotfile-bashrc`
* `install-dotfile-tmux.conf`
* `install-dotfile-xinitrc`
* `install-dotfile-bash_aliases`
* `install-dotfile-config/alacritty/alacritty.yml`
* `install-dotfile-config/Code/User/settings.json`
* `install-dotfile-config/...`  # there is a target for every file in `dotfiles/config/`
* `install-dotfile-vimrc`

### Currently available targets for scripts:
* `install-script-make-env.sh`

### Currently available targets for other stuff
* `clean` - remove the `target/` directory
* `render` - render dotfiles into `target/` (`dotfiles/` may contain Jinja templates)
* `status` - check what is installed and what isn't (see below)

### Sample output of `status`
```
===============================
|          dotfiles:
-------------------------------
[Differs      ]: /home/user/.vimrc
[Not installed]: /home/user/.config/i3status/config/i3status.conf
[Differs      ]: /home/user/.config/alacritty/alacritty.yml
[Differs      ]: /home/user/.config/i3/config
[Up to date   ]: /home/user/.config/Code/User/settings.json
[Not installed]: /home/user/.config/compton/compton.conf
[Not installed]: /home/user/.xinitrc
[Not installed]: /home/user/.bash_aliases
[Not installed]: /home/user/.tmux.conf
[Differs      ]: /home/user/.bashrc
===============================
|         scripts:
-------------------------------
[Up to date   ]: /home/user/.local/bin/make-env
```

## Installation
```bash
git clone https://github.com/Czaporka/bootstrap.git
cd bootstrap
make <target>
```
