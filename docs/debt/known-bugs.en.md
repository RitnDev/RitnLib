---
title: Known bugs
type: debt
lang: en
---

# Known bugs


> This page cross-checks the `⚠` warnings in the LuaLS annotations against **actual usage** in the consumer mods (RitnMenuButton, RitnLobbyGame, RitnCoreGame, RitnBaseGame, RitnLeaderboard, RitnPortal, RitnTeleporter). Only the code defects that survive that check are listed. **Most are latent**: they sit on paths the current mods don't exercise — RitnLib runs fine in production.

What is **not** a bug (and therefore not here):

- **Extension-contract points** — a base class deliberately leaves a field empty, the subclass fills it. E.g. `RitnLibGui` leaves `self.gui[1]` empty (provided by the subclass + the `gui_action_*` remote interface) — a pattern proven in production (RitnLobbyGame, RitnMenuButton, RitnCharacters). That is **design**, not a defect.
- **Factorio 1.x API residue** (`getStats*` statistics, `created_entity`, `hr_version`…) → see [Factorio 2.0 migration](../migration-2.0.md).
- **Deprecated but working APIs** → see [Deprecated APIs](deprecated.md).
- **Intentional usage caveats** (silent `pcall`, eager `ifElse`, Lua patterns in `startsWith`…) — documented in the LuaLS tooltips.

---

## Confirmed latent defects

Genuine code defects (verified in source), but on paths **not exercised** by the current consumer mods — so nothing crashes today.

| Class / method | File | Mechanism | Status |
|---|---|---|---|
| `RitnLibEntity:getSurface()` · `:getForce()` | `classes/LuaClass/RitnEntity.lua` | Call `RitnlibSurface(...)` / `RitnlibForce(...)` — wrong casing (lowercase `lib`), undefined globals → would crash **if called**. Not called: the `getSurface`/`getForce` used in production are `RitnLibPlayer`/`RitnLibEvent`'s (correctly cased). | R1 |
| `RitnLibForce:getStats*` | `classes/LuaClass/RitnForce.lua` | `self.stats` is commented out (1.x statistics API → 2.0 migration), so these methods error on a base instance (`self.stats` nil). Implementation **incomplete**: the only intended consumer (RitnLeaderboard, which rebuilds `self.stats`) is still in development, unreleased. API cause detailed in [migration 2.0](../migration-2.0.md). | R1/R2 |
| `RitnLibGuiElement:text()` | `classes/RitnClass/gui/RitnGuiElement.lua` | Tests `type(tooltip)` (undefined variable) instead of `type(text)` → the body never runs, text is never applied. Silent. Not exercised (consumers use `:caption()` / `:tooltip()`). | — |
| `RitnLibStyle:straitFrame()` | `classes/RitnClass/gui/RitnStyle.lua` | Calls `self:standardFrame()` (nonexistent) → exception **if called**. Consumers use `:frame()`, `:menuButton()`, etc. (which work). | — |
| `RitnLibStyle:visible()` | `classes/RitnClass/gui/RitnStyle.lua` | The `log` line concatenates `self.gui_name`, never defined on `RitnLibStyle` → exception **if called**. | — |

## Minor side effect

| Class / method | File | Detail |
|---|---|---|
| `RitnLibSurface:getEntity()` | `classes/LuaClass/RitnSurface.lua` | Writes its result to the **global** variable `LuaEntity` (no `local`) — pollutes `_G` and shadows the built-in type name. **Works** (used in production by RitnPortal, the result is returned correctly); side effect to clean up in a refactor. |
| `spairs` · `clearOutput` (other-functions) · `pairs_concat` (table-functions) | `lualib/other-functions.lua`, `lualib/table-functions.lua` | Declared in the module's `@field` list but never defined → always `nil`. Misleading API surface (autocomplete offers them, they don't exist at runtime). |

## Beta / unfinished code

Not counted as production bugs — explicitly work-in-progress.

| Class / method | File | Detail |
|---|---|---|
| `RitnLibInformatron:getElement()` · `:setPageContent()` | `classes/RitnClass/RitnInformatron.lua` | `getElement` reads `self.gui[self.gui_name]` while the constructor stores the root under `[1]`; `setPageContent` returns the undefined global `FLAG_PAGE_DISPLAY` (typo). Class marked `-- beta` in `defines.lua`, exercised by no mod. |
| `RitnLibSetting` | `classes/RitnClass/RitnSetting.lua` | **Unfinished class** (work in progress). `:getType()` / `:new()` don't produce a valid setting: the `self.TYPE[self.dataType]` chain dereferences with mismatched key casing (UPPERCASE keys vs lowercase value). Don't use as-is — see [RitnLibSetting](../reference/settings/RitnLibSetting.md). |

## Fixed

| Version | Class / method | Defect |
|---|---|---|
| 0.10.5 | `RitnIngredient` — `getItem()` helper | Read `ingredient.inputs.probability` (nonexistent sub-table) → "attempt to index a nil value". Also crashed on an item entry defined with `amount_min` / `amount_max` only. |
| 0.10.5 | `RitnPrototype:getItemType()` · `:getEntityType()` | Crashed when a list type has no prototype in `data.raw` (e.g. `item-with-label` in 2.1). |
| 0.10.5 | `RitnProtoOre:remove()` | Left the ore in the planets' `map_gen_settings` → crash at planet setup. |
| 0.10.5 | `RitnProtoOre.active()` (`bStandard = true`) | The local `resource()` helper was shadowed by the `resource` parameter → called a string. |
| 0.10.5 | `RitnProtoTech:addPack()` | Errored on a technology without `unit` (research trigger). |
| 0.10.5 | `util.product_amount()` | Crashed on a product without `probability`. |
| 0.10.4 | `RitnLibEntity:setMinable()` | `LuaEntity::minable` became read-only in 2.1.7 → now writes `minable_flag`. |

## See also

- [Factorio 2.0 migration](../migration-2.0.md) — 1.x API residue (`getStats*`/statistics, `created_entity`, `hr_version`…)
- [1.x API leftovers](api-1.x-leftover.md) — dead prototype keys (`icon_mipmaps`, `hide_from_player_stats`…)
- [Factorio 2.1 migration](../migration-2.1.md) — `minable_flag`, `independent_probability`, `categories`
- [Deprecated APIs](deprecated.md)
- [Class map](../reference/overview.md)
