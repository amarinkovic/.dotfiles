# .dotfiles

First off, include some common aliases and functions.

```zsh
echo "source ~/.dotfiles/.myrc" >> ~/.zshrc
```

Everything else in this repo is setup laid out to be used with [GNU Stow](https://www.gnu.org/software/stow/). Following tools can be configured using `stow` command:

- Allacrity: `stow alacritty`
- Git: `stow git`
- Neovim: `stow nvim`
- Tmux: `stow tmux`

# 
## `ssh-agent` setup

Add `ssh-agent` to `zsh` as a plugin, edit `.zshrc` and make sure you have this:

```zsh
plugins=(git ssh-agent)
```

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

## `tmux` shortcuts

Some common _tmux_ shortcuts, so that I don't forget them

```zsh
zoom pane:                  <prefix> + z

sync panes ON:              <prefix> + e
sync panes OFF:             <prefix> + E

split pane verticaly:       <prefix> + v
split pane horizontally:    <prefix> + h

move between panes:         <prefix> + arrows

list open sessions:         <prefix> + s
```

## `nvim` shortcuts

Some common _nvim_ shortcuts, so that I don't forget them

```zsh
<leader> key:   SPACE
<C> key:        CTRL
<M> key:        Option
<S> key:        Shift

show treeview:          <C-n>
find file by name:      <C-p>

// focus treeview:         <leader>  e
// close current file:     <leader>  x
// change theme:           <leader>  th
// find file (by name):    <leader>  ff

next word:              w

// top line of window:     <S>  H
// last line of window:    <S>  L
last line of file:      G
first line of file:     gg
begining of file:       [[
end of file:            ]]

// horizontal term:        <M> h   or  <leader> h
// vertical term:          <M> v   or  <leader> v
// floating term:          <M> i
```

When in _normal_ mode:

```zsh
delete between "":      di"
delete between {}:      di{
delete between ():      di(
delete inside xml tag:  dit
```
