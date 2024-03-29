# .dotfiles

Add aliases to your shell config by executing this command:

```zsh
echo "source ~/.dotfiles/.myrc" >> ~/.zshrc
```

Add the contents of `.gitconfig` to the current config

```zsh
cat ~/.dotfiles/.gitconfig >> ~/.gitconfig
```

## `ssh-agent` setup

Add `ssh-agent` to `zsh` as a plugin, edit `.zshrc` and make sure you have this:

```zsh
plugins=(git ssh-agent)
```

## `tmux` setup

After installing, run the following commands for `tmux` setup, from your home folder execute:

```zsh
ln -s .dotfiles/.tmux.conf .
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then in tmux, press `<prefix> + I` to install plugins defined in `.tmux.conf`

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

show treeview:          <C>  n
focus treeview:         <leader>  e
close current file:     <leader>  x
change theme:           <leader>  th
find file (by name):    <leader>  ff
next word:              w

top line of window:     <S>  H
last line of window:    <S>  L
last line of file:      <S>  G

horizontal term:        <M> h   or  <leader> h
vertical term:          <M> v   or  <leader> v
floating term:          <M> i
```

When in _normal_ mode:

```zsh
delete between "":      di"
delete between {}:      di{
delete between ():      di(
delete inside xml tag:  dit
```

## `alacritty` setup

First off you should install [themes](https://github.com/alacritty/alacritty-theme) by running:

```zsh
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
```

Then link the config file to the appropriate location

```zsh
ln .dotfiles/alacritty.toml ~/.config/alacritty/alacritty.toml
```