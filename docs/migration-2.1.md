---
title: Migration Factorio 2.1 / Factorio 2.1 migration
type: debt
lang: fr-en
---

# Migration Factorio 2.1

> 🇫🇷 **Français** ci-dessous · 🇬🇧 [English version](#factorio-21-migration) further down.

RitnLib est passée en `factorio_version = "2.1"` avec la **0.10.3**. Cette page recense ce que le passage en 2.1 a changé pour la bibliothèque. Elle est construite en croisant les sources avec `runtime-api.json` / `prototype-api.json` **2.1.17** et les **945 entrées** du `changelog.txt` officiel pour les versions 2.1.x.

Contrairement à [Migration 2.0](migration-2.0.md), la surface touchée est petite. Depuis la **0.10.5**, tous les points relevés sont corrigés ; il ne reste qu'une clé morte sans effet (`setHidden`, cf. §5).

---

## 1. Corrigé — `LuaEntity::minable` (0.10.4)

`changelog.txt` [2.1.7] : *« Removed LuaEntity::minable write. Use LuaEntity::minable_flag instead. »*

`RitnLibEntity:setMinable()` écrivait `self.entity.minable`, désormais en lecture seule. Corrigé en **0.10.4** : la méthode vise `minable_flag`. `RitnLibEntity:destroy()`, qui appelle `setMinable()`, est réparé du même coup.

---

## 2. Corrigé — `probability` → `independent_probability` (0.10.5)

`changelog.txt` [2.1.7] : *« Changed ProductPrototype into ProductPrototypeBase. Added `independent_probability`, replacing `ItemProductPrototype::probability` and `FluidProductPrototype::probability`. »*

Schéma 2.1.17 : ni `ItemProductPrototype` ni `FluidProductPrototype` n'exposent plus `probability`. La propriété est remontée sur `ProductPrototypeBase` sous deux formes :

- **`independent_probability`** — remplacement direct de l'ancien `probability` (tirage indépendant par produit).
- **`shared_probability`** — nouveauté : un tirage commun à plusieurs produits, exprimé en intervalle `{min, max}`.

Écrite dans les `results` d'une recette, l'ancienne clé était **ignorée sans erreur**. Corrections apportées en **0.10.5** :

| Emplacement | Avant | Après |
|---|---|---|
| [`RitnIngredient`](reference/prototype/RitnIngredient.md) | normalisait vers `probability` | écrit `independent_probability` ; l'ancienne clé `probability` reste acceptée en entrée. Les champs annexes de l'entrée (`temperature`, `extra_count_fraction`…) sont désormais conservés. |
| `RitnIngredient` — helper `getItem()` | lisait `ingredient.inputs.probability` (sous-table inexistante) | lit `independent_probability` ou `probability` |
| `lualib/vanilla/util.lua` — `util.product_amount()` | `product.probability * amount` → plantage si `nil` | réaligné sur le `util.lua` vanilla 2.1 : `extra_count_fraction`, puis `independent_probability`, puis `shared_probability` (`max - min`) |
| `lualib/vanilla/ores.lua` — huile brute | `probability = 1` | `independent_probability = 1` |

Les nouvelles méthodes [`RitnProtoRecipe`](reference/prototype/RitnProtoRecipe.md) `:addResult()` / `:removeResult()` / `:setResult()` passent par `RitnIngredient` et écrivent donc directement la bonne clé.

---

## 3. Nouveau — catégories de recette (0.10.5)

En 2.1, `RecipePrototype` utilise la liste **`categories`** à la place des clés `category` / `additional_categories`. [`RitnProtoRecipe`](reference/prototype/RitnProtoRecipe.md) expose :

- `:setCategories(categories)` — remplace la liste et supprime les clés legacy si présentes ;
- `:addCategory(category)` — ajoute une catégorie, en partant de `{"crafting"}` si la recette n'en a pas.

---

## 4. Corrigé — listes de types et `data.raw` (0.10.5)

- `RitnPrototype:getItemType()` / `:getEntityType()` plantaient quand un type de la liste n'existe plus dans `data.raw` (ex : `item-with-label` en 2.1). Les types absents sont désormais ignorés. Même comportement pour le nouveau `:getEquipmentType()`.
- `lualib/vanilla/types_item.lua` : ajout de `space-platform-starter-pack`, retrait de `mining-tool`, `tool` remonté dans la liste. `types_entity.lua` aligné sur les types 2.x. Nouvelle liste `types_equipment.lua`. Voir [Listes de types](reference/vanilla/types.md).

> Les corrections de [`RitnProtoOre`](reference/prototype/RitnProtoOre.md) liées aux planètes (`active()` avec `planets`, `remove()` qui nettoie le `map_gen_settings` des planètes) relèvent du modèle de planètes introduit en **2.0** : elles sont décrites dans la page de la classe.

---

## 5. Reste — clé morte dans `setHidden()`

`RitnProtoRecipe:setHidden(value, crafting, stats)` écrit `hide_from_player_stats`, qui n'existe dans aucune version du schéma (la clé correcte est `hide_from_stats`). Le paramètre `stats` est donc sans effet. Pas lié à 2.1 : voir [Résidus API 1.x](debt/api-1.x-leftover.md).

---

## 6. Faux positifs écartés

Remontés par le croisement automatique avec le changelog, vérifiés et écartés :

| Piste | Entrée 2.1.x concernée | Pourquoi c'est un faux positif |
|---|---|---|
| `.active` — `classes/prototypes/Ore.lua` | `LuaEntity::active` write retiré | C'est `function RitnProtoOre.active(...)`, une méthode de la classe maison |
| `.inventory_size` — `classes/RitnClass/RitnInventory.lua` | `LuaItemPrototype::inventory_size` read retiré | Champ propre à `RitnLibInventory` (`= self.INVENTORY_SIZE_MAX`, 65535), passé à `game.create_inventory()` |
| `.loot` — `classes/LuaClass/RitnEvent.lua:225` | `EntityWithHealthPrototype::loot` changé en tableau | L'event `on_entity_died` porte toujours `loot` en 2.1.17 ; l'entrée visait le data stage |

---

## Voir aussi

- [Migration Factorio 2.0](migration-2.0.md)
- [Résidus API 1.x](debt/api-1.x-leftover.md)
- [Bugs connus](debt/known-bugs.md)
- Sources : [API 2.1.17](https://lua-api.factorio.com/latest/), `data/changelog.txt` de l'install Factorio 2.1

<br>

═══════════════════════════════════════════════════════════════════════════

<a id="factorio-21-migration"></a>
# Factorio 2.1 migration

> 🇬🇧 **English** · 🇫🇷 [Version française](#migration-factorio-21) above.

RitnLib moved to `factorio_version = "2.1"` in **0.10.3**. This page lists what the move to 2.1 changed for the library. It is built by cross-checking the sources against `runtime-api.json` / `prototype-api.json` **2.1.17** and the **945 entries** of the official `changelog.txt` for the 2.1.x versions.

Unlike [2.0 migration](migration-2.0.md), the affected surface is small. Since **0.10.5**, every item found is fixed; only one dead key with no effect remains (`setHidden`, see §5).

---

## 1. Fixed — `LuaEntity::minable` (0.10.4)

`changelog.txt` [2.1.7]: *"Removed LuaEntity::minable write. Use LuaEntity::minable_flag instead."*

`RitnLibEntity:setMinable()` wrote to `self.entity.minable`, now read-only. Fixed in **0.10.4**: the method targets `minable_flag`. `RitnLibEntity:destroy()`, which calls `setMinable()`, is repaired along with it.

---

## 2. Fixed — `probability` → `independent_probability` (0.10.5)

`changelog.txt` [2.1.7]: *"Changed ProductPrototype into ProductPrototypeBase. Added `independent_probability`, replacing `ItemProductPrototype::probability` and `FluidProductPrototype::probability`."*

2.1.17 schema: neither `ItemProductPrototype` nor `FluidProductPrototype` exposes `probability` any more. The property moved up to `ProductPrototypeBase` in two forms:

- **`independent_probability`** — direct replacement for the old `probability` (independent roll per product).
- **`shared_probability`** — new: a roll shared across several products, expressed as a `{min, max}` range.

Written into a recipe's `results`, the old key was **silently ignored**. Fixes made in **0.10.5**:

| Location | Before | After |
|---|---|---|
| [`RitnIngredient`](reference/prototype/RitnIngredient.en.md) | normalised to `probability` | writes `independent_probability`; the legacy `probability` key is still accepted as input. The entry's extra fields (`temperature`, `extra_count_fraction`…) are now kept. |
| `RitnIngredient` — `getItem()` helper | read `ingredient.inputs.probability` (nonexistent sub-table) | reads `independent_probability` or `probability` |
| `lualib/vanilla/util.lua` — `util.product_amount()` | `product.probability * amount` → crash if `nil` | realigned with the vanilla 2.1 `util.lua`: `extra_count_fraction`, then `independent_probability`, then `shared_probability` (`max - min`) |
| `lualib/vanilla/ores.lua` — crude oil | `probability = 1` | `independent_probability = 1` |

The new [`RitnProtoRecipe`](reference/prototype/RitnProtoRecipe.en.md) methods `:addResult()` / `:removeResult()` / `:setResult()` go through `RitnIngredient` and therefore write the right key directly.

---

## 3. New — recipe categories (0.10.5)

In 2.1, `RecipePrototype` uses the **`categories`** list instead of the `category` / `additional_categories` keys. [`RitnProtoRecipe`](reference/prototype/RitnProtoRecipe.en.md) provides:

- `:setCategories(categories)` — replaces the list and clears the legacy keys if present;
- `:addCategory(category)` — appends a category, starting from `{"crafting"}` if the recipe has none.

---

## 4. Fixed — type lists and `data.raw` (0.10.5)

- `RitnPrototype:getItemType()` / `:getEntityType()` crashed when a list type no longer exists in `data.raw` (e.g. `item-with-label` in 2.1). Missing types are now skipped. Same behaviour for the new `:getEquipmentType()`.
- `lualib/vanilla/types_item.lua`: added `space-platform-starter-pack`, removed `mining-tool`, `tool` moved up the list. `types_entity.lua` aligned with the 2.x types. New `types_equipment.lua` list. See [Type lists](reference/vanilla/types.en.md).

> The planet-related [`RitnProtoOre`](reference/prototype/RitnProtoOre.en.md) fixes (`active()` with `planets`, `remove()` cleaning the planets' `map_gen_settings`) belong to the planet model introduced in **2.0**: they are described on the class page.

---

## 5. Remaining — dead key in `setHidden()`

`RitnProtoRecipe:setHidden(value, crafting, stats)` writes `hide_from_player_stats`, which exists in no version of the schema (the correct key is `hide_from_stats`). The `stats` parameter therefore has no effect. Not related to 2.1: see [1.x API leftovers](debt/api-1.x-leftover.md).

---

## 6. Dismissed false positives

Raised by the automated cross-check against the changelog, verified and dismissed:

| Lead | Relevant 2.1.x entry | Why it is a false positive |
|---|---|---|
| `.active` — `classes/prototypes/Ore.lua` | `LuaEntity::active` write removed | It is `function RitnProtoOre.active(...)`, a method of the in-house class |
| `.inventory_size` — `classes/RitnClass/RitnInventory.lua` | `LuaItemPrototype::inventory_size` read removed | Own field of `RitnLibInventory` (`= self.INVENTORY_SIZE_MAX`, 65535), passed to `game.create_inventory()` |
| `.loot` — `classes/LuaClass/RitnEvent.lua:225` | `EntityWithHealthPrototype::loot` changed to an array | The `on_entity_died` event still carries `loot` in 2.1.17; the entry targeted the data stage |

---

## See also

- [Factorio 2.0 migration](migration-2.0.md)
- [1.x API leftovers](debt/api-1.x-leftover.md)
- [Known bugs](debt/known-bugs.en.md)
- Sources: [2.1.17 API](https://lua-api.factorio.com/latest/), `data/changelog.txt` from the Factorio 2.1 install
