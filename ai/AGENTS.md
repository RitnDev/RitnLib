# AGENTS.md — Ritn mod conventions

> Copy this file to the root of your Factorio mod. AI coding tools (Codex, Cursor, Copilot, Claude Code via
> `CLAUDE.md`…) read it automatically. Full guide (FR / EN):
> https://ritndev.github.io/RitnLib/guides/mod-conventions/ — kit: https://github.com/RitnDev/RitnLib/tree/main/ai

This mod follows the conventions of the Ritn Factorio mods (Factorio 2.x). Write code **as it must look
after review**: structure, comments and LuaLS annotations included, from the first line.

## Variant

- **With RitnLib** (default): `info.json` depends on `RitnLib`; base classes `RitnLibGui`, `RitnLibGuiElement`,
  `RitnLibPlayer`… come from RitnLib. Template: `ai/template/with-ritnlib/`.
- **Standalone**: no dependency; the base classes are local copies (model: gvv). Template: `ai/template/standalone/`.

## Layout

```
info.json  changelog.txt  settings.lua  data.lua  control.lua
core/defines.lua         path registry — every require goes through it
core/setup-classes.lua   loads the classes, parent before child
core/modules.lua         list of the modules given to the event handler
core/migrations.lua      one migration per version (if storage)
classes/                 one global class per file, prefixed by the mod
gui/                     window descriptions: getElement(gui_name) / getContent()
modules/                 one domain per file, returns { events = {...}, on_init?, on_load?, ... }
lualib/                  helper modules (local … return)
prototypes/              data stage only
types/<mod>-globals.lua  LuaLS meta-file of the globals (shipped in the zip)
docs/architecture.md     living maintainer doc (export-ignored)
```

## Hard rules (never break)

1. **No hard-coded `require` path**: use the registry (`ritnlib.defines.<modkey>.…` with RitnLib,
   `<mod>.defines.…` standalone). New file → add its path to `core/defines.lua`.
2. **No `require` during the game** (events, commands, remote calls): Factorio raises
   "Require can't be used outside of control.lua parsing". Require everything while `control.lua` loads.
3. **Classes are temporary wrappers**: create one per event (`MyClass(event)`), never store an instance,
   a function or a GUI element in `storage`. Only serialisable data and API Lua objects go there.
4. **GUI element names** = `gui_name-type-name` (e.g. `panel-button-close`); **no `-` inside a part**
   (use `_`). Short types: `sprite-button`→`button`, `scroll-pane`→`pane`, `empty-widget`→`empty`,
   `list-box`→`listbox`, `drop-down`→`dropdown`, `tabbed-pane`→`tabbed`, `text-box`→`textbox`.
   Dynamic data goes into `element.tags`. `gui_name` is **prefixed by the mod** (`mymod_panel`): names must be
   unique inside `player.gui` across all mods.
5. **Events go through `__core__.lualib.event_handler`**: each `modules/*.lua` returns
   `{ events = { [defines.events.x] = handler } }`, listed in `core/modules.lua`. No `script.on_event`
   inside a module. `on_load` never writes `storage`.
6. **Creation-only GUI properties** (`numeric`, `allow_decimal`, `column_count`, `minimum_value`,
   `clear_and_focus_on_right_click`…) go into the spec, never after `add`.
7. **Keep each file's line endings** (CRLF in most Ritn mods). Never convert a whole file.
8. **Never change behaviour silently**: a bug found while doing something else is reported, not fixed in passing.

## Code style

- **Every block of code has a FR + EN comment**, French first:
  ```lua
  -- FR : Fenêtre fermée : rien à faire
  -- EN : Window closed: nothing to do
  if frame == nil then
      return self
  end
  ```
- One statement per line, no one-line function, no compact code, explicit names.
- A method with nothing useful to return returns `self`.
- Methods tolerate a missing player / closed window (check, then return) instead of raising.
- Copied code (e.g. RitnLib base classes in standalone): header
  `-- FR : Source : RitnLib (Ritn), <file> (<class>), version x.y.z` + the differences.

## LuaLS annotations — write them with the code

Every function, method and class gets its block **when it is created**. Format (EN then FR, Unicode line U+2500):

```lua
-- simple comment above, if any
                                        ← empty line REQUIRED after a simple comment
---**EN**
---
---Description: Closes the panel.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ferme le panneau.
---@param force? boolean   Short English description
---@return MyModGuiPanel self  Chainable
function MyModGuiPanel:close(force)
```

- `⚠` only for a verified fact (side effect, snapshot, beta, deprecated), in both languages.
- Tags right after the FR text, no empty line, block stuck to the code line.

**Class** (one continuous block, then cast at the end of `newclass`):

```lua
---**EN**
---
---Description: Panel of MyMod.
---
---⚠ Temporary wrapper, created on each event. Do not store the instance in `storage`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Panneau de MyMod.
---
---⚠ Wrapper temporaire, créé à chaque évènement. Ne pas stocker l'instance dans `storage`.
---@class MyModGuiPanel : RitnLibGui
---@field object_name string   "MyModGuiPanel"
---@operator call(EventData): MyModGuiPanel
---@type MyModGuiPanel
MyModGuiPanel = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    ...
end) --[[@as MyModGuiPanel]]
```

- Do not re-declare inherited `@field`s (except overridden ones like `object_name`).
- **Mirror every global class** in `types/<mod>-globals.lua` (same `@class`, `@field`, `@operator`, then
  `MyModGuiPanel = {}`), and update both places together. Header of that file: `---@meta` + `---@diagnostic disable`.
- Module returning a table of functions: annotate each function; a "service" module gets a `@class` at the top
  and `---@type` on the returned table.

## GUI pattern

- `gui/<window>.lua`: `getElement(gui_name)` returns the specs (built with `RitnLibGuiElement(gui_name, type, name)…:get()`),
  `getContent()` returns the paths from `gui[1]` (`{ "frame-main", "button-close" }`, without the `gui_name-` prefix).
- Window class inherits `RitnLibGui` and fills `gui[1]` (container), `content`, `gui_action`.
- **With RitnLib**: `gui_action = { [gui_name] = { ["button-close"] = true } }`; the action is served by the remote
  interface named after the mod, function `gui_action_<gui_name>(action, event)`.
- **Standalone**: `gui_action = { ["button-close"] = "action_close" }`, method called directly.
- Free window centred: `auto_center = true` after setting its size.
- GUI handlers are protected: on error, print to the player **and** `log()` the message with the call stack.

## Data stage

- `data.lua` = `require("core.defines")` then the `prototypes/` files through the registry.
- Prototype names prefixed by the mod. Ritn gameplay mods share compat flags through `ritnmods.<mod>`
  (data stage global) and one file per third-party mod in `mods/`.

## Before saying "done"

- Syntax checked (`luac -p`), registry and `setup-classes.lua` / `core/modules.lua` updated.
- `storage` structure changed → migration added in `core/migrations.lua`, `changelog.txt` updated.
- `docs/architecture.md` updated if the structure changed (new layer, module, class family, event, storage key).
- Tested **in game** when possible (by hand, or with RitnTest: https://github.com/RitnDev/RitnTest — fake GUI events through RCON,
  local test game only, never on a public server);
  out-of-game tests miss the real API and the `require` restriction.
