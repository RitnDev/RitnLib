---
title: RitnLibInventory
type: reference
lang: fr
---

# `RitnLibInventory`

🇬🇧 [English version](../../../en/reference/runtime/RitnLibInventory.md)

Helper de **snapshot / restauration** d'inventaire joueur, basé sur `game.create_inventory`. RitnLib fournit la logique ; **la persistance appartient au mod consommateur** : tu passes une table externe (typiquement un `storage.X`) où les snapshots sont stockés. Pratique pour sauvegarder un inventaire avant un changement de personnage/surface puis le restaurer à l'identique (curseur compris).

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnInventory.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **`object_name`** | `"RitnLibInventory"` |

---

## Constructeur

#### `RitnLibInventory(player, inventoryGlobal)` → [`RitnLibInventory`](RitnLibInventory.md)

Valide le joueur (doit être un `LuaPlayer` valide **avec un `character`**) et exige une table `inventoryGlobal` non-nil. Stocke la référence vers cette table dans [`data`](#data--tablestring-table-read).

**Paramètres**
- `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html) — joueur dont on gère l'inventaire.
- `inventoryGlobal` :: `table` — table de persistance fournie par le consommateur (les snapshots y sont écrits, indexés par nom de joueur).

> **Avertissement** — Wrapper temporaire : ne stocke **jamais** l'instance `RitnLibInventory` dans `storage`. Seule la table `inventoryGlobal` est persistante.

---

## Structure de persistance attendue

Sous la clé du joueur, `init()` crée :

```lua
inventoryGlobal["<nom_joueur>"] = {
    [defines.inventory.character_main]  = LuaInventory,
    [defines.inventory.character_guns]  = LuaInventory,
    [defines.inventory.character_ammo]  = LuaInventory,
    [defines.inventory.character_armor] = LuaInventory,
    [defines.inventory.character_trash] = LuaInventory,
    ["cursor"]          = LuaInventory,   -- 1 slot
    ["logistic_param"]  = { … },
}
```

---

## Attributs

#### `data` :: `table<string, table>` `[Read]`
Référence vers la table `inventoryGlobal` du consommateur (persistante).

#### `player` :: [`LuaPlayer`](https://lua-api.factorio.com/latest/classes/LuaPlayer.html) `[Read]`
Joueur encapsulé (référence vivante).

#### `name` :: `string` `[Read]`
Nom du joueur — sert de clé dans [`data`](#data--tablestring-table-read).

#### `INVENTORY_SIZE_MAX` :: `65535` `[Read]`
Taille maximale passée à `game.create_inventory`.

#### `inventory_size` :: `integer` `[Read]`
Taille effective utilisée par [`:init()`](#init--ritnlibinventory) (défaut `INVENTORY_SIZE_MAX`).

---

## Méthodes — maîtres (usage courant)

#### `:save(cursor?)` → [`RitnLibInventory`](RitnLibInventory.md)
Snapshot des 5 inventaires character. Si `cursor == true`, sauvegarde aussi le curseur. Auto-init si nécessaire.

#### `:load(cursor?)` → [`RitnLibInventory`](RitnLibInventory.md)
Restaure les 5 inventaires character (armure en premier, intentionnel). Si `cursor == true`, restaure aussi le curseur (via la symétrie de `swap_stack`). No-op si aucun snapshot.

#### `:insert()` → [`RitnLibInventory`](RitnLibInventory.md)
Ré-injecte le snapshot dans le joueur courant via `LuaPlayer.insert` (armure/main/guns/ammo, **sans** trash). Ne vide pas le snapshot.

#### `:delete()` → [`RitnLibInventory`](RitnLibInventory.md)
Vide les 5 inventaires character **et** le curseur sur le joueur courant.

#### `:init()` → [`RitnLibInventory`](RitnLibInventory.md)
Crée le dict de snapshot du joueur si absent. Appelé automatiquement par `:save`/`:saveCursor`/`:saveInventory`.

---

## Méthodes — par lot

| Méthode | Effet |
|---|---|
| `:save_all_inventory()` | snapshot des 5 inventaires character |
| `:load_all_inventory()` | restaure les 5 (armure d'abord) |
| `:insert_all_inventory()` | insère armure/main/guns/ammo (sans trash) |
| `:delete_all_inventory()` | vide les 5 inventaires character |

---

## Méthodes — par slot

Chacune prend un `define :: defines.inventory` et renvoie `self`.

| Méthode | Effet |
|---|---|
| `:saveInventory(define)` | snapshot le slot via `swap_stack` (auto-init) |
| `:loadInventory(define)` | restaure le slot depuis le snapshot |
| `:insertInventory(define)` | `LuaPlayer.insert` chaque stack du snapshot |
| `:deleteInventory(define)` | vide le slot sur le joueur |

---

## Méthodes — curseur

| Méthode | Effet |
|---|---|
| `:saveCursor()` | échange `cursor_stack` ↔ snapshot `["cursor"]` (`swap_stack`) |
| `:loadCursor()` | restaure le curseur depuis le snapshot |
| `:deleteCursor()` | vide le `cursor_stack` du joueur |

> **Note** — `swap_stack` est symétrique (son propre inverse) : c'est ce qui permet à la paire `:save(true)` / `:load(true)` de restaurer correctement le curseur.

---

## Exemple d'usage

**Sauver puis restaurer autour d'un changement de personnage** (`RitnCharacters/classes/RitnCharacter.lua`) :

```lua
local inventories = {}
local rInventory = RitnLibInventory(self.player, inventories)
rInventory:save(true)        -- snapshot inventaires + curseur

-- … destruction et recréation du personnage …

rInventory:load(true)        -- restauration à l'identique
```

> Ici la table de persistance est locale à l'opération (snapshot puis restauration dans le même appel). Pour une persistance inter-tick, passe un `storage.X`.

---

## Remarques

- **Persistance déléguée** — RitnLib ne possède pas la table de snapshots ; tu fournis la tienne. Voir [Persistance déléguée](../../concepts/persistance-deleguee.md).
- **Wrapper temporaire** — ne jamais stocker l'instance dans `storage` ; seule `inventoryGlobal` l'est.
- **`character` requis** — le constructeur retourne tôt si le joueur n'a pas de `character` (contrôleurs god/editor).

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibPlayer`](RitnLibPlayer.md)
- [Persistance déléguée](../../concepts/persistance-deleguee.md) · [Wrappers temporaires](../../concepts/wrappers-temporaires.md)
