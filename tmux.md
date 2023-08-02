# tmux

tmux alias:

```alias tm='tmux new -A -D -s 0'```

add to ***.tmux.conf***

## Multi-Line-Status

```bash
# keys
# remap prefix to Control + a
set -g prefix C-a
# bind 'C-a C-a' to type 'C-a'
bind C-a send-prefix
unbind C-b

bind-key -n F5 new-window
bind-key -n F6 command-prompt "rename-window '%%'"
bind-key -n F7 previous-window
bind-key -n F8 next-window
bind-key -n F9 kill-window
bind-key -n F10 copy
#bind-key -n F11 paste

# window list
set-option -g history-limit 2000
set-option -g status 2
set -g set-titles on
set -g set-titles-string '#{pane_title} #S.#I'
set -g status-interval 1
set -g status-right ""

# neutral
TMUX_FG_COLOR=colour63
TMUX_BG_COLOR=colour250
TMUX_HOST_COLOR=colour63

# production
#TMUX_FG_COLOR=white
#TMUX_BG_COLOR=red
#TMUX_HOST_COLOR=red

# staging
#TMUX_FG_COLOR=white
#TMUX_BG_COLOR=green
#TMUX_HOST_COLOR=green

# styles
set -g status-style fg=black,bg=$TMUX_BG_COLOR
setw -g window-status-current-style fg=black,bg=$TMUX_FG_COLOR

# bottom status bar
set -g status-format[1] "#[fill=black,fg=white,bg=black]#[align=left]F5 New | F6 Title | F7/F8 Prev/Next | F9 Kill | F10 Copy"
set -ag status-format[1] "#[align=right][ #[fg=$TMUX_HOST_COLOR]#H#[fill=black,fg=white,bg=black] ][ %Y-%m-%d %H:%M:%S ][#(cat /proc/loadavg | cut -c 1-14) ]"
```

## Single-Line Status (for older tmux versions)

```bash
set -g default-terminal "screen-256color"

# keys
# remap prefix to Control + a
set -g prefix C-a
# bind 'C-a C-a' to type 'C-a'
bind C-a send-prefix
unbind C-b

bind-key -n F5 new-window
bind-key -n F6 command-prompt "rename-window '%%'"
bind-key -n F7 previous-window
bind-key -n F8 next-window
bind-key -n F9 kill-window
bind-key -n F10 copy
#bind-key -n F11 paste

# window list
set-option -g history-limit 2000

set-option -g status on

DARK=black
BRIGHT=white
COLOR=blue

set -g set-titles on
set -g set-titles-string '#{pane_title} #S.#I'
set -g status-interval 1
set -g status-style fg=$DARK,bg=$BRIGHT
set -g status-right-length 80
setw -g window-status-current-style fg=$BRIGHT,bg=$COLOR,bold
set -g status-right '[ #H ][ %Y-%m-%d %H:%M:%S ][#(cat /proc/loadavg | cut -c 1-14) ]'
```


