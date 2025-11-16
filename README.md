# OSC7 support for Yazi

This plugin enables modern terminal emulators' directory tracking features to work with yazi by emitting OSC 7 escape sequences.

When using yazi in iTerm2, splitting the window doesn't open the new pane in yazi's current directory.

This plugin emits **OSC 7** escape sequences to inform iTerm2 of the current working directory as you navigate in yazi.


### Installation
```
ya pkg add 'uznog/cwd-osc7'
```

Load in `init.lua`:
```lua
require("cwd-osc7"):setup()
```

