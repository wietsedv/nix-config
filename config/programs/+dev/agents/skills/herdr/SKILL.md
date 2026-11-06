---
name: herdr
description: "Open panes, tabs and spaces in the user's Herdr window from a terminal on any machine, local or remote core, using only hc. Use when the user asks to open, split or show something in Herdr (for example a new pane running claude). Do not use merely because a task could benefit from a background terminal."
---

# Herdr: show terminals in the window

The Herdr window shows terminals that live in herdr-core (`hc`) on any
connected machine. The window places every terminal labeled
`herdr.space=<id>` and `herdr.tab=<id>`. Starting a labeled terminal with
`hc` is enough; it works the same on this machine's core and on a remote
one, and does not need `herdr-app` on this machine.

Only create what the user asked for. For orchestration that need not be on
screen, start terminals without these labels (`hc --help`).

## Where am I

```sh
hc get "$HC_TERMINAL_ID" --json | jq .labels
```

`HC_TERMINAL_ID` is this terminal's address in this machine's core. Its
`herdr.space` and `herdr.tab` labels say where it is shown. Ids are local to
the core: the window shows remote ones as `<machine>/<id>`; strip that prefix
when labeling on that machine.

## Open something

Always pass `--bg` (don't wait), `--keep` (as Herdr does for its own panes)
and `--no-parent` (otherwise the pane ends when this program exits).

```sh
labels=$(hc get "$HC_TERMINAL_ID" --json | jq -r .labels)
space=$(jq -r '."herdr.space"' <<<"$labels")
tab=$(jq -r '."herdr.tab"' <<<"$labels")
newid() { od -An -N16 -tx1 /dev/urandom | tr -d ' \n'; }

# Split: another pane in this tab
hc run --bg --keep --no-parent --cwd "$PWD" \
  --label herdr.space="$space" --label herdr.tab="$tab" -- claude "<task>"

# New tab in this space: any tab id the window doesn't know yet
hc run --bg --keep --no-parent --cwd "$PWD" \
  --label herdr.space="$space" --label herdr.tab="tb$(newid)" -- claude

# New space: any unknown space id, plus a fresh tab id
hc run --bg --keep --no-parent --cwd /path/to/project \
  --label herdr.space="sp$(newid)" --label herdr.tab="tb$(newid)" -- claude
```

Omit the program after `--` for the machine's default shell. The window picks
the split direction and names new tabs and spaces itself. For another
machine, add `--on <machine>` (`hc machine ls`) and use that machine's ids.

The result prints the new terminal's address (`{"address":"t9",...}`). Read
it, report it, and use `hc read`, `hc send`, `hc wait` on it as needed.
Closing: `hc kill <address>` ends the program and its pane.

## Finer control on the window's machine

If `herdr-app` is on PATH, this terminal runs on the machine with the window.
`herdr-app ls` lists spaces, tabs and pane ids; `herdr-app --skill` explains
`herdr-app do` (split direction, names, focus). Prefer `hc` labels when the
terminal may be on a remote core.
