---
title: ADR-0001 — In-house object-oriented class factory
type: adr
lang: en
---

# ADR-0001 — In-house object-oriented class factory


- **Status**: ✅ Accepted — implemented in `core/class.lua`, used by **every** class in the library.
- **Scope**: `core/class.lua`, `ritnlib.classFactory`

## Context

RitnLib exposes around thirty classes: runtime wrappers (`RitnLibPlayer`, `RitnLibForce`, `RitnLibGui`…) and data manipulators (`RitnPrototype` → `RitnProto*`). Several structural needs:

- **Single inheritance** internally: `RitnPrototype → RitnProto*`, `RitnLibPlayer → RitnLibGui → RitnLibInformatron`.
- **Consumer-side specialization**: mods extend the base classes (`RitnCorePlayer` extends `RitnLibPlayer`, `RitnGuiMenuButton` extends `RitnLibGui`, `RitnLeaderboardForce` extends `RitnCoreForce`…) and fill in the fields the base leaves empty (the [extension contract](../reference/overview.md), e.g. `self.gui[1]`).
- **Factorio constraints**: Lua **5.1**, multiplayer determinism, and runtime instances that are **temporary wrappers** (never stored in `storage` — see [temporary wrappers](../concepts/temporary-wrappers.md)).

We therefore needed an object-oriented mechanism: a callable constructor, single inheritance, parent-constructor call, type test — all lightweight and dependency-free.

## Decision

An **in-house factory** of about sixty lines, `ritnlib.classFactory.newclass(super, init)`, in `core/class.lua`:

```lua
-- no parent
local A = ritnlib.classFactory.newclass(function(self, arg) self.value = arg end)
-- with parent
local B = ritnlib.classFactory.newclass(A, function(self, arg)
    A.init(self, arg)   -- explicit parent-constructor call
    self.extra = 42
end)
local obj = B(10)       -- construction via __call
obj:is_a(A)             -- true
```

Mechanics:

- **The class is the metatable of its instances** (`c.__index = c`) — instances resolve their methods there.
- **Constructor via `__call`**: `MyClass(args)` builds the table, sets its metatable, then runs `init`.
- **Inheritance**: shallow-copy of the parent's fields into the child, plus `c._super = super`. The parent constructor is called **explicitly** by the subclass (`Parent.init(self, ...)`).
- **`:is_a(klass)`** walks the `_super` chain.
- Flexible signature: `newclass(initFn)` (no parent) or `newclass(ParentClass, initFn)`.

## Consequences

### Positive

- **Zero external dependency**, ~60 readable lines, full control, Lua 5.1-compatible.
- **A single pattern** across the whole library *and* the consumer mods — proven in production (`RitnCorePlayer`, `RitnGuiMenuButton`, `RitnLeaderboardForce`, `RitnCharacter`…).
- The **explicit parent constructor** (`Parent.init(self, …)`) keeps specialization flexible and readable.

### Negative / pitfalls

- ⚠ **Shallow-copy of parent fields**: a table defined *at the parent class level* stays **shared by reference** with the child. Harmless in practice because fields are (re)assigned in `init` (instance fields); but a class-level table field would be a shared mutable.
- **Single inheritance only** — no mixins or multiple inheritance.
- **`Parent.init` must be called by hand** in each subclass (easy to forget → uninitialized parent fields).
- No automatic `super:method()`: reference `Parent.method(self, …)`.
- A `new()` variant (deprecated, unused) remains in the file — to be removed.

## Alternatives considered

- **Lua OO libraries** (middleclass, classic…): external dependency and a larger surface than actually needed.
- **Ad-hoc metatables per file**: duplication and inconsistency.
- **No OOP** (plain function tables): doesn't cover the inheritance and consumer specialization we need.

## See also

- [In-house object-oriented class factory (concept)](../concepts/oo-factory.md)
- [Temporary wrappers (golden rule)](../concepts/temporary-wrappers.md)
- [Class map](../reference/overview.md)
