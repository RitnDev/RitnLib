# RitnLib

Ce mod est une librairie de fonctions utilisées dans la plupart des RitnMods.

## Utilisation :

Dans votre mod, ajouté simplement ce RitnLib en dépendance.
Cette librairie de fonctions est classé pas type de fonction, en voici la liste :

* gvv (pour charger le mod [gvv](https://mods.factorio.com/mod/gvv))
* event-listener (pour une gestion par module, voir ce mod : [event-listener](https://mods.factorio.com/mod/event-listener))
* inventory (inventaire)
* items (objets)
* recipe (recettes)
* ore (resources, minerais)
* technology (technologies)
* log (pour RitnLog)
* gui (construction de GUI, interface utilisateur)
* LuaStyle (des styles prédéfinis pour des GUI)
* other (autres fonctions utiles)
* vanilla -> util (reprend le code vanilla en utilisant des variables local pour plus de fluidité)
* vanilla -> crash_site (reprend le code vanilla en utilisant des variables local pour plus de fluidité)

RitnLib charge automatiquement un fichier de définiton quand le mod est utilisé. Il charge ce fichier dans le ``data.lua`` et le ``control.lua`` ce qui rend ces définitions disponibles dans les 2 parties moddable du jeu.

Voici comment le fichier de définition est chargé :

```lua
ritnlib = {
    defines = {
        gvv = "__gvv__.gvv",
        entity = "__RitnLib__/lualib/entity-functions",
        event = "__RitnLib__/lualib/event-listener",
        gui = "__RitnLib__/lualib/gui-functions",
        inventory = "__RitnLib__/lualib/inventory",
        item = "__RitnLib__/lualib/item-functions",
        log = "__RitnLib__/lualib/log-functions",
        styles = "__RitnLib__/lualib/LuaStyle-functions",
        ore = "__RitnLib__/lualib/ore-functions",
        other = "__RitnLib__/lualib/other-functions",
        recipe = "__RitnLib__/lualib/recipe-functions",
        technology = "__RitnLib__/lualib/technology-functions",
        vanilla = {
            util = "__RitnLib__/lualib/vanilla/util",
            crash_site = "__RitnLib__/lualib/vanilla/crash-site",
        },
    }
}
```
ritnlib n'étant pas une variable local, elle est donc disponible dans votre mod.

Si dans votre mod vous avez besoin de fonction "recipe" il vous sufira de charger celle-ci de cette façon :
```lua
ritnlib.recipe = require(ritnlib.defines.recipe)
```

``ritnlib.recipe`` obtiendra l'intégralité de la librairie de fonction des recettes.
