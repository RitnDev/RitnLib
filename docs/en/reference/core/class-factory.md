---
title: core/class.lua — class factory
type: reference
lang: en
---

# `core/class.lua` — class factory

🇫🇷 [Version française](../../../fr/reference/core/class-factory.md)

The in-house object-oriented class factory that builds **every** RitnLib class (and its consumer mods'). Single inheritance, callable constructor, type test — in Lua 5.1, dependency-free. The *why* of this choice is in [ADR-0001](../../adr/0001-class-factory.md).

| | |
|---|---|
| **Source** | `core/class.lua` |
| **Stage** | all (loaded at bootstrap) |
| **Access** | `ritnlib.classFactory` (global) or `require(ritnlib.defines.class.core)` |
| **`object_name` (type)** | `"RitnClassFactory"` |

---

## Functions

#### `newclass(super, init)` → `table`
Creates a new class, with optional inheritance.

- **No parent**: `newclass(initFn)` — the first argument is the init function.
- **With parent**: `newclass(ParentClass, initFn)` — shallow-copies the parent's fields into the child + `c._super = ParentClass`.

The returned class is **callable**: `MyClass(args)` creates an instance, sets the class as its metatable (`__index`), then runs `init(obj, ...)`. Each instance gains `:is_a(klass)`, which walks the `_super` chain.

**Parameters**
- `super` :: `table`|`fun(self, ...)` — parent class (inheritance) **or** init function (no parent).
- `init` :: `fun(self, ...)?` — init function (required only when the 1st arg is a parent class).

```lua
local A = ritnlib.classFactory.newclass(function(self, arg) self.value = arg end)
local B = ritnlib.classFactory.newclass(A, function(self, arg)
    A.init(self, arg)      -- explicit parent-constructor call
    self.extra = 42
end)
local obj = B(10)
obj:is_a(A)                -- true
```

#### `new(super, init)` → `table`
> **Warning** — **Deprecated / unused.** Alternative variant of `newclass` kept during early development, referenced nowhere. Scheduled for removal — don't write new code against it.

---

## Instance method

#### `:is_a(klass)` → `boolean`
Present on every instance: `true` if `klass` is the instance's class or one of its ancestors (walks `_super`).

---

## Remarks

- ⚠ **Shallow-copy** — the parent's fields are shallow-copied into the child: a table defined *at class level* stays **shared by reference**. Harmless in practice (fields are (re)assigned in `init`), but worth knowing.
- **Explicit parent constructor** — you must call `Parent.init(self, …)` by hand in the subclass (no automatic `super()`).
- **Single inheritance only** — no mixins / multiple inheritance.

## See also

- [ADR-0001 — In-house object-oriented class factory](../../adr/0001-class-factory.md) (context & decision)
- [`RitnPrototype`](../prototype/RitnPrototype.md) · [Class map](../overview.md)
