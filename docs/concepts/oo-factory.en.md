---
title: In-house OO class factory
type: concept
lang: en
---

# In-house OO class factory

RitnLib ships its own simple inheritance implementation in Lua, exposed via `ritnlib.classFactory`. Every class in the library is built with it — and you can use it to create your own classes in a consumer mod.

## Why a custom factory?

Lua has no classes. The `__index = Parent` convention works but gets verbose. The factory solves this by exposing a single entry point that handles inheritance, constructor wiring and type checking.

## `ritnlib.classFactory.newclass(super, init)`

Creates a new class. Returns a callable object (`__call`) that constructs instances.

| Parameter | Type | Description |
|---|---|---|
| `super` | class \| `nil` | Parent class (single inheritance). `nil` for a root class |
| `init` | `function(self, ...)` | Constructor — receives the instance as first argument |

```lua
-- Root class
local Animal = ritnlib.classFactory.newclass(nil, function(self, name)
    self.name = name
    self.object_name = "Animal"
end)

-- Sub-class
local Dog = ritnlib.classFactory.newclass(Animal, function(self, name)
    Animal.init(self, name)       -- ← explicit parent call
    self.object_name = "Dog"
    self.sound = "Woof"
end)
```

**Parent constructor call**: the factory does not call it automatically. You must write `Parent.init(self, ...)` explicitly in the child constructor body.

## Instantiation

A class created with `newclass` is directly callable:

```lua
local fido = Dog("Fido")
print(fido.name)        -- "Fido"
print(fido.sound)       -- "Woof"
print(fido.object_name) -- "Dog"
```

Each call creates an independent table. There is no shared state between instances.

## `:is_a(Class)`

Checks whether an instance is of the given class or any of its parents. Walks the `_super` chain.

```lua
print(fido:is_a(Dog))          -- true
print(fido:is_a(Animal))       -- true
print(fido:is_a(RitnLibPlayer)) -- false
```

Useful for type-based dispatch inside a generic handler.

## Shallow-copy inheritance

The factory makes a **shallow copy** of the parent prototype into each instance. This means:

- Parent methods are available on the instance ✓
- Modifying a field on one instance does not affect others ✓
- Nested tables shared at the class level (not defined in `init`) can cause bugs → always define tables inside `init`

```lua
local Base = ritnlib.classFactory.newclass(nil, function(self)
    self.items = {}   -- ✅ each instance gets its own table
end)
```

## `new()` — deprecated

The `:new()` method exists on some legacy classes. It is equivalent to a direct call but its name is misleading. Prefer the direct call.

```lua
-- Deprecated
local instance = MyClass:new(args)

-- Preferred
local instance = MyClass(args)
```

## Using it in your mod

```lua
-- my-mod/control.lua
require("__RitnLib__.defines")

local MyModule = ritnlib.classFactory.newclass(nil, function(self, player)
    self.player = player
    self.object_name = "MyModule"
end)

function MyModule:doSomething()
    game.print("Hello from " .. self.player.name)
end

script.on_event(defines.events.on_player_created, function(event)
    local m = MyModule(game.get_player(event.player_index))
    m:doSomething()
end)
```

## See also

- [Architecture in 4 layers](architecture-layers.md)
- [Reference: `core/class-factory`](../reference/core/class-factory.md)
- [ADR-0001 — Why a custom factory](../adr/0001-class-factory.md)
