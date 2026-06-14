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
| `RitnIngredient` — `getItem()` helper | `classes/RitnClass/RitnIngredient.lua:109` | On the probability branch, reads `ingredient.inputs.probability` (nonexistent sub-table) → "attempt to index a nil value". No usage found in consumer mods — **unconfirmed**. | to verify |

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

## See also

- [Factorio 2.0 migration](../migration-2.0.md) — 1.x API residue (`getStats*`/statistics, `created_entity`, `hr_version`…)
- [Deprecated APIs](deprecated.md)
- [Class map](../reference/overview.md)
