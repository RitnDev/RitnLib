---
title: Ritn mod conventions
type: guide
lang: en
---

# Ritn mod conventions

This guide describes the structure and the shared rules of the mods of the Ritn ecosystem. It is meant
for a developer who writes or takes over a mod, **and for an AI** working on it: each rule is worded to be
applied as is. When in doubt, copy the reference mod rather than inventing.

Two variants exist:

| Variant | When | Reference mod |
|---|---|---|
| **With RitnLib** | general case: the mod depends on RitnLib and uses its classes | RitnLobbyGame, RitnCharacters |
| **Standalone** | public tool that must not depend on anything | gvv (0.6) — local copy of RitnLib's base classes |

Rules marked *(both)* apply in every case.

---

## 1. Folder layout *(both)*

```
<Mod>/
├─ info.json
├─ changelog.txt            Factorio changelog format, strict
├─ settings.lua             settings stage (at the root, required by Factorio)
├─ data.lua                 data stage: loads defines then prototypes/
├─ control.lua              control stage: defines → classes → modules
├─ core/
│  ├─ defines.lua           path registry (no hard-coded require anywhere else)
│  ├─ setup-classes.lua     loads the classes (in inheritance order)
│  ├─ modules.lua           list of the modules sent to the event handler
│  └─ migrations.lua        one migration per version (if storage)
├─ classes/                 one class per file (Ritn<Mod>Xxx / Gvv<Xxx>)
├─ gui/                     windows description: getElement / getContent
├─ modules/                 one module per domain, returns { events = {...} }
├─ lualib/                  utility functions (local … return modules)
├─ prototypes/              data stage only (custom-inputs, styles, sprites…)
├─ mods/                    compatibility with other mods, one file per mod (if needed)
├─ locale/<language>/<mod>.cfg
├─ types/<mod>-globals.lua  LuaLS meta-file of the globals (shipped in the zip)
└─ docs/                    maintainer docs (left out of the zip)
```

Rules:
- One file = one responsibility. No "catch-all" file.
- `prototypes/` holds **only** data stage code; `classes/`, `gui/`, `modules/` **only** control stage code.

## 2. Path registry `defines` *(both)*

Every `require` goes through a registry. No file writes a hard-coded path: if a file moves, only the
registry changes.

**With RitnLib** — the mod adds its registry inside RitnLib's (`RitnLobbyGame/core/defines.lua`):

```lua
if not ritnlib then require("__RitnBaseGame__.core.defines") end   -- or __RitnLib__.defines
local name = "RitnLobbyGame"
local dir = "__" .. name .. "__"
local defines = {}
defines.name = name
defines.directory = dir
defines.setup = dir .. ".core.setup-classes"
defines.class = { guiLobby = dir .. ".classes.RitnGuiLobby", ... }
defines.modules = { core = dir .. ".core.modules", events = dir .. ".modules.events", ... }
defines.gui = { lobby = dir .. ".gui.lobby", ... }
defines.prototypes = { customInputs = dir .. ".prototypes.custom-inputs" }
ritnlib.defines.lobby = defines        -- short key of the mod inside the shared registry
```

**Standalone** — the mod creates its own global (`gvv/core/defines.lua`):

```lua
local name = "gvv"
local directory = "__" .. name .. "__"
local defines = { name = name, directory = directory, class = {...}, gui = {...}, modules = {...} }
if not gvv then gvv = {} end
gvv.defines = defines
```

Rules:
- The registry is loaded at the **data stage and the control stage** (`require("core.defines")` first).
- **`require` is forbidden during the game** (inside an event, a command, a `remote.call`): everything that
  must be required is required while `control.lua` loads. Otherwise Factorio raises
  "Require can't be used outside of control.lua parsing".

## 3. `control.lua` bootstrap *(both)*

```lua
require("core.defines")                                   -- 1. registry
require(<registry>.setup)                                 -- 2. classes (globals)
local listener = require(<registry>.event)                -- 3. modules → event handler
    .add_libraries(require(<registry>.modules.core))
if script.active_mods["gvv"] then require("__gvv__.gvv")() end         -- make the mod readable by gvv
if script.active_mods["RitnTest"] then require("__RitnTest__.interface") end   -- in-game tests (dev)
```

- Event handler: `__core__.lualib.event_handler` (exposed by RitnLib as `ritnlib.defines.event`).
- The last two lines do nothing if gvv / RitnTest are not installed.

## 4. Classes *(both)*

- Created by the **class factory** (`ritnlib.classFactory` with RitnLib, local copy `core/class.lua`
  when standalone): `X = factory.newclass(Parent, function(self, ...) Parent.init(self, ...) end)`.
- **Global** (`_G`), prefixed by the mod: `RitnLobbyGuiRequest`, `GvvGuiTree`. One class per file, loaded by
  `core/setup-classes.lua` **in inheritance order** (parent before child).
- **Temporary wrappers**: an instance is created on each event (`X(event)`) and dropped afterwards.
  **Never an instance inside `storage`**: data goes there, not objects.
- `object_name` holds the class name (e.g. `self.object_name = "GvvGuiTree"`).
- A method that returns nothing useful returns `self` (chaining).
- Methods tolerate a missing player or a closed window (`isPresent`, `nil` elements) without error.

## 5. Modules and events *(both)*

Each file of `modules/` handles one domain and returns a table for the event handler:

```lua
local function on_player_created(event) ... end

local module = {events = {}}
module.events[defines.events.on_player_created] = on_player_created
-- optional: module.on_init, module.on_load, module.on_configuration_changed, module.add_commands
return module
```

`core/modules.lua` gathers them:

```lua
local modules = {}
modules.events = require(<registry>.modules.events)
modules.gui = require(<registry>.modules.gui)
return modules
```

Rules:
- No direct `script.on_event` inside a module: everything goes through the event handler. Documented
  exception: an `on_tick` enabled / disabled by a setting (gvv), registered again in `on_load` from `storage`.
- `on_load` must **never** write into `storage` (desync).
- A GUI handler is **protected**: the error is shown to the player **and** written to the log
  (`log(...)` with the call stack), so that it can be found again (bug reports, tests).

## 6. GUI *(both)*

### Description inside `gui/<window>.lua`

```lua
local function getElement(gui_name)          -- specs given to LuaGuiElement.add
    return {
        frame = { main = <Class>Element(gui_name, "frame", "main"):vertical():get() },
        button = { close = <Class>Element(gui_name, "sprite-button", "close"):spritePath("utility/close"):get() },
    }
end
local function getContent()                  -- paths from gui[1]
    return { frame = { main = { "frame-main" } }, button = { close = { "frame-main", "button-close" } } }
end
return { getElement = getElement, getContent = getContent }
```

`<Class>Element` = `RitnLibGuiElement` (with RitnLib) or the local copy (`GvvGuiElement`).

### Element naming

- Name = **`gui_name-type-name`**, e.g. `gvv_main-button-close`, `lobby-button-create`.
- **None of the three parts contains `-`** (the name is split on `-`). Use `_` inside a part.
- **`gui_name` prefixed by the mod** (`gvv_main`, `mymod_panel`): names must be unique inside `player.gui`,
  across all the windows of all the mods.
- Long types are shortened: `sprite-button` → `button`, `scroll-pane` → `pane`, `empty-widget` → `empty`,
  `list-box` → `listbox`, `drop-down` → `dropdown`, `tabbed-pane` → `tabbed`, `text-box` → `textbox`.
- The action of an element is `type-name` (e.g. `button-close`), followed by the event name for events
  other than the click (`listbox-result-selection_state_changed`).

### Window class

- Inherits from `RitnLibGui` (or the local copy `GvvGui`).
- **Extension contract**: the sub-class fills `gui[1]` (container), `content` (= `getContent()`),
  `gui_action`, then writes its action methods.
- **Actions**:
  - with RitnLib: `gui_action = { [gui_name] = { [action] = true } }` and the action is served by a
    `gui_action_<gui_name>` remote interface (see the *Full GUI pattern* guide);
  - standalone: `gui_action = { ["button-close"] = "action_close" }`, the method is called directly.
- **Dynamic data inside `element.tags`** (tree row, entry index…), never encoded in the name beyond `name`.
- **No GUI element reference inside `storage`**: an element is found again through its path (`getElement`).
- Properties set **at creation only** (`numeric`, `allow_decimal`, `column_count`, `minimum_value`,
  `clear_and_focus_on_right_click`…): put them in the spec, not after `add`.
- Centred free window: `auto_center = true` **after** its size is given.

## 7. Data stage *(both)*

- `data.lua` only does `require("core.defines")` then the files of `prototypes/` through the registry.
- Prototype names prefixed by the mod (`_gvv-mod`, `ritnmods-…`): never a clash with the game.
- **Compatibility between Ritn mods** (gameplay mods): each mod creates `ritnmods.<mod>` in its `data.lua`
  (`if not ritnmods then ritnmods = {} end`), with its detection flags and shared data; the others read it.
  One file per third-party mod inside `mods/`, guarded by `if ritnmods.<mod>.<flag> then`.
- A variable that no longer exists in the game (e.g. an old global of `style.lua`) is `nil`: do not rely
  on undocumented game globals.

## 8. `storage` and migrations *(both)*

- Per-player data: `storage.players[player_index]`, created on first use.
- What goes into `storage`: serialisable data (numbers, strings, tables, API Lua objects).
  **Never**: class instances, functions, GUI element references.
- `core/migrations.lua`: one entry per version, run in `on_configuration_changed` when the mod changes
  version (`mod_changes[<mod>].old_version`), in order, protected and logged (`log`).

## 9. Code style *(both)*

- **FR + EN comments**: each block of code has its comment, French then English:
  ```lua
  -- FR : Fenêtre fermée : rien à faire
  -- EN : Window closed: nothing to do
  if frame == nil then
      return
  end
  ```
- One statement per line, no one-line function, no compact code.
- **Line endings: keep the file's own** (CRLF in most mods, LF in part of RitnLib).
  Never convert a whole file; check with `git ls-files --eol`.
- Files copied from another mod (e.g. RitnLib classes when standalone): header
  `-- FR : Source : RitnLib (Ritn), <file> (<class>), version x.y.z` + the differences.

## 10. LuaLS annotations *(both)*

Format of the RitnLib gold standard: **EN then FR**, separated by a Unicode line `─` (U+2500), tags after the FR:

```lua
---**EN**
---
---Description: Closes the main window.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ferme la fenêtre principale.
---@param ignore_save? boolean
---@return GvvGuiMain self  Chainable
function GvvGuiMain:close(ignore_save)
```

- **Every function, method and class gets its block when it is created**, never "later": the code is written
  directly in its final state (no annotation pass afterwards).
- An empty line is **required** between a simple `-- …` comment and a `---` block.
- Inline descriptions of `@param` / `@field`: short, in English.
- `⚠` only for a verified fact (side effect, snapshot, beta, deprecated), in both languages.

Class — one continuous block stuck to the assignment, then **cast** at the end of `newclass(...)`:

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
---@operator call(table): MyModGuiPanel
---@type MyModGuiPanel
MyModGuiPanel = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    ...
end) --[[@as MyModGuiPanel]]
```

- Do not re-declare inherited `@field`s (except the ones the child overrides, like `object_name`).
- **Mirror**: each global class is copied into `types/<mod>-globals.lua` (`---@meta`, `---@diagnostic disable`),
  same `@class` / `@field` / `@operator`, then `MyModGuiPanel = {}`. Both places change together.
  This file is **shipped** in the zip (autocompletion for the developers of the mods depending on yours).

## 11. Repository and publishing *(both)*

- `info.json`: `factorio_version`, exact dependencies (`RitnLib >= x.y`, optional `?`, hidden `(?)`).
- `changelog.txt` in the Factorio format (dashes line, `Version:`, `Date:`, indented categories).
- `.gitattributes`: `export-ignore` for `docs`, `tests`, `.github`, `.claude`… (left out of the zip).
- Bilingual Markdown files: FR line ended by **two spaces**, EN line right below.
- Publishing through a git tag (`release.yml` workflow: `git archive` of the tag).

- **Living `docs/architecture.md`**: updated on every structural change (new layer, class family, module,
  event, `storage` key, remote interface).

## 12. In-game tests *(both)*

Test **in the real game** before calling a task done: an out-of-game test sees neither the real API nor the
`require` restriction during the game. Errors are read in `factorio-current.log` (hence the `log()` of §5).

The [**RitnTest**](https://github.com/RitnDev/RitnTest) development mod (on GitHub, not on the portal; **never on a public server**) drives the real game through RCON: fake GUI events sent
to the mod handlers, GUI reading, screenshots, `eval` inside the mod VM. The tested mod adds the RitnTest
line of §3; it does nothing for someone who doesn't have RitnTest.

## 13. AI kit *(both)*

The [`ai/` folder of RitnLib](https://github.com/RitnDev/RitnLib/tree/main/ai) holds what you need to start:
- `AGENTS.md` and `CLAUDE.md`: the rules for the AI, to copy to the mod root;
- `skills/ritn-mod-conventions/`: Claude Code skill, to copy into `.claude/skills/`;
- `template/with-ritnlib/` and `template/standalone/`: mod skeletons ready to copy (rename `MyMod`).

---

## For an AI — action rules

1. **Read before writing**: `core/defines.lua`, `core/modules.lua`, the class and the `gui/` file concerned,
   then copy the existing style. The reference mod of the variant prevails.
2. **Never**: write a hard-coded `require` path, `require` during the game, store a class instance or a GUI
   element in `storage`, put a `-` inside a part of an element name, write into `storage` from `on_load`.
3. **Always**: FR + EN comments, the file's line endings kept, annotations in the §10 format, a new class
   added to the registry **and** to `setup-classes.lua`, a new module added to `core/modules.lua`, a migration
   for every change of the `storage` structure.
4. Error inside a GUI handler: write it to the log (call stack included), not only to the chat.
5. Test in game (by hand, or with an RCON tool) before calling a task done; an out-of-game test sees neither the `require`
   restrictions nor the real API.

## See also

- [Full GUI pattern](gui-pattern.md) — GUI with RitnLib in detail.
- [4-layer architecture](../concepts/architecture-layers.md), [Temporary wrappers](../concepts/temporary-wrappers.md).
- [ADR-0004 — FR + EN strategy](../adr/0004-fr-en-strategy.md).
