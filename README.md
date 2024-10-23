# .dotfiles

First off, include some common aliases and functions.

```zsh
echo "source ~/.dotfiles/.myrc" >> ~/.zshrc
```

Everything else in this repo is laid out to be used with [GNU Stow](https://www.gnu.org/software/stow/). Following tools can be configured using `stow` command:

- Allacrity: `stow alacritty`
- Git: `stow git`
- Neovim: `stow nvim`
- Tmux: `stow tmux`

## `tmux` setup

After stowing, run the following commands for `tmux` plugin manager setup. From your home folder execute:

```zsh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then inside `tmux`, press `<prefix> + I` to install plugins defined in `.tmux.conf` file.

Also make sure to have a proper font installed, for example if you are on mac:

```zsh
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

You can use `FiraCode` by installing

```zsh
brew install --cask font-fira-code-nerd-font # macOS
sudo pacman -S ttf-firacode-nerd             # arch btw
```

If you use Arch by the way, you can install the fonts from [here](https://archlinux.org/groups/any/nerd-fonts/), like this:

```zsh
sudo pacman -S ttf-hack-nerd
```

## `tmux` shortcuts

Some common _tmux_ shortcuts, so that I don't forget them. Current prefix is `<Ctrl-z>`.

```zsh
pane zoom:                  <prefix> + z

pane resize up:             <prefix> + <M-up>
pane resize down:           <prefix> + <M-down>
pane resize left:           <prefix> + <M-left>
pane resize right:          <prefix> + <M-right>

move between panes:         <prefix> + arrows

sync panes ON:              <prefix> + e
sync panes OFF:             <prefix> + E

pane split verticaly:       <prefix> + v
pane split horizontally:    <prefix> + h

list open sessions:         <prefix> + s

reload tmux config:         <prefix> + r
source tmux config:         <prefix> + R
```

## `nvim` shortcuts

Some common _nvim_ shortcuts, so that I don't forget them

```zsh
<leader> key:   SPACE
<C> key:        CTRL
<M> key:        Option/Alt
<S> key:        Shift

show treeview:          <C-n>
find file by name:      <C-p>

grep files:             <leader> fg
format file with:       <leader> gf
metals commands:        <leader> gm

go to definition:       gd
go to implementation:   go

go back:                <C-o>
go forward:             <C-i>

next word:              w
previous word:          b
end of word:            e

find char:              f
till char:              t

mach bracket (,[ or {   %

first line of file:     gg
last line of file:      G
go to line X            X + G
begining of file:       [[
end of file:            ]]

next current word:      *
prev current word:      #

increment number:       <C> + a
decrement number:       <C> + x

join lines:             <S> + j
repeat last action:     .
```

When in _normal_ mode:

```zsh
delete between "":      di"
delete between {}:      di{
delete between ():      di(
delete inside xml tag:  dit
```
