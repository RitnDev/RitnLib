---
title: Bugs connus
type: debt
lang: fr
---

# Bugs connus


> Cette page croise les avertissements `⚠` des annotations LuaLS avec l'**usage réel** dans les mods consommateurs (RitnMenuButton, RitnLobbyGame, RitnCoreGame, RitnBaseGame, RitnLeaderboard, RitnPortal, RitnTeleporter). Seuls les défauts de code qui survivent à cette vérification sont listés. **La plupart sont latents** : ils se trouvent sur des chemins que les mods actuels n'exercent pas — RitnLib tourne en production sans souci.

Ce qui **n'est pas** un bug (et n'est donc pas ici) :

- Les **points de contrat d'extension** — une classe de base laisse volontairement un champ vide, la sous-classe le remplit. Ex : `RitnLibGui` laisse `self.gui[1]` vide (fourni par la sous-classe + l'interface remote `gui_action_*`) — pattern prouvé en production (RitnLobbyGame, RitnMenuButton, RitnCharacters). C'est du **design**, pas un défaut.
- Les **résidus d'API Factorio 1.x** (statistics `getStats*`, `created_entity`, `hr_version`…) → voir [Migration Factorio 2.0](../migration-2.0.md) et [Résidus API 1.x](api-1.x-leftover.md).
- Les **APIs dépréciées** mais fonctionnelles → voir [APIs dépréciées](deprecated.md).
- Les **caveats d'usage** intentionnels (`pcall` silencieux, `ifElse` à évaluation immédiate, patterns Lua dans `startsWith`…) — documentés dans les tooltips LuaLS.

---

## Défauts latents confirmés

Vrais défauts de code (vérifiés dans la source), mais sur des chemins **non exercés** par les mods consommateurs actuels — ils ne plantent donc rien aujourd'hui.

| Classe / méthode | Fichier | Mécanisme | Statut |
|---|---|---|---|
| `RitnLibEntity:getSurface()` · `:getForce()` | `classes/LuaClass/RitnEntity.lua` | Appellent `RitnlibSurface(...)` / `RitnlibForce(...)` — casse incorrecte (`lib` minuscule), globals inexistants → planteraient **si appelées**. Non appelées : les `getSurface`/`getForce` utilisés en prod sont ceux de `RitnLibPlayer`/`RitnLibEvent` (casse correcte). | R1 |
| `RitnLibForce:getStats*` | `classes/LuaClass/RitnForce.lua` | `self.stats` est commenté (API statistics 1.x → migration 2.0), donc ces méthodes lèvent une erreur sur une instance de base (`self.stats` nil). Implémentation **incomplète** : le seul consommateur prévu (RitnLeaderboard, qui reconstruit `self.stats`) est encore en développement, non sorti. Cause API détaillée en [migration 2.0](../migration-2.0.md). | R1/R2 |
| `RitnLibGuiElement:text()` | `classes/RitnClass/gui/RitnGuiElement.lua` | Teste `type(tooltip)` (variable inexistante) au lieu de `type(text)` → le corps ne s'exécute jamais, le texte n'est jamais appliqué. Silencieux. Non exercé (les consommateurs passent par `:caption()` / `:tooltip()`). | — |
| `RitnLibStyle:straitFrame()` | `classes/RitnClass/gui/RitnStyle.lua` | Appelle `self:standardFrame()` (inexistante) → exception **si appelée**. Les consommateurs utilisent `:frame()`, `:menuButton()`, etc. (qui fonctionnent). | — |
| `RitnLibStyle:visible()` | `classes/RitnClass/gui/RitnStyle.lua` | La ligne `log` concatène `self.gui_name`, jamais défini sur `RitnLibStyle` → exception **si appelée**. | — |

## Effet de bord mineur

| Classe / méthode | Fichier | Détail |
|---|---|---|
| `RitnLibSurface:getEntity()` | `classes/LuaClass/RitnSurface.lua` | Écrit son résultat dans la variable **globale** `LuaEntity` (pas de `local`) — pollue `_G` et masque le nom de type built-in. **Fonctionne** (utilisé en prod par RitnPortal, le résultat est bien retourné) ; effet de bord à nettoyer lors d'un refactor. |
| `spairs` · `clearOutput` (other-functions) · `pairs_concat` (table-functions) | `lualib/other-functions.lua`, `lualib/table-functions.lua` | Déclarés dans les `@field` du module mais jamais définis → toujours `nil`. Surface d'API trompeuse (l'autocomplétion les propose, ils n'existent pas au runtime). |

## Code beta / inachevé

Non comptés comme bugs de production — fonctionnalité explicitement en chantier.

| Classe / méthode | Fichier | Détail |
|---|---|---|
| `RitnLibInformatron:getElement()` · `:setPageContent()` | `classes/RitnClass/RitnInformatron.lua` | `getElement` lit `self.gui[self.gui_name]` alors que le constructeur stocke la racine en `[1]` ; `setPageContent` retourne le global indéfini `FLAG_PAGE_DISPLAY` (typo). Classe marquée `-- beta` dans `defines.lua`, exercée par aucun mod. |
| `RitnLibSetting` | `classes/RitnClass/RitnSetting.lua` | **Classe non terminée** (dev en cours). `:getType()` / `:new()` ne produisent pas de setting valide : la chaîne `self.TYPE[self.dataType]` déréférence avec une casse de clé incohérente (clés MAJUSCULES vs valeur minuscule). Ne pas utiliser en l'état — voir [RitnLibSetting](../reference/settings/RitnLibSetting.md). |

## Corrigés

| Version | Classe / méthode | Défaut |
|---|---|---|
| 0.10.5 | `RitnIngredient` — helper `getItem()` | Lisait `ingredient.inputs.probability` (sous-table inexistante) → « attempt to index a nil value ». Plantait aussi sur une entrée item définie uniquement par `amount_min` / `amount_max`. |
| 0.10.5 | `RitnPrototype:getItemType()` · `:getEntityType()` | Plantaient quand un type de la liste n'a aucun prototype dans `data.raw` (ex : `item-with-label` en 2.1). |
| 0.10.5 | `RitnProtoOre:remove()` | Laissait le minerai dans le `map_gen_settings` des planètes → plantage à l'initialisation de la planète. |
| 0.10.5 | `RitnProtoOre.active()` (`bStandard = true`) | Le helper local `resource()` était masqué par le paramètre `resource` → appel d'une string. |
| 0.10.5 | `RitnProtoTech:addPack()` | Erreur sur une technologie sans `unit` (research trigger). |
| 0.10.5 | `util.product_amount()` | Plantait sur un produit sans `probability`. |
| 0.10.4 | `RitnLibEntity:setMinable()` | `LuaEntity::minable` passé en lecture seule en 2.1.7 → écrit désormais `minable_flag`. |

## Voir aussi

- [Migration Factorio 2.0](../migration-2.0.md) — résidus d'API 1.x (`getStats*`/statistics, `created_entity`, `hr_version`…)
- [Résidus API 1.x](api-1.x-leftover.md) — clés de prototype mortes (`icon_mipmaps`, `hide_from_player_stats`…)
- [Migration Factorio 2.1](../migration-2.1.md) — `minable_flag`, `independent_probability`, `categories`
- [APIs dépréciées](deprecated.md)
- [Carte des classes](../reference/overview.md)
