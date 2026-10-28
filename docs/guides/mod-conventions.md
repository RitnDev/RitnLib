---
title: Conventions d'un mod Ritn
type: guide
lang: fr
---

# Conventions d'un mod Ritn

Ce guide décrit la structure et les règles communes des mods de l'écosystème Ritn. Il s'adresse à un
développeur qui écrit ou reprend un mod, **et à une IA** qui travaille dessus : chaque règle est formulée
pour être appliquée telle quelle. En cas de doute, copier le mod de référence plutôt qu'inventer.

Deux variantes existent :

| Variante | Quand | Mod de référence |
|---|---|---|
| **Avec RitnLib** | cas général : le mod dépend de RitnLib et utilise ses classes | RitnLobbyGame, RitnCharacters |
| **Autonome** | outil public qui ne doit dépendre de rien | gvv (0.6) — copie locale des classes de base de RitnLib |

Les règles marquées *(les deux)* s'appliquent dans tous les cas.

---

## 1. Arborescence *(les deux)*

```
<Mod>/
├─ info.json
├─ changelog.txt            format changelog de Factorio, strict
├─ settings.lua             settings stage (à la racine)
├─ data.lua                 data stage : charge defines puis prototypes/
├─ control.lua              control stage : defines → classes → modules
├─ core/
│  ├─ defines.lua           registre de chemins
│  ├─ setup-classes.lua     charge les classes (dans l'ordre d'héritage)
│  ├─ modules.lua           liste des modules envoyés à l'event handler
│  └─ migrations.lua        une migration par version (si storage)
├─ classes/                 une classe par fichier (Ritn<Mod>Xxx / Gvv<Xxx>)
├─ gui/                     fenêtres : getElement / getContent
├─ modules/                 un module par domaine
├─ lualib/                  fonctions utilitaires (modules local … return)
├─ prototypes/              data stage seulement
├─ mods/                    compatibilité, un fichier par mod
├─ locale/<langue>/<mod>.cfg
├─ types/<mod>-globals.lua  meta-file LuaLS (dans le zip)
└─ docs/                    doc mainteneur (exclue du zip)
```

Règles :
- Un fichier = une responsabilité. Pas de fichier « fourre-tout ».
- `prototypes/` ne contient **que** du data stage ; `classes/`, `gui/`, `modules/` **que** du control stage.

## 2. Registre de chemins `defines` *(les deux)*

Tous les `require` passent par un registre. Aucun fichier n'écrit un chemin en dur : si un fichier
bouge, seul le registre change.

**Avec RitnLib** — le mod ajoute son registre dans celui de RitnLib (`RitnLobbyGame/core/defines.lua`) :

```lua
-- FR : Registre partagé de RitnLib (ou __RitnLib__.defines)
-- EN : RitnLib shared registry (or __RitnLib__.defines)
if not ritnlib then
    require("__RitnBaseGame__.core.defines")
end

-- FR : Nom du mod et dossier racine
-- EN : Mod name and root folder
local name = "RitnLobbyGame"
local dir = "__" .. name .. "__"

local defines = {}
defines.name = name
defines.directory = dir

-- FR : Chargement des classes
-- EN : Classes loading
defines.setup = dir .. ".core.setup-classes"

-- FR : Classes du mod
-- EN : Mod classes
defines.class = {
    guiLobby = dir .. ".classes.RitnGuiLobby",
}

-- FR : Modules envoyés à l'event handler
-- EN : Modules sent to the event handler
defines.modules = {
    core = dir .. ".core.modules",
    events = dir .. ".modules.events",
}

-- FR : Description des fenêtres
-- EN : Windows description
defines.gui = {
    lobby = dir .. ".gui.lobby",
}

-- FR : Prototypes (data stage)
-- EN : Prototypes (data stage)
defines.prototypes = {
    customInputs = dir .. ".prototypes.custom-inputs",
}

-- FR : Clé courte du mod dans le registre partagé
-- EN : Short key of the mod inside the shared registry
ritnlib.defines.lobby = defines
```

**Autonome** — le mod crée son propre global (`gvv/core/defines.lua`) :

```lua
-- FR : Nom du mod et dossier racine
-- EN : Mod name and root folder
local name = "gvv"
local directory = "__" .. name .. "__"

-- FR : Registre des chemins (classes, gui, modules...)
-- EN : Path registry (classes, gui, modules...)
local defines = {
    name = name,
    directory = directory,
    class = {
        gui_main = directory .. ".classes.GvvGuiMain",
    },
    modules = {
        core = directory .. ".core.modules",
    },
}

-- FR : Global du mod
-- EN : Mod global
if not gvv then
    gvv = {}
end
gvv.defines = defines
```

Règles :
- Le registre est chargé au **data stage et au control stage** (`require("core.defines")` en tête).
- **`require` est interdit pendant le jeu** (dans un évènement, une commande, un `remote.call`) :
  tout ce qui doit être requis l'est au chargement de `control.lua`. Factorio lève sinon
  « Require can't be used outside of control.lua parsing ».

## 3. Bootstrap `control.lua` *(les deux)*

```lua
-- FR : Registre des chemins
-- EN : Path registry
require("core.defines")

-- FR : Classes (globales)
-- EN : Classes (globals)
require(<registre>.setup)

-- FR : Modules envoyés à l'event handler
-- EN : Modules sent to the event handler
local event_handler = require(<registre>.event)
local modules = require(<registre>.modules.core)
local listener = event_handler.add_libraries(modules)

-- FR : Rend le storage du mod lisible par gvv (si gvv est installé)
-- EN : Makes the mod storage readable by gvv (if gvv is installed)
if script.active_mods["gvv"] then
    require("__gvv__.gvv")()
end

-- FR : Tests en jeu avec RitnTest (développement seulement)
-- EN : In-game tests with RitnTest (development only)
if script.active_mods["RitnTest"] then
    require("__RitnTest__.interface")
end
```

- Event handler : `__core__.lualib.event_handler` (RitnLib l'expose via `ritnlib.defines.event`).
- Les deux dernières lignes ne font rien si gvv / RitnTest ne sont pas installés.

## 4. Classes *(les deux)*

- Créées par la **factory de classes** (`ritnlib.classFactory` avec RitnLib, copie locale
  `core/class.lua` en autonome) : `X = factory.newclass(Parent, function(self, ...) Parent.init(self, ...) end)`.
- **Globales** (`_G`), préfixées par le mod : `RitnLobbyGuiRequest`, `GvvGuiTree`. Une classe par fichier,
  chargée par `core/setup-classes.lua` **dans l'ordre d'héritage** (parent avant enfant).
- **Wrappers temporaires** : une instance est créée à chaque évènement (`X(event)`) et jetée ensuite.
  **Jamais d'instance dans `storage`** : on y range des données, pas des objets.
- `object_name` vaut le nom de la classe (ex. `self.object_name = "GvvGuiTree"`).
- Une méthode qui ne renvoie rien d'utile renvoie `self` (chaînage).
- Les méthodes tolèrent un joueur absent ou une fenêtre fermée (`isPresent`, éléments `nil`) sans erreur.

## 5. Modules et évènements *(les deux)*

Chaque fichier de `modules/` gère un domaine et renvoie une table pour l'event handler :

```lua
-- FR : Nouveau joueur : ses données sont créées
-- EN : New player: their data is created
local function on_player_created(event)
    storage.players[event.player_index] = {}
end

-- FR : Module envoyé à l'event handler
--      (optionnels : on_init, on_load, on_configuration_changed, add_commands)
-- EN : Module sent to the event handler
--      (optional: on_init, on_load, on_configuration_changed, add_commands)
local module = {events = {}}
module.events[defines.events.on_player_created] = on_player_created
return module
```

`core/modules.lua` les rassemble :

```lua
-- FR : Liste des modules envoyés à l'event handler
-- EN : List of the modules sent to the event handler
local modules = {}

-- FR : Cycle de vie du mod
-- EN : Mod life cycle
modules.events = require(<registre>.modules.events)

-- FR : Évènements des fenêtres
-- EN : Windows events
modules.gui = require(<registre>.modules.gui)

return modules
```

Règles :
- Pas de `script.on_event` direct dans un module : tout passe par l'event handler. Exception
  documentée : un `on_tick` activé / coupé par un paramètre (gvv), rétabli en `on_load` depuis `storage`.
- `on_load` ne doit **jamais** écrire dans `storage` (désynchronisation).
- Un gestionnaire GUI est **protégé** : erreur affichée au joueur **et** écrite dans le log
  (`log(...)` avec la pile d'appels), pour que l'erreur reste trouvable (rapports de bug, tests).

## 6. GUI *(les deux)*

### Description dans `gui/<fenêtre>.lua`

```lua
-- FR : Description des éléments (specs passées à LuaGuiElement.add)
-- EN : Elements description (specs given to LuaGuiElement.add)
local function getElement(gui_name)
    local element = {
        -- FR : Cadre principal
        -- EN : Main frame
        frame = {
            main = <Classe>Element(gui_name, "frame", "main"):vertical():get(),
        },
        -- FR : Bouton fermer
        -- EN : Close button
        button = {
            close = <Classe>Element(gui_name, "sprite-button", "close")
                :spritePath("utility/close")
                :get(),
        },
    }
    return element
end

-- FR : Chemins des éléments depuis gui[1], sans le préfixe gui_name
-- EN : Element paths from gui[1], without the gui_name prefix
local function getContent()
    local content = {
        frame = {
            main = { "frame-main" },
        },
        button = {
            close = { "frame-main", "button-close" },
        },
    }
    return content
end

return {
    getElement = getElement,
    getContent = getContent,
}
```

`<Classe>Element` = `RitnLibGuiElement` (avec RitnLib) ou la copie locale (`GvvGuiElement`).

### Nommage des éléments

- Nom = **`gui_name-type-name`**, ex. `gvv_main-button-close`, `lobby-button-create`.
- **Aucun des trois morceaux ne contient `-`** (le nom est découpé sur `-`). Utiliser `_` à l'intérieur.
- **`gui_name` préfixé par le mod** (`gvv_main`, `mymod_panel`) : les noms doivent être uniques dans
  `player.gui`, toutes fenêtres de tous les mods confondues.
- Types longs raccourcis : `sprite-button` → `button`, `scroll-pane` → `pane`, `empty-widget` → `empty`,
  `list-box` → `listbox`, `drop-down` → `dropdown`, `tabbed-pane` → `tabbed`, `text-box` → `textbox`.
- L'action d'un élément est `type-name` (ex. `button-close`), suivie du nom de l'évènement pour les
  évènements autres que le clic (`listbox-result-selection_state_changed`).

### Classe de fenêtre

- Hérite de `RitnLibGui` (ou de la copie locale `GvvGui`).
- **Contrat d'extension** : la sous-classe remplit `gui[1]` (conteneur), `content` (= `getContent()`),
  `gui_action`, puis écrit ses méthodes d'action.
- **Actions** :
  - avec RitnLib : `gui_action = { [gui_name] = { [action] = true } }` et l'action est servie par une
    interface remote `gui_action_<gui_name>` (voir le guide *Pattern GUI complet*) ;
  - en autonome : `gui_action = { ["button-close"] = "action_close" }`, la méthode est appelée directement.
- **Données dynamiques dans `element.tags`** (ligne d'arbre, index d'entrée…), jamais encodées dans le nom
  au-delà de `name`.
- **Aucune référence d'élément GUI dans `storage`** : on retrouve un élément par son chemin (`getElement`).
- Propriétés fixées **à la création seulement** (`numeric`, `allow_decimal`, `column_count`, `minimum_value`,
  `clear_and_focus_on_right_click`…) : à mettre dans la spec, pas après `add`.
- Fenêtre libre centrée : `auto_center = true` **après** avoir donné sa taille.

## 7. Data stage *(les deux)*

- `data.lua` ne fait que `require("core.defines")` puis les fichiers de `prototypes/` via le registre.
- Noms de prototypes préfixés par le mod (`_gvv-mod`, `ritnmods-…`) : jamais de collision avec le jeu.
- **Compatibilité entre mods Ritn** (mods de gameplay) : chaque mod crée `ritnmods.<mod>` dans son
  `data.lua` (`if not ritnmods then ritnmods = {} end`), avec ses drapeaux de détection et ses données
  partagées ; les autres le lisent. Un fichier par mod tiers dans `mods/`, gardé par
  `if ritnmods.<mod>.<flag> then`.
- Une variable qui n'existe plus dans le jeu (ex. une ancienne globale de `style.lua`) vaut `nil` : ne pas
  s'appuyer sur des globales du jeu non documentées.

## 8. `storage` et migrations *(les deux)*

- Données par joueur : `storage.players[player_index]`, créées à la première utilisation.
- Ce qui va dans `storage` : données sérialisables (nombres, chaînes, tables, objets Lua de l'API).
  **Jamais** : instances de classes, fonctions, références d'éléments GUI.
- `core/migrations.lua` : une entrée par version, exécutée dans `on_configuration_changed` quand le mod
  change de version (`mod_changes[<mod>].old_version`), dans l'ordre, protégée et journalisée (`log`).

## 9. Style de code *(les deux)*

- **Commentaires FR + EN** : chaque bloc de code a son commentaire, français puis anglais :
  ```lua
  -- FR : Fenêtre fermée : rien à faire
  -- EN : Window closed: nothing to do
  if frame == nil then
      return
  end
  ```
- Une instruction par ligne, pas de fonction sur une ligne, pas de code compact.
- **Fins de ligne : respecter celles du fichier** (CRLF dans la plupart des mods, LF dans une partie de RitnLib).
  Ne jamais convertir un fichier entier ; vérifier avec `git ls-files --eol`.
- Fichiers copiés d'un autre mod (ex. classes de RitnLib en autonome) : en-tête
  `-- FR : Source : RitnLib (Ritn), <fichier> (<classe>), version x.y.z` + les différences.

## 10. Annotations LuaLS *(les deux)*

Format du gold standard RitnLib : **EN puis FR**, séparés par un trait Unicode `─` (U+2500), tags après le FR :

```lua
---**EN**
---
---Description: Closes the main window.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ferme la fenêtre principale.
---@param ignore_save? boolean
---@return GvvGuiMain self  Chainable
function GvvGuiMain:close(ignore_save)
```

- **Chaque fonction, méthode et classe reçoit son bloc à sa création**, jamais « plus tard » : le code est
  écrit directement dans son état final (pas de passe d'annotation après coup).
- Ligne vide **obligatoire** entre un commentaire simple `-- …` et un bloc `---`.
- Descriptions inline des `@param` / `@field` : courtes, en anglais.
- `⚠` seulement pour un fait vérifié (effet de bord, instantané, beta, déprécié), dans les deux langues.

Classe — un seul bloc continu collé à l'assignation, puis **cast** à la fin de `newclass(...)` :

```lua
---**EN**
---
---Description: Panel of MyMod.
---
---⚠ Temporary wrapper, created on each event.
---Do not store the instance in `storage`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Panneau de MyMod.
---
---⚠ Wrapper temporaire, créé à chaque évènement.
---Ne pas stocker l'instance dans `storage`.
---@class MyModGuiPanel : RitnLibGui
---@field object_name string   "MyModGuiPanel"
---@operator call(table): MyModGuiPanel
---@type MyModGuiPanel
MyModGuiPanel = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    ...
end) --[[@as MyModGuiPanel]]
```

- Ne pas redéclarer les `@field` hérités (sauf ceux que l'enfant surcharge, comme `object_name`).
- **Miroir** : chaque classe globale est recopiée dans `types/<mod>-globals.lua` (`---@meta`, `---@diagnostic disable`),
  même `@class` / `@field` / `@operator`, puis `MyModGuiPanel = {}`. Les deux endroits se modifient ensemble.
  Ce fichier est **distribué** dans le zip (autocomplétion pour les développeurs des mods qui dépendent du tien).

## 11. Dépôt et publication *(les deux)*

- `info.json` : `factorio_version`, dépendances exactes (`RitnLib >= x.y`, optionnelles `?`, cachées `(?)`).
- `changelog.txt` au format Factorio (ligne de tirets, `Version:`, `Date:`, catégories indentées).
- `.gitattributes` : `export-ignore` pour `docs`, `tests`, `.github`, `.claude`… (exclus du zip).
- Fichiers Markdown bilingues : ligne FR terminée par **deux espaces**, ligne EN juste dessous.
- Publication par tag git (workflow `release.yml` : `git archive` du tag).

- **`docs/architecture.md` vivant** : mis à jour à chaque changement de structure (nouvelle couche, famille de
  classes, module, évènement, clé de `storage`, interface remote).

## 12. Tests en jeu *(les deux)*

Tester **dans le vrai jeu** avant de considérer une tâche finie : un test hors jeu ne voit ni l'API réelle ni
l'interdiction de `require` pendant le jeu. Les erreurs se lisent dans `factorio-current.log` (d'où le `log()` du §5).

Le mod de développement [**RitnTest**](https://github.com/RitnDev/RitnTest) (sur GitHub, pas sur le portail ; **jamais sur un serveur public**) pilote le vrai jeu par RCON : faux évènements GUI
envoyés aux gestionnaires du mod, lecture de la GUI, captures, `eval` dans la VM du mod. Le mod testé
ajoute la ligne RitnTest du §3 ; elle ne fait rien chez quelqu'un qui n'a pas RitnTest.

## 13. Kit IA *(les deux)*

Le dossier [`ai/` de RitnLib](https://github.com/RitnDev/RitnLib/tree/main/ai) contient de quoi démarrer :
- `AGENTS.md` et `CLAUDE.md` : les règles pour l'IA, à copier à la racine du mod ;
- `skills/ritn-mod-conventions/` : skill Claude Code, à copier dans `.claude/skills/` ;
- `template/with-ritnlib/` et `template/standalone/` : squelettes de mod prêts à copier (renommer `MyMod`).

---

## Pour une IA — règles d'action

1. **Lire avant d'écrire** : `core/defines.lua`, `core/modules.lua`, la classe et le fichier `gui/` concernés,
   puis copier le style existant. Le mod de référence de la variante fait foi.
2. **Ne jamais** : écrire un chemin de `require` en dur, faire un `require` pendant le jeu, ranger une
   instance de classe ou un élément GUI dans `storage`, mettre un `-` dans un morceau de nom d'élément,
   écrire dans `storage` depuis `on_load`.
3. **Toujours** : commentaires FR + EN, fins de ligne du fichier conservées, annotations au format §10, nouvelle classe ajoutée
   au registre **et** à `setup-classes.lua`, nouveau module ajouté à `core/modules.lua`, migration pour
   tout changement de structure de `storage`.
4. Erreur dans un gestionnaire GUI : la consigner dans le log (pile comprise), pas seulement dans le chat.
5. Tester en jeu (à la main, ou avec un outil RCON) avant de déclarer une tâche terminée ; un test hors jeu ne voit ni les
   restrictions de `require`, ni l'API réelle.

## Voir aussi

- [Pattern GUI complet](gui-pattern.md) — la GUI avec RitnLib en détail.
- [Architecture en 4 couches](../concepts/architecture-layers.md), [Wrappers temporaires](../concepts/temporary-wrappers.md).
- [ADR-0004 — Stratégie FR + EN](../adr/0004-fr-en-strategy.md).
