# Tmuxifier

Tmuxify your Tmux. Create, edit and load complex Tmux session, window and pane
configurations with ease.

In short, Tmuxifier allows you to easily create, edit and load "layout"
files. A layout file is simply a shell script following a specific use pattern
of the `tmux` command to create Tmux sessions and windows.

### Window Layouts

Window layouts create a new Tmux window, optionally setting the window title
and root path where all shells are cd'd to by default. It allows you to easily
split a window into specifically sized panes and more as you wish.

You can load a window layout directly into your current Tmux session, or into
a session layout to have the window created along with the session.

### Session Layouts

Session layouts create a new Tmux session, optionally setting a session title
and root path where all shells in the session are cd'd to by default. Windows
can be added to the session either by loading existing window layouts, or
defined directly within the session layout file.

## Example

Given we have a window layout file called [example.window.sh][example] which
looks like:

[example]: https://github.com/jimeh/tmuxifier/blob/master/examples/example.window.sh

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

## Differences From Tmuxinator?

Though Tmuxifier is largely inspired by the excellent [tmuxinator][] project,
it does set itself apart in a number of ways:

- Uses shell scripts to define Tmux sessions and windows instead of YAML
  files. The benefit is total control over Tmux, but the definition files are
  more complicated to work with.
- Instead of using a "project" concept, Tmuxifier uses a concept of "sessions"
  and "windows". This allows you to load a whole session with multiple
  pre-defined window configurations, or just load a single window
  configuration into your existing session.
- Tmuxifier is a set of shell scripts, meaning it doesn't require Ruby to be
  installed on the machine to work.

## Inspiration

- As mentioned above, Tmuxifier is largely inspired by [tmuxinator][].
- I drew a lot of inspiration from [rbenv][] when it came to structuring the
  project, shell commands, and completion.

[tmuxinator]: https://github.com/aziz/tmuxinator
[rbenv]: https://github.com/sstephenson/rbenv

## Heed My Warning

Tmuxifier is pretty much an alpha product at this point. Documentation is
sketchy at best, and things might drastically change further down the line. If
that doesn't put you off, enjoy Tmuxifier :)

## Todo

* Improve Readme.
* Expand `help` command with details for most commands, rather than just the
  essential ones.

## License

Released under the MIT license. Copyright (c) 2012 Jim Myhrberg.
