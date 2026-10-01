---
title: 1.x API leftovers
type: reference
lang: en
---

# 1.x API leftovers

> Companion to [Factorio 2.0 migration](../migration-2.0.md), which covers the **structural** leftovers (statistics API, `created_entity`, `RitnProto*` classes). This page lists the **dead prototype keys**: properties Factorio removed that the code still writes.
>
> Nature of the risk: Factorio **silently ignores** unknown prototype keys. None of these lines raise a load error — they simply stopped doing anything. That is what makes them invisible without a static audit.

Compiled by cross-checking the sources against `prototype-api.json` 2.1.17 and the game's official `changelog.txt`.

---

## 1. `icon_mipmaps` — 27 occurrences

Removed in 2.0: *"Removed icon_mipmaps from various prototypes using icons. Mipmap count will be inferred from `icon_size` and actual dimensions of the source image."*

| File | Lines |
|---|---|
| `classes/prototypes/Ore.lua` | 121 |
| `lualib/vanilla/ores.lua` | 168, 272, 426 |
| `lualib/vanilla/util.lua` | 335, 369-534 (20 occurrences across the icon templates) |

- **Impact**: none. The mipmap count is now derived from the image's actual width compared to `icon_size`, which is more reliable than the declared value.
- **Migration**: plain removal. `lualib/vanilla/util.lua:335` (`icon.icon_mipmaps = icon_to_add.icon_mipmaps`) copies the key inside an icon-merging helper — drop it too.

## 2. `hr_version` — wider reach than documented

[2.0 migration §1.3](../migration-2.0.md) only names `lualib/other-functions`. The legacy layout is in fact also present in:

| File | Lines |
|---|---|
| `classes/prototypes/Ore.lua` | 155 |
| `lualib/vanilla/ores.lua` | 206, 230, 327 |
| `lualib/vanilla/util.lua` | 159-160, 579-580 (helpers that *walk* `hr_version`) |

The two `vanilla/util.lua` helpers traverse the key to apply recursive processing: they become dead branches once `hr_version` is removed, not bugs.

## 3. `hide_from_player_stats` — never existed

`classes/prototypes/Recipe.lua` lines **144, 156, 168, 179** (`setHidden` method).

The correct `RecipePrototype` property is **`hide_from_stats`**. `hide_from_player_stats` appears in no version of the schema — so `setHidden()`'s `stats` parameter has **never done anything**, silently.

- **Migration**: rename to `hide_from_stats`. Careful: this **activates** behaviour that has been inert until now — test it on the affected recipes.
- Correct neighbours, properly used: `hide_from_player_crafting`, `hidden`.

## 4. `hardness` — `lualib/vanilla/ores.lua:433`

`minable.hardness` disappeared from `ResourceEntityPrototype` back in 0.17. Dead key, no impact.

## 5. `LuaStyle.visible` — `classes/RitnClass/gui/RitnStyle.lua:332`

`RitnLibStyle:visible()` writes `self.style.visible`. `LuaStyle` exposes no `visible` — it is a member of `LuaGuiElement`, not of its style.

[Known bugs](known-bugs.en.md) already lists this method, but for a **different** cause (the `log` call concatenates `self.gui_name`, never defined, which raises before reaching the line). Both defects should be fixed together: the method must target the element, not the style.

---

## See also

- [Factorio 2.0 migration](../migration-2.0.md) — structural leftovers
- [Factorio 2.1 migration](../migration-2.1.md) — leftovers introduced by the move to 2.1
- [Known bugs](known-bugs.en.md)
- [Deprecated APIs](deprecated.en.md)
