---
title: RitnLibSetting
type: reference
lang: en
---

# `RitnLibSetting`

🇫🇷 [Version française](../../../fr/reference/settings/RitnLibSetting.md)

> 🚧 **Work in progress — do not use as-is.**
>
> `RitnLibSetting` is one of the most recently added classes and **is not finished**. In the current version, `:getType()` / `:new()` don't produce a valid setting (the `self.TYPE[self.dataType]` chain dereferences with mismatched key casing). The full reference will be written once the class is finalized.

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnSetting.lua` |
| **Stage** | settings |
| **Access** | `require(ritnlib.defines.class.ritnClass.setting)` |
| **Status** | 🚧 work in progress (incomplete) |
| **`object_name`** | `"RitnLibSetting"` |

## Intent (target)

A fluent builder meant to produce a mod-setting prototype and register it via `data:extend`, at the **settings stage**:

```lua
-- intended shape once the class is finalized
RitnSetting("my-mod-enable-x")
    :setSettingStartup()
    :setDefaultValueBool(true)
    :new()
```

In the meantime, declare your settings directly with `data:extend` in `settings.lua`.

## See also

- [Known bugs](../../debt/known-bugs.md) (work-in-progress section)
- [Class map](../overview.md)
