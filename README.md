# tmuxifier

Tmuxify your Tmux. Create, edit and load complex Tmux session, window and pane
configurations with ease.

Tmuxifier is inspired by the excellent [tmuxinator][] Project. While
tmuxinator is childishly easy to configure with it's YAML project files, it's
also restricting me from the kind of powerful control I want over Tmux.

[tmuxinator]: https://github.com/aziz/tmuxinator

To solve this problem, I opted for shell scripts with pretty helper functions
instead of the cleaner but more limiting YAML config files. This allows you to
create pre-defined session and window layouts with panes spit exactly as you
like. You will need to be very familiar with a few of Tmux's commands however.

## Example

Given with have a window layout file called `example.window.sh` which looks
like:

```bash
window_name "Example Window"
window_root "~/Desktop"
tmux new-window -t "$session" -n "$window"
tmux split-window -t "$session:$window.0" -v -p 20 "watch -t date"
tmux split-window -t "$session:$window.1" -h -p 60
tmux select-pane -t "$session:$window.0"
```

You can then load that window layout into a new window in the
current tmux session using:

```bash
tmuxifier window example
```

Which will yield a Tmux window looking like this:

![example](https://github.com/jimeh/tmuxifier/raw/master/examples/example.window-screenshot.png)

## Installation

```bash
git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
```

And add the following to your `~/.profile` or equivalent:

```bash
[[ -s "$HOME/.tmuxifier/init.sh" ]] && source "$HOME/.tmuxifier/init.sh"
```

### Custom Installaton Path

To install Tmuxifier to a custom path, clone the repository to your desired
path, and set `$TMUXIFIER` to that path, additionally loading `init.sh` from
that same path.

```bash
export TMUXIFIER="$HOME/.dotfiles/tmuxifier"
[[ -s "$TMUXIFIER/init.sh" ]] && source "$TMUXIFIER/init.sh"
```

## License

Released under the MIT license. Copyright (c) 2012 Jim Myhrberg.
