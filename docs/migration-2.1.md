---
title: Migration Factorio 2.1 / Factorio 2.1 migration
type: debt
lang: fr-en
---

# Migration Factorio 2.1

> 🇫🇷 **Français** ci-dessous · 🇬🇧 [English version](#factorio-21-migration) further down.

RitnLib est passée en `factorio_version = "2.1"` avec la **0.10.3**. Cette page recense ce que le passage en 2.1 a changé pour la bibliothèque. Elle est construite en croisant les sources avec `runtime-api.json` / `prototype-api.json` **2.1.17** et les **945 entrées** du `changelog.txt` officiel pour les versions 2.1.x.

Contrairement à [Migration 2.0](migration-2.0.md), la surface touchée est petite : deux cassages durs, tous deux corrigés, et deux résidus.

---

## 1. Corrigé — `LuaEntity::minable` (0.10.4)

`changelog.txt` [2.1.7] : *« Removed LuaEntity::minable write. Use LuaEntity::minable_flag instead. »*

`RitnLibEntity:setMinable()` écrivait `self.entity.minable`, désormais en lecture seule. Corrigé en **0.10.4** : la méthode vise `minable_flag`. `RitnLibEntity:destroy()`, qui appelle `setMinable()`, est réparé du même coup.

---

## 2. Corrigé — `data.raw.tool` (0.10.5)

`changelog.txt` [2.1.7] : *« TechnologyPrototype and LabPrototype now accept any item type as research ingredients. Changed all science packs to be plain items. »*

Les quatre méthodes « pack de science » de `RitnProtoTech` validaient leur argument en indexant `data.raw.tool` directement :

```lua
if data.raw.tool[pack] then            -- :addPack(), :replacePack()
if data.raw.tool[pack] == nil then     -- :addPackLab(), :removePackLab()
```

Le type de prototype `tool` **existe toujours** en 2.1 : un mod peut encore en définir un, et `data.raw.tool` devient alors une table. Ce qui a changé, c'est que plus rien dans le jeu de base n'en définit, donc sur un chargement 2.1 vanilla `data.raw.tool` vaut `nil` et l'indexer lève « attempt to index field 'tool' (a nil value) » au data stage. Le chargement s'arrête là : les quatre méthodes étaient inutilisables, et tout mod consommateur qui en appelait une refusait de démarrer.

Corrigé en **0.10.5** : la recherche passe par un helper local qui lit la table où la version courante range réellement le pack — `data.raw.tool` d'abord quand elle existe, `data.raw.item` ensuite. Le même code fonctionne donc sur 2.0, sur 2.1 vanilla, et sur une 2.1 où un autre mod a redéfini des packs en `type = "tool"`.

Aucune autre partie de la bibliothèque n'a besoin d'être touchée : les `unit.ingredients` d'une techno et les `inputs` d'un lab se désignent par nom d'item, et 2.1 y accepte n'importe quel type d'item.

---

## 3. À corriger — `probability` sur les produits de recette

`changelog.txt` [2.1.7] : *« Changed ProductPrototype into ProductPrototypeBase. Added `independent_probability`, replacing `ItemProductPrototype::probability` and `FluidProductPrototype::probability`. »*

Schéma 2.1.17 : ni `ItemProductPrototype` ni `FluidProductPrototype` n'exposent plus `probability`. La propriété est remontée sur `ProductPrototypeBase` sous deux formes :

- **`independent_probability`** — remplacement direct de l'ancien `probability` (tirage indépendant par produit).
- **`shared_probability`** — nouveauté : un tirage commun à plusieurs produits, exprimé en intervalle `{min, max}`.

### 3.1 Plantage potentiel — `lualib/vanilla/util.lua:561`

```lua
util.product_amount = function(product)
  return product.probability * (product.amount or ((product.amount_min + product.amount_max) / 2))
end
```

`product.probability` vaut désormais toujours `nil` → `nil * nombre` → « attempt to perform arithmetic on a nil value ».

Le `util.lua` **vanilla** de 2.1 a été réécrit pour cette rupture (`core/lualib/util.lua`) : il applique `extra_count_fraction`, puis `independent_probability`, puis `shared_probability` (via `max - min`). Le fork de RitnLib est resté sur la version 1.x.

- **Atténuation** : `util.product_amount` n'est appelée **nulle part** — ni dans RitnLib, ni dans RitnWaterfill, ni dans RitnCoreGame. La fonction est morte, donc inoffensive en l'état.
- **Migration** : réaligner le fork sur l'implémentation vanilla 2.1.

### 3.2 Perte silencieuse — `classes/RitnClass/RitnIngredient.lua`

La classe normalise vers `{name, type, amount, amount_min, amount_max, probability}` :

| Ligne | Rôle |
|---|---|
| 63 | `self.probability = ingredient.probability` — lecture depuis l'ingrédient source |
| 87 | `probability = self.probability` — construction du payload normalisé |
| 133 | `item.probability = ingredient.inputs.probability` — déjà cassé avant 2.1, cf. [bugs connus](debt/known-bugs.md) |
| 190-196 | `:combine()` — moyenne les `probability` des deux ingrédients |

Écrite dans les `results` d'une recette, la clé `probability` est maintenant **ignorée** : la probabilité disparaît sans erreur. Le chemin est vivant — `RitnProtoRecipe` utilise `RitnIngredient` (`classes/prototypes/Recipe.lua:208-271`).

- **Migration** : renommer en `independent_probability` sur le payload de sortie. La sémantique de moyennage de `:combine()` reste valable telle quelle.

### 3.3 Clé morte — `lualib/vanilla/ores.lua:295`

`probability = 1` dans les `results` de l'huile brute. Valeur neutre, donc aucun effet visible, mais la clé ne sert plus à rien.

---

## 4. Faux positifs écartés

Remontés par le croisement automatique avec le changelog, vérifiés et écartés :

| Piste | Entrée 2.1.x concernée | Pourquoi c'est un faux positif |
|---|---|---|
| `.active` — `classes/prototypes/Ore.lua:161` | `LuaEntity::active` write retiré | C'est `function RitnProtoOre.active(...)`, une méthode de la classe maison |
| `.inventory_size` — `classes/RitnClass/RitnInventory.lua` | `LuaItemPrototype::inventory_size` read retiré | Champ propre à `RitnLibInventory` (`= self.INVENTORY_SIZE_MAX`, 65535), passé à `game.create_inventory()` |
| `.loot` — `classes/LuaClass/RitnEvent.lua:225` | `EntityWithHealthPrototype::loot` changé en tableau | L'event `on_entity_died` porte toujours `loot` en 2.1.17 ; l'entrée visait le data stage |

---

## Voir aussi

- [Migration Factorio 2.0](migration-2.0.md)
- [Résidus API 1.x](debt/api-1.x-residuelle.md)
- [Bugs connus](debt/known-bugs.md)
- Sources : [API 2.1.17](https://lua-api.factorio.com/latest/), `data/changelog.txt` de l'install Factorio 2.1

<br>

═══════════════════════════════════════════════════════════════════════════

<a id="factorio-21-migration"></a>
# Factorio 2.1 migration

> 🇬🇧 **English** · 🇫🇷 [Version française](#migration-factorio-21) above.

RitnLib moved to `factorio_version = "2.1"` in **0.10.3**. This page lists what the move to 2.1 changed for the library. It is built by cross-checking the sources against `runtime-api.json` / `prototype-api.json` **2.1.17** and the **945 entries** of the official `changelog.txt` for the 2.1.x versions.

Unlike [2.0 migration](migration-2.0.md), the affected surface is small: two hard breaks, both already fixed, plus two leftovers.

---

## 1. Fixed — `LuaEntity::minable` (0.10.4)

`changelog.txt` [2.1.7]: *"Removed LuaEntity::minable write. Use LuaEntity::minable_flag instead."*

`RitnLibEntity:setMinable()` wrote to `self.entity.minable`, now read-only. Fixed in **0.10.4**: the method targets `minable_flag`. `RitnLibEntity:destroy()`, which calls `setMinable()`, is repaired along with it.

---

## 2. Fixed — `data.raw.tool` (0.10.5)

`changelog.txt` [2.1.7]: *"TechnologyPrototype and LabPrototype now accept any item type as research ingredients. Changed all science packs to be plain items."*

`RitnProtoTech`'s four science-pack methods validated their argument by indexing `data.raw.tool` directly:

```lua
if data.raw.tool[pack] then            -- :addPack(), :replacePack()
if data.raw.tool[pack] == nil then     -- :addPackLab(), :removePackLab()
```

The `tool` prototype type **still exists** in 2.1: a mod can define one, and `data.raw.tool` then becomes a table. What changed is that nothing in the base game defines one any more, so on a vanilla 2.1 load `data.raw.tool` is `nil` and indexing it raises "attempt to index field 'tool' (a nil value)" at the data stage. Loading stops there: the four methods were unusable, and any consumer mod that called one refused to start.

Fixed in **0.10.5**: the lookup goes through a local helper that reads whichever table the running version actually keeps the pack in — `data.raw.tool` first when it exists, `data.raw.item` next. The same code therefore works on 2.0, on vanilla 2.1, and on a 2.1 where another mod has redefined packs as `type = "tool"`.

Nothing else in the library needs touching: a technology's `unit.ingredients` and a lab's `inputs` name items, and 2.1 accepts any item type in both.

---

## 3. To fix — `probability` on recipe products

`changelog.txt` [2.1.7]: *"Changed ProductPrototype into ProductPrototypeBase. Added `independent_probability`, replacing `ItemProductPrototype::probability` and `FluidProductPrototype::probability`."*

2.1.17 schema: neither `ItemProductPrototype` nor `FluidProductPrototype` exposes `probability` any more. The property moved up to `ProductPrototypeBase` in two forms:

- **`independent_probability`** — direct replacement for the old `probability` (independent roll per product).
- **`shared_probability`** — new: a roll shared across several products, expressed as a `{min, max}` range.

### 3.1 Potential crash — `lualib/vanilla/util.lua:561`

```lua
util.product_amount = function(product)
  return product.probability * (product.amount or ((product.amount_min + product.amount_max) / 2))
end
```

`product.probability` is now always `nil` → `nil * number` → "attempt to perform arithmetic on a nil value".

The **vanilla** 2.1 `util.lua` was rewritten for this break (`core/lualib/util.lua`): it applies `extra_count_fraction`, then `independent_probability`, then `shared_probability` (via `max - min`). RitnLib's fork stayed on the 1.x version.

- **Mitigation**: `util.product_amount` is called **nowhere** — not in RitnLib, not in RitnWaterfill, not in RitnCoreGame. The function is dead, hence harmless as it stands.
- **Migration**: realign the fork with the vanilla 2.1 implementation.

### 3.2 Silent loss — `classes/RitnClass/RitnIngredient.lua`

The class normalises to `{name, type, amount, amount_min, amount_max, probability}`:

| Line | Role |
|---|---|
| 63 | `self.probability = ingredient.probability` — read from the source ingredient |
| 87 | `probability = self.probability` — building the normalised payload |
| 133 | `item.probability = ingredient.inputs.probability` — already broken before 2.1, see [known bugs](debt/known-bugs.en.md) |
| 190-196 | `:combine()` — averages both ingredients' `probability` |

Written into a recipe's `results`, the `probability` key is now **ignored**: the probability vanishes with no error. The path is live — `RitnProtoRecipe` uses `RitnIngredient` (`classes/prototypes/Recipe.lua:208-271`).

- **Migration**: rename to `independent_probability` on the output payload. `:combine()`'s averaging semantics stay valid as they are.

### 3.3 Dead key — `lualib/vanilla/ores.lua:295`

`probability = 1` in crude oil's `results`. A neutral value, so no visible effect, but the key no longer does anything.

---

## 4. Dismissed false positives

Raised by the automated cross-check against the changelog, verified and dismissed:

| Lead | Relevant 2.1.x entry | Why it is a false positive |
|---|---|---|
| `.active` — `classes/prototypes/Ore.lua:161` | `LuaEntity::active` write removed | It is `function RitnProtoOre.active(...)`, a method of the in-house class |
| `.inventory_size` — `classes/RitnClass/RitnInventory.lua` | `LuaItemPrototype::inventory_size` read removed | Own field of `RitnLibInventory` (`= self.INVENTORY_SIZE_MAX`, 65535), passed to `game.create_inventory()` |
| `.loot` — `classes/LuaClass/RitnEvent.lua:225` | `EntityWithHealthPrototype::loot` changed to an array | The `on_entity_died` event still carries `loot` in 2.1.17; the entry targeted the data stage |

---

## See also

- [Factorio 2.0 migration](migration-2.0.md)
- [1.x API leftovers](debt/api-1.x-leftover.md)
- [Known bugs](debt/known-bugs.en.md)
- Sources: [2.1.17 API](https://lua-api.factorio.com/latest/), `data/changelog.txt` from the Factorio 2.1 install
