---
title: core/class.lua — factory de classes
type: reference
lang: fr
---

# `core/class.lua` — factory de classes

🇬🇧 [English version](../../../en/reference/core/class-factory.md)

La fabrique de classes orientée objet maison qui construit **toutes** les classes de RitnLib (et de ses mods consommateurs). Héritage simple, constructeur appelable, test de type — en Lua 5.1, sans dépendance. Le *pourquoi* de ce choix est dans l'[ADR-0001](../../adr/0001-class-factory.md).

| | |
|---|---|
| **Source** | `core/class.lua` |
| **Stage** | toutes (chargé au bootstrap) |
| **Accès** | `ritnlib.classFactory` (global) ou `require(ritnlib.defines.class.core)` |
| **`object_name` (type)** | `"RitnClassFactory"` |

---

## Fonctions

#### `newclass(super, init)` → `table`
Crée une nouvelle classe, avec héritage optionnel.

- **Sans parent** : `newclass(initFn)` — le premier argument est la fonction d'init.
- **Avec parent** : `newclass(ParentClass, initFn)` — *shallow-copy* des champs du parent dans l'enfant + `c._super = ParentClass`.

La classe retournée est **appelable** : `MaClasse(args)` crée une instance, lui pose la classe comme metatable (`__index`), puis exécute `init(obj, ...)`. Chaque instance reçoit `:is_a(klass)` qui parcourt la chaîne `_super`.

**Paramètres**
- `super` :: `table`|`fun(self, ...)` — classe parente (héritage) **ou** fonction d'init (sans parent).
- `init` :: `fun(self, ...)?` — fonction d'init (requise seulement si le 1er arg est une classe parente).

```lua
local A = ritnlib.classFactory.newclass(function(self, arg) self.value = arg end)
local B = ritnlib.classFactory.newclass(A, function(self, arg)
    A.init(self, arg)      -- appel explicite du constructeur parent
    self.extra = 42
end)
local obj = B(10)
obj:is_a(A)                -- true
```

#### `new(super, init)` → `table`
> **Avertissement** — **Déprécié / inutilisé.** Variante alternative de `newclass` conservée pendant le développement initial, référencée nulle part. Suppression planifiée — ne pas écrire de nouveau code dessus.

---

## Méthode d'instance

#### `:is_a(klass)` → `boolean`
Présente sur toute instance : `true` si `klass` est la classe de l'instance ou l'un de ses ancêtres (parcourt `_super`).

---

## Remarques

- ⚠ **Shallow-copy** — les champs du parent sont copiés superficiellement dans l'enfant : une table définie *au niveau classe* reste **partagée par référence**. Sans danger en pratique (les champs sont (ré)assignés dans `init`), mais à connaître.
- **Constructeur parent explicite** — il faut appeler `Parent.init(self, …)` à la main dans la sous-classe (pas de `super()` automatique).
- **Héritage simple uniquement** — pas de mixins / héritage multiple.

## Voir aussi

- [ADR-0001 — Factory de classes orientée objet maison](../../adr/0001-class-factory.md) (contexte & décision)
- [`RitnPrototype`](../prototype/RitnPrototype.md) · [Carte des classes](../overview.md)
