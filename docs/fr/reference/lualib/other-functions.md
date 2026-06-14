---
title: lualib/other-functions
type: reference
lang: fr
---

# `lualib/other-functions`

🇬🇧 [English version](../../../en/reference/lualib/other-functions.md)

Module utilitaire « divers ». Son membre central est **`type`** — le résolveur de type étendu (basé sur `object_name`) utilisé par **toutes** les classes wrapper de RitnLib pour valider leurs entrées. Contient aussi des helpers de contrôle de flux, d'items, de debug et de sérialisation.

| | |
|---|---|
| **Source** | `lualib/other-functions.lua` |
| **Type** | module de fonctions (table retournée) |
| **Accès** | `local util = require(ritnlib.defines.other)` |

---

## Type & contrôle de flux

#### `type(value)` → `string`
Résolveur de type **étendu** : comme `type()` natif, mais reconnaît en plus les objets Factorio (`"LuaPlayer"`, `"LuaEntity"`, `"LuaSurface"`…) et les classes RitnLib via leur `object_name`. C'est la base de toutes les gardes de constructeur (`util.type(x) ~= "LuaPlayer"`…).

**Paramètres** : `value` :: `any`.

#### `isType(value, pType)` → `boolean`
`true` si `type(value) == pType`.

#### `ifElse(Condition, Then, Else)` → `any`
Renvoie `Then` si `Condition` est vraie, sinon `Else`.

> **Avertissement** — Ce n'est pas un vrai ternaire : `Then` **et** `Else` sont **tous deux évalués** à l'appel (Lua évalue les arguments). Ne pas y passer d'expressions à effets de bord.

#### `tryCatch(funcTry, funcCatch?)`
Exécute `funcTry` ; en cas d'erreur, appelle `funcCatch` si fourni.

---

## Chaînes & tables

#### `split(inputstr, sep?)` → `string[]`
Découpe `inputstr` selon le séparateur `sep`.

#### `str_start(str, start)` → `boolean`
`true` si `str` commence par `start`.
> **Avertissement** — **Déprécié** — utiliser [`string-functions.startsWith`](string-functions.md) à la place.

#### `getn(tab?)` → `number`
Nombre d'éléments d'une table (nil-safe).

---

## Items

#### `give_item(LuaPlayer, item)` · `give_item_list(LuaPlayer, items)`
Donne un item (ou une liste d'items) à un joueur.

**Paramètres** : `LuaPlayer` :: `LuaPlayer` · `item` :: `table` / `items` :: `table[]`.

---

## Sérialisation & ids

#### `table_to_json(table)` → `string`
Sérialisation JSON rapide d'une table.
> **Avertissement** — Pas d'échappement des caractères spéciaux, pas de support des arrays (tout est sérialisé comme objet). Pour du JSON robuste, utiliser [`json-functions`](json-functions.md).

#### `uuid()` → `string`
Génère un identifiant unique.
> **Note** — Basé sur le `math.random` de Factorio (déterministe par seed, synchronisé en multijoueur) : les UUID sont **reproductibles entre clients** (sûr pour le déterminisme, **pas** cryptographiquement aléatoire).

---

## Debug

#### `ritnPrint(txt)` · `ritnLog(txt)`
Helpers de debug personnels.
> **Avertissement** — `ritnPrint` plante s'il n'existe aucun joueur nommé « Ritn ». Ne pas utiliser dans du code consommateur livré.

---

## Output & remote

#### `writeToOutput(output, appendContent?)` → `string?` · `writeToProductionStats(identifierer, appendContent)`
Écriture vers des fichiers de sortie (`script-output`).
> **Avertissement** — Dépendent de globals que **le consommateur doit définir** avant l'appel, sinon erreur de concaténation `nil`.

#### `callRemoteFreeplay(function_call, value?)`
Appelle une fonction de l'interface remote freeplay.

#### `build_clock_string(time)` → `string`
Formate un nombre de ticks/secondes en horloge lisible.

---

## Prototypes graphiques (legacy)

#### `assembler1pipepictures(path)` · `pipecoverspictures(path)` → `table` · `addFluidBoxes(entity)` → `table?`
Helpers de prototypes graphiques (data stage).
> **Avertissement — 1.x** — `assembler1pipepictures` / `pipecoverspictures` utilisent le layout sprite `hr_version` (1.x), **ignoré en 2.0**. Voir [Migration Factorio 2.0](../../../migration-2.0.md).

---

## Membres toujours `nil`

> **Avertissement** — `spairs` et `clearOutput` sont **exportés mais jamais définis** → toujours `nil`. Surface d'API trompeuse. Voir [bugs connus](../../debt/known-bugs.md).

---

## Exemple d'usage

```lua
local util = require(ritnlib.defines.other)

if util.type(entity) ~= "LuaEntity" then return end   -- garde standard
local id = util.uuid()
local parts = util.split("a.b.c", ".")
```

## Voir aussi

- [Carte des classes](../overview.md)
- [`string-functions`](string-functions.md) · [`table-functions`](table-functions.md) · [`json-functions`](json-functions.md)
- [Bugs connus](../../debt/known-bugs.md) · [Migration 2.0](../../../migration-2.0.md)
