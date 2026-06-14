---
title: RitnLibInformatron
type: reference
lang: fr
---

# `RitnLibInformatron`

🇬🇧 [English version](../../../../en/reference/runtime/RitnLibInformatron.md)

> 🚧 **Bêta — ne pas utiliser en production.**
>
> `RitnLibInformatron` est une classe **bêta** avec deux défauts connus bloquants : `:getElement()` lit `self.gui[self.gui_name]` (clé string `"informatron"`) alors que le constructeur stocke l'élément à la clé entier `[1]` — retourne toujours `nil`. `:setPageContent()` retourne le global indéfini `FLAG_PAGE_DISPLAY` plutôt que `self.FLAG_PAGE_DISPLAY` — retourne toujours `nil`. De plus, l'interface remote `informatron_page_content` dans `core/interfaces.lua` est **commentée**, ce qui rend la classe inutilisable de bout en bout. La documentation de référence complète sera rédigée une fois la classe stabilisée.

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnInformatron.lua` |
| **Hérite de** | [`RitnLibGui`](RitnLibGui.md) |
| **Stage** | control (runtime) |
| **Accès** | `require(ritnlib.defines.class.ritnClass.informatron)` |
| **Statut** | 🚧 bêta (bloqué) |
| **`object_name`** | `"RitnLibInformatron"` |

## Intention (cible)

Wrapper d'intégration [Informatron](https://mods.factorio.com/mod/informatron). Construit autour d'un payload d'event Informatron pour rendre le contenu d'une page dans l'écran GUI d'Informatron via l'interface remote `informatron_page_content`.

```lua
-- usage visé une fois la classe stabilisée (dans le handler remote Informatron)
remote.add_interface("mon-mod", {
    informatron_page_content = function(data)
        local informatron = RitnLibInformatron("mon-mod", data)
        return informatron:setPageContent({
            { name = "mon-panel", parent = "start", gui = { type = "frame", ... } },
        })
    end
})
```

En attendant, utilise directement l'API Informatron (`remote.call("informatron", ...)`) et construis le GUI manuellement.

## Constructeur

```lua
RitnLibInformatron(mod_name, informatron_data)
```

| Paramètre | Type | Description |
|---|---|---|
| `mod_name` | `string` | Nom du mod (passé à `RitnLibGui.init` comme `action`) |
| `informatron_data` | `EventData` | Payload event Informatron (champ `player_index` requis) |

> **Note** — `self.page_name = page_name` lit le global `page_name` au moment de la construction. Ce global doit être défini par l'appelant (Informatron injecte ce global avant d'appeler l'interface remote).

## Champs hérités de `RitnLibGui`

Voir [`RitnLibGui`](RitnLibGui.md) pour tous les champs du dispatcher (`.player`, `.mod_name`, `.gui_action`, etc.).

## Champs propres

| Champ | Type | Valeur |
|---|---|---|
| `gui_name` | `"informatron"` | Nom logique du GUI |
| `page_name` | `string?` | Nom de la page en cours de rendu (lu depuis le global `page_name`) |
| `gui` | `{ [1]: LuaGuiElement }` | `{ self.player.gui.screen }` |
| `content` | `table` | Cache de l'arbre d'éléments (rempli par le consommateur) |
| `content_origine` | `string[]` | Chemin `{ "main-flow", "content-container", "content-pane" }` |
| `FLAG_PAGE_DISPLAY` | `true` | Constante succès |
| `FLAG_PAGE_NOT_DISPLAY` | `false` | Constante échec |

## Méthodes

#### `:getElement(element_type, element_name?)`

Récupère un `LuaGuiElement` dans l'arbre de la page en parcourant `content_origine` puis `self.content[element_type][element_name]`.

> ⚠ **Défaut bêta** — lit `self.gui[self.gui_name]` (clé `"informatron"`) mais le constructeur stocke à `self.gui[1]`. Retourne toujours `nil`.

**Paramètres :**

| Nom | Type | Description |
|---|---|---|
| `element_type` | `string` | Catégorie de l'élément dans `self.content` |
| `element_name` | `string?` | Nom de l'élément (optionnel) |

**Valeur de retour :** `LuaGuiElement?`

---

#### `:setPageContent(pageElements)`

Itère `pageElements` et ajoute chaque élément au content pane d'Informatron via `parent.add(element.gui)`.

> ⚠ **Défaut bêta** — retourne le global indéfini `FLAG_PAGE_DISPLAY` (pas `self.FLAG_PAGE_DISPLAY`). La valeur de retour est toujours `nil`.

**Paramètres :**

| Nom | Type | Description |
|---|---|---|
| `pageElements` | `{ name: string, parent: string, gui: table }[]` | Liste d'éléments à ajouter |

**Valeur de retour :** `boolean?` (intention : `true` = succès, `false` = page non affichée)

## Voir aussi

- [`RitnLibGui`](RitnLibGui.md) — classe parente (contrat d'extension)
- [`core/interfaces.lua`](../core/interfaces.md) — interface remote Informatron (commentée)
- [Bugs connus](../../debt/known-bugs.md)
- [Carte des classes](../overview.md)
