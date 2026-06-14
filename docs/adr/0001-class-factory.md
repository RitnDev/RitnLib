---
title: ADR-0001 — Factory de classes orientée objet maison
type: adr
lang: fr
---

# ADR-0001 — Factory de classes orientée objet maison


- **Statut** : ✅ Accepté — implémenté dans `core/class.lua`, utilisé par **toutes** les classes de la lib.
- **Concerne** : `core/class.lua`, `ritnlib.classFactory`

## Contexte

RitnLib expose une trentaine de classes : wrappers runtime (`RitnLibPlayer`, `RitnLibForce`, `RitnLibGui`…) et manipulateurs data (`RitnPrototype` → `RitnProto*`). Plusieurs besoins structurants :

- **Héritage simple** interne : `RitnPrototype → RitnProto*`, `RitnLibPlayer → RitnLibGui → RitnLibInformatron`.
- **Spécialisation côté consommateur** : les mods étendent les classes de base (`RitnCorePlayer` étend `RitnLibPlayer`, `RitnGuiMenuButton` étend `RitnLibGui`, `RitnLeaderboardForce` étend `RitnCoreForce`…) et remplissent les champs laissés vides par la base (le [contrat d'extension](../reference/overview.md), ex. `self.gui[1]`).
- **Contraintes Factorio** : Lua **5.1**, déterminisme multijoueur, et des instances runtime qui sont des **wrappers temporaires** (jamais stockés dans `storage` — voir [wrappers temporaires](../concepts/temporary-wrappers.md)).

Il fallait donc un mécanisme orienté objet : constructeur appelable, héritage simple, appel du constructeur parent, test de type, le tout léger et sans dépendance.

## Décision

Une **factory maison** d'une soixantaine de lignes, `ritnlib.classFactory.newclass(super, init)`, dans `core/class.lua` :

```lua
-- sans parent
local A = ritnlib.classFactory.newclass(function(self, arg) self.value = arg end)
-- avec parent
local B = ritnlib.classFactory.newclass(A, function(self, arg)
    A.init(self, arg)   -- appel explicite du constructeur parent
    self.extra = 42
end)
local obj = B(10)       -- construction via __call
obj:is_a(A)             -- true
```

Mécanique :

- **La classe est la metatable de ses instances** (`c.__index = c`) — les instances y résolvent leurs méthodes.
- **Constructeur via `__call`** : `MaClasse(args)` crée la table, lui pose la metatable, puis exécute `init`.
- **Héritage** : *shallow-copy* des champs du parent dans l'enfant, plus `c._super = super`. Le constructeur parent est appelé **explicitement** par la sous-classe (`Parent.init(self, ...)`).
- **`:is_a(klass)`** parcourt la chaîne `_super`.
- Signature flexible : `newclass(initFn)` (sans parent) ou `newclass(ParentClass, initFn)`.

## Conséquences

### Positives

- **Zéro dépendance externe**, ~60 lignes lisibles, contrôle total et compatibles Lua 5.1.
- **Un seul pattern** dans toute la lib *et* dans les mods consommateurs — prouvé en production (`RitnCorePlayer`, `RitnGuiMenuButton`, `RitnLeaderboardForce`, `RitnCharacter`…).
- Le **constructeur parent explicite** (`Parent.init(self, …)`) rend la spécialisation flexible et lisible.

### Négatives / pièges

- ⚠ **Shallow-copy des champs parent** : une table définie *au niveau de la classe* parente reste **partagée par référence** avec l'enfant. En pratique sans danger car les champs sont (ré)assignés dans `init` (champs d'instance) ; mais un champ-table au niveau classe serait mutable partagé.
- **Héritage simple uniquement** — pas de mixins ni d'héritage multiple.
- **`Parent.init` doit être appelé à la main** dans chaque sous-classe (oubli possible → champs parent non initialisés).
- Pas de `super:method()` automatique : référencer `Parent.method(self, …)`.
- Une variante `new()` (dépréciée, non utilisée) subsiste dans le fichier — à supprimer.

## Alternatives écartées

- **Bibliothèques OO Lua** (middleclass, classic…) : dépendance externe et surface plus large que le besoin réel.
- **Métatables ad hoc fichier par fichier** : duplication et incohérences.
- **Pas d'orienté objet** (simples tables de fonctions) : ne couvre pas l'héritage et la spécialisation consommateur recherchés.

## Voir aussi

- [Factory de classes orientée objet maison (concept)](../concepts/oo-factory.md)
- [Wrappers temporaires (règle d'or)](../concepts/temporary-wrappers.md)
- [Carte des classes](../reference/overview.md)
