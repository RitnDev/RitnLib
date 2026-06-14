---
title: RitnLibGui
type: reference
lang: fr
---

# `RitnLibGui`

🇬🇧 [English version](../../../en/reference/runtime/RitnLibGui.md)

Classe de base pour construire des GUI Factorio pilotées par events. Elle hérite de [`RitnLibPlayer`](RitnLibPlayer.md) (donc tous les champs joueur sont disponibles), parse le nom des éléments cliqués selon une convention, et dispatche l'action vers une interface remote du mod consommateur.

`RitnLibGui` est **abstraite** : on ne l'utilise pas telle quelle, on en **dérive une sous-classe** qui remplit quelques champs laissés vides par la base. Voir le [contrat d'extension](#contrat-dextension) ci-dessous.

| | |
|---|---|
| **Source** | `classes/LuaClass/RitnGui.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | [`RitnLibPlayer`](RitnLibPlayer.md) |
| **Étendue par** | les classes GUI du mod, ex. `RitnGuiMenuButton`, `RitnLobbyGuiLobby` |
| **`object_name`** | `"RitnLibGui"` |

---

## Constructeur

#### `RitnLibGui(event, mod_name, main_gui?)` → [`RitnLibGui`](RitnLibGui.md)

Extrait le joueur de l'event (via [`RitnLibEvent`](RitnLibEvent.md)), initialise la partie [`RitnLibPlayer`](RitnLibPlayer.md), et laisse `gui`, `gui_name`, `gui_action`, `content` **vides** — à remplir par la sous-classe.

**Paramètres**
- `event` :: [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html) — l'event GUI (ou tout event portant un `player_index`).
- `mod_name` :: `string` — nom du mod consommateur ; sert à cibler l'interface remote.
- `main_gui` :: `string?` — suffixe du nom de l'élément racine.

**Valeur de retour** → [`RitnLibGui`](RitnLibGui.md). No-op si `mod_name` est `nil`.

---

## Contrat d'extension

La classe de base laisse quatre champs vides **volontairement** ; ta sous-classe les remplit dans son constructeur, et le mod enregistre l'interface de dispatch :

```lua
RitnGuiMenuButton = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    RitnLibGui.init(self, event, ritnlib.defines.menu.name, "button-menu")
    self.object_name = "RitnGuiMenuButton"
    self.gui_name = "ritn"                                   -- (1) slug logique
    self.gui      = { modGui.get_button_flow(self.player) }  -- (2) racine en [1]
    self.content  = flib.getContent()                        -- (3) arbre d'éléments
    self.gui_action = {                                      -- (4) actions acceptées
        [self.gui_name] = { ["button-menu"] = true },
    }
end)

-- côté mod : enregistrer le dispatcher remote
remote.add_interface("MonMod", {
    gui_action_ritn = function(action, event, ...) --[[ … ]] end,
})
```

| À fournir | Rôle |
|---|---|
| `self.gui = { <LuaGuiElement racine> }` | `:getElement` / `:on_gui_click` parcourent `self.gui[1]`. |
| `self.gui_name` | préfixe des noms d'éléments + suffixe de l'interface remote (`gui_action_<gui_name>`). |
| `self.gui_action[gui_name] = { [action] = true }` | les actions que ce GUI accepte. |
| `self.content` | table de chemins utilisée par `:getElement`. |
| `remote.add_interface(mod_name, { gui_action_<gui_name> = … })` | reçoit l'action dispatchée. |

Détails de conception dans l'[ADR-0001](../../adr/0001-class-factory.md).

---

## Attributs

En plus des champs hérités de [`RitnLibPlayer`](RitnLibPlayer.md) :

#### `mod_name` :: `string` `[Read]`
Nom du mod consommateur — cible de `remote.call`.

#### `event` :: [`EventData`](https://lua-api.factorio.com/latest/concepts/EventData.html) `[Read]`
Payload d'event GUI d'origine.

#### `element` :: [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html)`?` `[Read]`
L'élément cliqué/modifié (`event.element`).

#### `gui` :: `table` `[Read]`
Rempli par la sous-classe : `gui[1]` doit être le `LuaGuiElement` racine (contrat d'extension).

#### `gui_name` :: `string` `[Read]`
Slug logique du GUI (ex. `"lobby"`), rempli par la sous-classe.

#### `gui_action` :: `table<string, table<string, true>>` `[Read]`
Carte `[gui_name][action] = true` des actions acceptées, remplie par la sous-classe.

#### `content` :: `table` `[Read]`
Table de chemins d'éléments utilisée par `:getElement`, remplie par la sous-classe.

#### `main_gui` :: `string?` `[Read]`
Suffixe du nom de l'élément racine.

#### `list_valid` :: `table<string, true>` `[Read]`
Types d'éléments acceptés par `:on_gui_selection_state_changed` (`listbox`, `dropdown`).

#### `pattern` :: `string` `[Read]`
Regex de découpage des noms d'éléments en triplet `ui`/`element`/`name`.

---

## Méthodes

#### `:getEvent()` → [`RitnLibEvent`](RitnLibEvent.md)
Renvoie un [`RitnLibEvent`](RitnLibEvent.md) neuf enveloppant le payload d'origine.

#### `:setMainGui(main_gui)` → [`RitnLibGui`](RitnLibGui.md)
Définit le nom de l'élément racine `main_gui`. No-op si l'argument n'est pas une `string`. Chaînable.

#### `:getElement(element_type, element_name?)` → [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html)`?`
Récupère un élément en parcourant `self.content[element_type][element_name]` comme un chemin de suffixes préfixés par `gui_name`, depuis `self.gui[1]`.

**Paramètres**
- `element_type` :: `string` — catégorie d'élément dans `content`.
- `element_name` :: `string?` — nom précis ; si omis, vise `content[element_type]`.

> **Note** — Repose sur le contrat d'extension : `self.gui[1]` et `self.content` doivent avoir été remplis par la sous-classe. Renvoie `nil` si le chemin ne résout pas.

#### `:getListSelectedItem(element_type, element_name)` → `string?`
Renvoie l'item sélectionné d'un `list-box` / `drop-down` identifié par `(element_type, element_name)`. Valide le type et la sélection ; `nil` si rien n'est sélectionné.

#### `:actionGui(action, ...)` → [`RitnLibGui`](RitnLibGui.md)
Dispatche une action via `remote.call(self.mod_name, "gui_action_"..self.gui_name, action, self.event, ...)`. No-op si l'action n'est pas déclarée dans `self.gui_action[self.gui_name]`.

> **Avertissement** — Le mod consommateur **doit** avoir enregistré `remote.add_interface(mod_name, { gui_action_<gui_name> = … })`, sinon le `remote.call` lève.

#### `:on_gui_click(...)`
Handler de clic : parse `self.element.name` via `pattern` en `(ui, element, name)` et dispatche `action = "<element>-<name>"` via `:actionGui`. À appeler depuis l'event `on_gui_click` du mod. Retourne tôt et sans dommage si le clic ne concerne pas ce GUI.

#### `:on_gui_selection_state_changed(...)`
Comme `:on_gui_click`, pour les `list-box` / `drop-down` ; dispatche `action = "<element>-<name>-selection_state_changed"`. À appeler depuis l'event correspondant.

---

## Exemples d'usage

**Brancher le handler Factorio sur la sous-classe** (`RitnLobbyGame/modules/lobby.lua`) :

```lua
local function on_gui_click(e)
    RitnLobbyGuiLobby(e):on_gui_click()
end
module.events[defines.events.on_gui_click] = on_gui_click
```

**Recevoir l'action dispatchée** (`RitnLobbyGame/modules/storage.lua`) :

```lua
local lobby_interface = {
    ["gui_action_lobby"] = function(action, event)
        if     action == "open"    then RitnLobbyGuiLobby(event):action_open()
        elseif action == "close"   then RitnLobbyGuiLobby(event):action_close()
        elseif action == "request" then RitnLobbyGuiLobby(event):action_request()
        end
    end,
}
remote.add_interface("RitnLobbyGame", lobby_interface)
```

**Lire la sélection d'une liste** (`RitnLobbyGame/classes/RitnGuiLobby.lua`) :

```lua
local index = self:getElement("list").selected_index
```

---

## Remarques

- **Wrapper temporaire** — ne jamais stocker l'instance dans `storage` ; la reconstruire dans chaque handler GUI. Voir [Wrappers temporaires](../../concepts/wrappers-temporaires.md).
- **Abstraite par conception** — sans sous-classe qui remplit le [contrat d'extension](#contrat-dextension), `:getElement` / `:on_gui_click` n'ont pas de racine `gui[1]` à parcourir.
- **Convention de nommage** — les noms d'éléments suivent `gui_name-element-name` pour que `pattern` puisse les re-découper et router l'action.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibPlayer`](RitnLibPlayer.md) (parent) · [`RitnLibEvent`](RitnLibEvent.md) · [`RitnLibGuiElement`](RitnLibGuiElement.md) · [`RitnLibStyle`](RitnLibStyle.md)
- [Wrappers temporaires (règle d'or)](../../concepts/wrappers-temporaires.md)
- [ADR-0001 — Factory de classes](../../adr/0001-class-factory.md)
