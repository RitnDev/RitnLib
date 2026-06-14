---
title: RitnLibSetting
type: reference
lang: fr
---

# `RitnLibSetting`


> 🚧 **En développement — ne pas utiliser en l'état.**
>
> `RitnLibSetting` est l'une des dernières classes mises en place et **n'est pas terminée**. Dans la version actuelle, `:getType()` / `:new()` ne produisent pas de setting valide (la chaîne `self.TYPE[self.dataType]` déréférence avec une casse de clé incohérente). La documentation de référence complète sera rédigée une fois la classe finalisée.

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnSetting.lua` |
| **Stage** | settings |
| **Accès** | `require(ritnlib.defines.class.ritnClass.setting)` |
| **Statut** | 🚧 travail en cours (incomplet) |
| **`object_name`** | `"RitnLibSetting"` |

## Intention (cible)

Builder fluent destiné à produire un prototype de mod-setting et à l'enregistrer via `data:extend`, au **settings stage** :

```lua
-- forme visée une fois la classe finalisée
RitnSetting("mon-mod-enable-x")
    :setSettingStartup()
    :setDefaultValueBool(true)
    :new()
```

En attendant, déclare tes settings directement avec `data:extend` dans `settings.lua`.

## Voir aussi

- [Bugs connus](../../debt/known-bugs.md) (section code en chantier)
- [Carte des classes](../overview.md)
