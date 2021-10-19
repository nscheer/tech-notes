# tmux

**Multi-Line-Status**

add to ***.tmux.conf***

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
set -ag status-format[1] "#[align=right][ #[fg=$TMUX_HOST_COLOR]#H#[fill=black,fg=white,bg=black] ][ %Y-%m-%d %H:%M:%S ][#(uptime | rev | cut -d':' -f1 | rev | sed s/,//g) ]"
```
