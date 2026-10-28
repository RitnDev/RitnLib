---
name: ritn-mod-conventions
description: >
  Write or modify a Factorio 2.x mod that follows the Ritn mod conventions (RitnLib-based or standalone like
  gvv): path registry core/defines.lua, class factory and global temporary-wrapper classes, modules/*.lua
  returning { events = ... } for __core__ event_handler, GUI described in gui/*.lua with names
  gui_name-type-name and tags, FR + EN comments, LuaLS annotations (EN then FR, U+2500 line) written with the
  code, types/<mod>-globals.lua mirror. Use it whenever creating a new Ritn-style mod, adding a class / module /
  window / prototype to one, or when the mod depends on RitnLib — even if "convention" is not said.
  Écrire ou modifier un mod Factorio qui suit les conventions des mods Ritn.
---

# Ritn mod conventions

Apply the rules of `AGENTS.md` (same folder as this kit: `RitnLib/ai/AGENTS.md`, also copied to the root of
the mod). This skill adds **the order of work**, so that the code is final from the start (no later
annotation or audit pass needed).

## 1. Before writing

1. Find the variant: `info.json` depends on `RitnLib` → **with RitnLib**; otherwise **standalone**.
2. Read `core/defines.lua`, `core/setup-classes.lua`, `core/modules.lua`, and the class / `gui/` file
   closest to what you add. Copy their style (comment density, naming, annotation blocks).
3. New mod: start from `RitnLib/ai/template/<variant>/` (copy, then rename the placeholders `MyMod`,
   `mymod`, `__MyMod__` everywhere, including `info.json` and `types/`).

## 2. Adding something — checklist

| You add | Also update |
|---|---|
| a file | its path in `core/defines.lua` |
| a class | `core/setup-classes.lua` (after its parent), class block + cast, mirror in `types/<mod>-globals.lua` |
| a module | `core/modules.lua` |
| a window | `gui/<window>.lua` (getElement / getContent), the class, its actions; with RitnLib the `gui_action_<gui_name>` remote function |
| a `storage` key or structure change | `core/migrations.lua` (new version entry), `changelog.txt` |
| a prototype | `prototypes/<kind>.lua`, required by `data.lua` through the registry; locale entries |
| a setting | `settings.lua`, locale, `changelog.txt` |
| a structural change | `docs/architecture.md` (living doc) |

## 3. Writing

- Each function / method / class gets its **LuaLS block at creation** (format in `AGENTS.md`), each code block
  its **FR + EN comment**. Never leave them "for later".
- Keep the line endings of each file. Never reformat existing code you do not change.
- `require` only while `control.lua` loads; never inside a handler.

## 4. Checking

1. `luac -p` (or LuaLS diagnostics) on every changed file.
2. Every new global class is mirrored in `types/<mod>-globals.lua` with identical `@class` / `@field` / `@operator`.
3. In-game test when possible (by hand, or with RitnTest: https://github.com/RitnDev/RitnTest, local test game only), errors read from
   `factorio-current.log`.
4. Report to the user: what works, what failed and why; propose the commit message (the user commits).
