---
title: Migration Factorio 2.0 / Factorio 2.0 migration
type: debt
lang: fr-en
---

# Migration Factorio 2.0

> 🇫🇷 **Français** ci-dessous · 🇬🇧 [English version](#factorio-20-migration) further down.

RitnLib **fonctionne sous Factorio 2.0**. Cette page recense les endroits du code qui touchent encore à des API **1.x**, ou qui pourraient tirer parti de nouveautés **2.0**. Elle est construite en croisant les annotations LuaLS des sources, la [doc API 2.0](https://lua-api.factorio.com/latest/) et l'usage réel dans les mods consommateurs.

Trois natures, volontairement séparées (ne pas tout traiter comme « cassé ») :

1. **Résidus d'API 1.x** — à migrer.
2. **Opportunités 2.0** — améliorations non bloquantes.
3. **Couverture Space Age** — incomplète, non bloquante.

---

## 1. Résidus d'API 1.x — à migrer

### 1.1 API statistics de `LuaForce` — `RitnLibForce`

Le bloc `self.stats` (actuellement **commenté**) du constructeur lit l'API statistics **1.x** :

```lua
LuaForce.item_production_statistics.input_counts
LuaForce.fluid_production_statistics
LuaForce.kill_count_statistics
LuaForce.entity_build_count_statistics
```

En 2.0 ces **propriétés ont été retirées** et remplacées par des **getters indexés par surface** :
`get_item_production_statistics(surface)`, `get_fluid_production_statistics(surface)`, `get_kill_count_statistics(surface)`, `get_entity_build_count_statistics(surface)`.

- **Impact** : les méthodes `:getStats*` de [`RitnLibForce`](../classes/LuaClass/RitnForce.lua) ne fonctionnent pas sur une instance de base (`self.stats` reste `nil`). Voir [bugs connus](fr/debt/known-bugs.md).
- **Migration** : décommenter le bloc et passer aux getters 2.0 ; **trancher la sémantique surface** (statistiques globales toutes surfaces, ou par surface). Le seul consommateur prévu (`RitnForceSynth` dans RitnLeaderboard) est encore en développement.

### 1.2 `event.created_entity` — `RitnLibEvent` (`getEntity`)

L'extracteur `getEntity` teste `event.created_entity` en premier (champ **1.x**). En 2.0 ce champ **n'existe plus** (`nil` → branche morte, donc pas de crash, mais code inutile).

Remplacement 2.0 : l'event **`on_trigger_created_entity`** — déclenché quand une entité dotée d'un prototype trigger (capsules…) en crée une autre, **si** le prototype trigger définit `trigger_created_entity = true`. L'entité créée arrive via `event.entity` (avec `source :: LuaEntity?`).

- **Migration** : retirer la branche `created_entity` de `getEntity` ; brancher `on_trigger_created_entity` côté consommateur si ce cas est nécessaire.

### 1.3 Sprites `hr_version` — `lualib/other-functions`

`assembler1pipepictures` (et le helper similaire) déclarent un layout sprite **1.x** via `hr_version`. En 2.0, `hr_version` est **ignoré** (tous les sprites sont en pleine résolution par défaut).

- **Migration** : aplatir au format sprite 2.0 — retirer la clé `hr_version` et conserver la définition haute résolution comme définition de base.

### 1.4 Classes `RitnProto*` (data stage) — non révisées pour 2.0

**L'ensemble** des manipulateurs de prototypes ([`RitnProtoRecipe`](fr/reference/prototype/RitnProtoRecipe.md), [`RitnProtoTech`](fr/reference/prototype/RitnProtoTech.md), et les autres `RitnProto*`) **n'ont pas été retouchés depuis Factorio 2.0** : ils conservent des constructions de l'API 1.x (variantes de difficulté `normal` / `expensive` des recettes, accès directs à `unit.*`, etc.). Ils restent largement utilisables au data stage, mais sont à auditer pour 2.0.

- **Migration** : passer en revue chaque `RitnProto*`, retirer les branches 1.x mortes et valider contre les prototypes 2.0.

---

## 2. Opportunités 2.0 — améliorations (non bloquant)

### 2.1 `set_recipe` + qualité — `RitnLibTechnology`

En 2.0, `LuaEntity.set_recipe` accepte un paramètre de **qualité**. La méthode concernée ne le transmet pas encore — à enrichir si la gestion de qualité devient nécessaire.

### 2.2 `get_entity_by_unit_number` — `RitnLibSurface:getEntity`

Quand on dispose déjà du `unit_number`, `game.get_entity_by_unit_number(n)` est en **O(1)**, contre la recherche `find_entities_filtered` actuelle en O(entités-dans-la-zone). Optimisation possible sur ce chemin précis.

---

## 3. Couverture Space Age — incomplète (non bloquant)

### 3.1 Events non mappés — `RitnLibEvent`

Le normaliseur d'event ne mappe pas (encore) les events Space Age : `on_space_platform_*`, `on_player_changed_planet`, `on_segment_*`, `on_object_destroyed`. À étendre si un mod consommateur en a besoin.

### 3.2 `on_rocket_launched` / cargo pod — `RitnLibEvent:getRocket`

`event.rocket` **fonctionne toujours** en 2.0 (le payload `on_rocket_launched` ajoute aussi `rocket_silo`). En revanche, depuis 2.0 le **rocket et le cargo pod sont des entités distinctes** : pour détecter la **fin complète** d'un lancement, il faut écouter **`on_cargo_pod_finished_ascending`**. À considérer si la sémantique « lancement terminé » est requise.

### 3.3 `onNauvis` — `RitnLibPlayer`

`onNauvis` teste `surface.name == 'nauvis'` et retourne donc `false` sur les planètes Space Age (vulcanus/fulgora/gleba/aquilo) et les plateformes spatiales. Comportement à garder en tête — ce n'est pas un bug.

---

## 4. Faux positifs écartés

- **`LuaForce.items_launched` / `LuaForce.rockets_launched`** : **toujours présents en 2.0** (`items_launched` : Read, dictionnaire item→count ; `rockets_launched` : Read|Write uint32). Ce n'est **pas** une incompatibilité — le constructeur de `RitnLibForce` les lit directement sans risque. (Annotation source corrigée en conséquence.)

---

## Voir aussi

- [Bugs connus](fr/debt/known-bugs.md)
- [Carte des classes](fr/reference/overview.md)
- Sources : [changelog API 2.0](https://forums.factorio.com/viewtopic.php?t=115737), [Version history 2.0.0](https://wiki.factorio.com/Version_history/2.0.0)

<br>

═══════════════════════════════════════════════════════════════════════════

<a id="factorio-20-migration"></a>
# Factorio 2.0 migration

> 🇬🇧 **English** · 🇫🇷 [Version française](#migration-factorio-20) above.

RitnLib **runs under Factorio 2.0**. This page lists the spots in the code that still touch **1.x** APIs, or that could take advantage of **2.0** features. It is built by cross-checking the source LuaLS annotations, the [2.0 API docs](https://lua-api.factorio.com/latest/) and actual usage in the consumer mods.

Three kinds, deliberately kept separate (don't treat everything as "broken"):

1. **1.x API residue** — to migrate.
2. **2.0 opportunities** — non-blocking improvements.
3. **Space Age coverage** — incomplete, non-blocking.

---

## 1. Factorio 1.x API residue — to migrate

### 1.1 `LuaForce` statistics API — `RitnLibForce`

The constructor's `self.stats` block (currently **commented out**) reads the **1.x** statistics API:

```lua
LuaForce.item_production_statistics.input_counts
LuaForce.fluid_production_statistics
LuaForce.kill_count_statistics
LuaForce.entity_build_count_statistics
```

In 2.0 these **properties were removed** and replaced with **per-surface getters**:
`get_item_production_statistics(surface)`, `get_fluid_production_statistics(surface)`, `get_kill_count_statistics(surface)`, `get_entity_build_count_statistics(surface)`.

- **Impact**: [`RitnLibForce`](../classes/LuaClass/RitnForce.lua)'s `:getStats*` methods don't work on a base instance (`self.stats` stays `nil`). See [known bugs](en/debt/known-bugs.md).
- **Migration**: uncomment the block and move to the 2.0 getters; **decide the surface semantics** (all-surface totals vs per-surface). The only intended consumer (`RitnForceSynth` in RitnLeaderboard) is still in development.

### 1.2 `event.created_entity` — `RitnLibEvent` (`getEntity`)

The `getEntity` extractor checks `event.created_entity` first (a **1.x** field). In 2.0 that field **no longer exists** (`nil` → dead branch, so no crash, just unused code).

2.0 replacement: the **`on_trigger_created_entity`** event — fired when an entity with a trigger prototype (capsules…) creates another entity, **if** that trigger prototype set `trigger_created_entity = true`. The created entity comes through `event.entity` (with `source :: LuaEntity?`).

- **Migration**: drop the `created_entity` branch from `getEntity`; wire `on_trigger_created_entity` on the consumer side if that case is needed.

### 1.3 `hr_version` sprites — `lualib/other-functions`

`assembler1pipepictures` (and the similar helper) declare a **1.x** sprite layout via `hr_version`. In 2.0, `hr_version` is **ignored** (all sprites are full-resolution by default).

- **Migration**: flatten to the 2.0 sprite format — remove the `hr_version` key and keep the high-res definition as the base.

### 1.4 `RitnProto*` classes (data stage) — not revised for 2.0

**All** the prototype manipulators ([`RitnProtoRecipe`](en/reference/prototype/RitnProtoRecipe.md), [`RitnProtoTech`](en/reference/prototype/RitnProtoTech.md), and the other `RitnProto*`) **haven't been touched since Factorio 2.0**: they keep 1.x API constructs (recipe `normal` / `expensive` difficulty variants, direct `unit.*` access, etc.). They remain largely usable at data stage, but should be audited for 2.0.

- **Migration**: review each `RitnProto*`, remove dead 1.x branches and validate against 2.0 prototypes.

---

## 2. 2.0 opportunities — improvements (non-blocking)

### 2.1 `set_recipe` + quality — `RitnLibTechnology`

In 2.0, `LuaEntity.set_recipe` accepts a **quality** parameter. The relevant method doesn't pass it through yet — to extend if quality handling becomes necessary.

### 2.2 `get_entity_by_unit_number` — `RitnLibSurface:getEntity`

When the `unit_number` is already known, `game.get_entity_by_unit_number(n)` is **O(1)**, versus the current `find_entities_filtered` search at O(entities-in-area). Possible optimization on that specific path.

---

## 3. Space Age coverage — incomplete (non-blocking)

### 3.1 Unmapped events — `RitnLibEvent`

The event normalizer doesn't (yet) map the Space Age events: `on_space_platform_*`, `on_player_changed_planet`, `on_segment_*`, `on_object_destroyed`. To extend if a consumer mod needs them.

### 3.2 `on_rocket_launched` / cargo pod — `RitnLibEvent:getRocket`

`event.rocket` **still works** in 2.0 (the `on_rocket_launched` payload also carries `rocket_silo`). However, since 2.0 the **rocket and the cargo pod are separate entities**: to detect a **fully completed** launch, listen to **`on_cargo_pod_finished_ascending`**. To consider if the "launch finished" semantics is required.

### 3.3 `onNauvis` — `RitnLibPlayer`

`onNauvis` checks `surface.name == 'nauvis'` and therefore returns `false` on Space Age planets (vulcanus/fulgora/gleba/aquilo) and space platforms. Behavior to keep in mind — not a bug.

---

## 4. Dismissed false positives

- **`LuaForce.items_launched` / `LuaForce.rockets_launched`**: **still present in 2.0** (`items_launched`: Read, dictionary item→count; `rockets_launched`: Read|Write uint32). This is **not** an incompatibility — `RitnLibForce`'s constructor reads them directly without risk. (Source annotation corrected accordingly.)

---

## See also

- [Known bugs](en/debt/known-bugs.md)
- [Class map](en/reference/overview.md)
- Sources: [2.0 API changelog](https://forums.factorio.com/viewtopic.php?t=115737), [Version history 2.0.0](https://wiki.factorio.com/Version_history/2.0.0)
