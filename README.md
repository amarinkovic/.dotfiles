# dotfiles

Add to your shell config by executing this command:

```zsh
echo "source ~/.dotfiles/alias.conf" >> ~/.zshrc
```

## tmux shortcuts

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

## nvim shortcuts

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
