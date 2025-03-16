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

### `tmux` troubleshooting

In case you have problems with config changes being applied, i.e. setting a different theme, try deleting the following folder, and then reinstalling the plugins with `<prefix> + I` 

```zsh
rm -rf ~/.tmux/plugins/tmux 
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
list key bindings:          <prefix> + ?

enter copy mode:            <prefix> + [
paste the most recent:      <prefix> + ]

rename window:              <prefix> + ,
rename session:             <prefix> + $

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
show hidden:            <S-h>
find file by name:      <C-p>

lazygit:                <leader> lg
grep files:             <leader> fg

run terminal command:   :term <command>

feed to quickfix:       <C-q>
show  quickfix list:    <leader>qf
close quickfix list:    <leader>qq
next quickfix item:     <C-k>
prev quickfix item:     <C-j>

buffer format:          <leader> bf
metals commands:        <leader> gm

scroll docs down:       <C-f>
scroll dosc up:         <C-b>

go to definition:       gd
go to implementation:   gI
show docs:              <S> k

next diagnostic         ]d
previous diagostic      [d

go back:                <C-o>
go forward:             <C-i>

decrease pane width     -
increase pane width     =
decrease pane height    _
increase pane height    +

next word:              w
previous word:          b
end of word:            e

find char:              f
till char:              t

paste over:             <leader> p
substitute word:        <leader> s
comment out:            <leader> /

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
