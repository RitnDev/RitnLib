---
title: Interfaces remote
type: guide
lang: fr
---

# Interfaces remote

Ce guide montre les patterns `remote.add_interface` utilisés dans les mods RitnLib : dispatch GUI, communication inter-mods, et conventions de nommage.

## Pourquoi `remote`

Factorio utilise `remote.add_interface` / `remote.call` pour la communication entre mods. C'est le seul moyen propre pour un mod A d'appeler une fonction d'un mod B sans couplage fort.

Dans RitnLib, les interfaces remote servent principalement au **dispatch GUI** : `RitnLibGui` appelle `remote.call(mod_name, "gui_action_<gui_name>", ...)` pour router les clics.

## Structure d'une interface

```lua
-- mon-mod/control.lua
remote.add_interface("mon-mod", {
    ma_fonction = function(arg1, arg2)
        -- logique
        return resultat
    end,

    autre_fonction = function()
        -- ...
    end
})
```

`remote.add_interface` prend un nom (le nom de l'interface, souvent le nom du mod) et une table de fonctions. Enregistre au moment où le fichier s'exécute.

## Interface GUI — dispatch de clics

Le pattern `gui_action_<gui_name>` est une convention RitnLib. `RitnLibGui` cherche exactement ce nom :

```lua
remote.add_interface("mon-mod", {
    -- gui_name = "ma-gui" → gui_action_ma_gui (tirets → underscores)
    gui_action_ma_gui = function(player_index, element_name)
        local player = game.get_player(player_index)

        if element_name == "btn-ok" then
            -- Bouton OK cliqué
        elseif element_name == "btn-fermer" then
            if player and player.gui.center["ma-gui-root"] then
                player.gui.center["ma-gui-root"].destroy()
            end
        end
    end,
})
```

`element_name` est le nom de l'élément cliqué **sans** le préfixe `"gui_name-"`.

## Plusieurs GUIs dans le même mod

Tu peux avoir plusieurs interfaces GUI dans la même table `remote.add_interface` :

```lua
remote.add_interface("mon-mod", {
    gui_action_inventaire = function(player_index, element_name)
        -- dispatch pour la GUI "inventaire"
    end,

    gui_action_options = function(player_index, element_name)
        -- dispatch pour la GUI "options"
    end,

    -- fonctions utilitaires pour d'autres mods
    get_version = function()
        return "1.0.0"
    end,
})
```

## Appeler l'interface d'un autre mod

```lua
-- Vérifier si l'interface existe avant d'appeler
if remote.interfaces["autre-mod"] and remote.interfaces["autre-mod"]["get_version"] then
    local version = remote.call("autre-mod", "get_version")
    log("autre-mod version : " .. version)
end
```

Toujours vérifier `remote.interfaces["nom-mod"]` avant d'appeler — le mod peut être absent ou désactivé.

## Règle de nommage

| Cas | Nom de la fonction |
|---|---|
| Dispatch GUI pour `gui_name = "mon-panel"` | `gui_action_mon_panel` |
| Dispatch GUI pour `gui_name = "lobby-main"` | `gui_action_lobby_main` |
| API publique pour autres mods | nom descriptif libre |

La règle : remplace les tirets par des underscores dans `gui_name` pour obtenir le nom de la fonction.

## Déclarer une seule interface par mod

`remote.add_interface` ne peut être appelé qu'**une seule fois** par nom. Si tu appelles deux fois avec le même nom, Factorio lève une erreur. Regroupe toutes tes fonctions dans un seul appel.

```lua
-- ✅ Un seul appel avec toutes les fonctions
remote.add_interface("mon-mod", {
    gui_action_panel  = function(...) ... end,
    gui_action_options = function(...) ... end,
    get_data          = function() ... end,
})

-- ❌ Deux appels séparés → erreur Factorio
remote.add_interface("mon-mod", { gui_action_panel = ... })
remote.add_interface("mon-mod", { gui_action_options = ... })  -- ERREUR
```

## Voir aussi

- [Contrat remote consommateur](../concepts/remote-contract.md)
- [Pattern GUI complet](gui-pattern.md)
- [Modèle d'événements](../concepts/event-model.md)
- [Référence : RitnLibGui](../reference/runtime/RitnLibGui.md)
