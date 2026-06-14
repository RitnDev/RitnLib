---
title: RitnPrototype
type: reference
lang: fr
---

# `RitnPrototype`


Classe de **base** de tous les manipulateurs de prototypes `RitnProto*` (data stage). Elle encapsule une entrée `data.raw[<type>][<name>]` dans `self.prototype` et fournit les mutateurs génériques *mutate-and-write* (`:changePrototype`, `:setPrototype`, `:update`…). On ne l'instancie en général pas directement : on utilise une sous-classe ([`RitnProtoRecipe`](RitnProtoRecipe.md), [`RitnProtoTech`](RitnProtoTech.md)…).

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnPrototype.lua` |
| **Stage** | data |
| **Accès** | `require(ritnlib.defines.class.ritnClass.prototype)` |
| **Hérite de** | — (classe de base) |
| **Étendue par** | tous les `RitnProto*` (sauf `RitnProtoRecipeCategory`, déclarée sans héritage) |
| **`object_name`** | `"RitnProtoBase"` |

---

## Constructeur

#### `RitnPrototype(name, type)` → [`RitnPrototype`](RitnPrototype.md)

Pose `object_name`, `name`, `type`, et laisse `prototype` à `nil`. Les sous-classes appellent `RitnPrototype.init(base, name, type)` puis **deep-copient** `data.raw[type][name]` dans `prototype`.

**Paramètres**
- `name` :: `string` — nom du prototype.
- `type` :: `string` — type résolu (`"recipe"`, `"item"`, `"assembling-machine"`…).

---

## Attributs

#### `name` :: `string` `[Read]`
Nom du prototype.

#### `type` :: `string` `[Read]`
Type résolu. Peut être mis à jour par [`:getItemType()`](#getitemtype--string) / [`:getEntityType()`](#getentitytype--string).

#### `prototype` :: `table?` `[Read]`
Copie de travail de `data.raw[type][name]` (posée par la sous-classe). `nil` si l'entrée n'existe pas.

#### `object_name` :: `"RitnProtoBase"` `[Read]`
Sentinelle de type.

---

## Méthodes — résolution de type

#### `:getItemType()` → `string?`
Parcourt `lualib.vanilla.types_item` et renvoie le premier type-item pour lequel `data.raw[type][name]` existe. Met `self.type` à jour au passage. `nil` si aucun match.

#### `:getEntityType()` → `string?`
Idem pour les types d'entité (`lualib.vanilla.types_entity`).

---

## Méthodes — mutation & écriture

#### `:changePrototype(parameter, value)` → [`RitnPrototype`](RitnPrototype.md)
Écrit `prototype[parameter] = value`, puis `:update()`.

#### `:setPrototype(parameter, value)` → [`RitnPrototype`](RitnPrototype.md)
Identique à `:changePrototype` sans la branche de log.

#### `:changeSubPrototype(parameter, subParameter, value)` → [`RitnPrototype`](RitnPrototype.md)
Écrit `prototype[parameter][subParameter] = value`. No-op si `parameter` n'existe pas déjà.

#### `:changeSubgroup(subgroup, order?)` → [`RitnPrototype`](RitnPrototype.md)
Définit `prototype.subgroup` (et `order` optionnel), puis `:update()`.

#### `:getProperties(propertie)` → `any`
Lit une propriété directement depuis `self.prototype` (sans aller-retour `data.raw`).

#### `:update()`
Réécrit `self.prototype` dans `data.raw[type][name]`. **Appelé automatiquement par chaque setter.** No-op si le slot cible ou `self.prototype` est nil.

---

## Exemple d'usage

Les mutateurs génériques sont utilisés à travers les sous-classes, par exemple :

```lua
-- via une sous-classe (RitnProtoItem hérite de RitnPrototype)
RitnProtoItem("wooden-chest"):changeSubgroup("belt")
```

---

## Remarques

- **Data stage uniquement** — accès `data.raw`.
- **Copie + écriture** — la sous-classe deep-copie `data.raw[type][name]` ; les mutations s'appliquent sur la copie et `:update()` réécrit. Pas de `data:extend` manuel.
- **Sous-classes** — les `RitnProto*` ajoutent leurs propres méthodes par-dessus. Voir la [carte des classes](../overview.md).

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnProtoRecipe`](RitnProtoRecipe.md) · [`RitnProtoTech`](RitnProtoTech.md) · [`RitnIngredient`](RitnIngredient.md)
- [ADR-0001 — Factory de classes](../../adr/0001-class-factory.md)
