---
title: Factory de classes orientée objet maison
type: concept
lang: fr
---

# Factory de classes orientée objet maison

RitnLib embarque sa propre implémentation d'héritage simple en Lua, exposée via `ritnlib.classFactory`. Toutes les classes de la lib en sont issues — et tu peux t'en servir pour créer les tiennes dans un mod consommateur.

## Pourquoi une factory maison ?

Lua n'a pas de classes. La convention `__index = Parent` fonctionne mais devient vite verbeuse. La factory résout ça en exposant un seul point d'entrée et en gérant l'héritage, le constructeur et le type check.

## `ritnlib.classFactory.newclass(super, init)`

Crée une nouvelle classe. Retourne un objet appelable (`__call`) qui construit des instances.

| Paramètre | Type | Description |
|---|---|---|
| `super` | classe \| `nil` | Classe parente (héritage simple). `nil` pour une classe racine |
| `init` | `function(self, ...)` | Constructeur — reçoit l'instance en premier argument |

```lua
-- Classe racine
local Animal = ritnlib.classFactory.newclass(nil, function(self, name)
    self.name = name
    self.object_name = "Animal"
end)

-- Sous-classe
local Dog = ritnlib.classFactory.newclass(Animal, function(self, name)
    Animal.init(self, name)       -- ← appel explicite du parent
    self.object_name = "Dog"
    self.sound = "Woof"
end)
```

**Appel du constructeur parent** : la factory ne l'appelle pas automatiquement. Tu dois écrire `Parent.init(self, ...)` explicitement dans le corps du constructeur enfant.

## Instanciation

Une classe créée avec `newclass` est directement appelable :

```lua
local fido = Dog("Fido")
print(fido.name)       -- "Fido"
print(fido.sound)      -- "Woof"
print(fido.object_name) -- "Dog"
```

Chaque appel crée une nouvelle table indépendante. Il n'y a pas de shared state entre instances.

## `:is_a(Class)`

Vérifie si une instance est de la classe donnée ou d'une de ses parentes. Parcourt la chaîne `_super`.

```lua
print(fido:is_a(Dog))    -- true
print(fido:is_a(Animal)) -- true
print(fido:is_a(RitnLibPlayer)) -- false
```

Utile pour du dispatch basé sur le type dans un handler générique.

## Héritage shallow-copy

La factory fait une **copie superficielle** du prototype parent dans chaque instance. Cela signifie :

- Les méthodes du parent sont disponibles sur l'instance ✓
- Modifier un champ sur une instance n'affecte pas les autres instances ✓
- Les tables imbriquées partagées entre instances (si définies au niveau classe et non dans `init`) peuvent poser problème → définis toujours les tables dans `init`

```lua
local Base = ritnlib.classFactory.newclass(nil, function(self)
    self.items = {}   -- ✅ chaque instance a sa propre table
end)
```

## `new()` — déprécié

La méthode `:new()` existe sur certaines classes historiques. Elle est équivalente à un appel direct mais son nom est trompeur (il ne crée pas un "nouveau" sens Lua traditionnel). Préfère l'appel direct.

```lua
-- Déprécié
local instance = MaClasse:new(args)

-- Préféré
local instance = MaClasse(args)
```

## Utiliser dans ton mod

```lua
-- mon-mod/control.lua
require("__RitnLib__.defines")

local MonModule = ritnlib.classFactory.newclass(nil, function(self, player)
    self.player = player
    self.object_name = "MonModule"
end)

function MonModule:doSomething()
    game.print("Hello from " .. self.player.name)
end

script.on_event(defines.events.on_player_created, function(event)
    local m = MonModule(game.get_player(event.player_index))
    m:doSomething()
end)
```

## Voir aussi

- [Architecture en 4 couches](architecture-layers.md)
- [Référence : `core/class-factory`](../reference/core/class-factory.md)
- [ADR-0001 — Choix de la factory maison](../adr/0001-class-factory.md)
