# RitnLib

Ce mod est une librairie de fonctions utilisées dans la plupart des RitnMods.

## Utilisation :

Dans votre mod, ajouté simplement ce RitnLib en dépendance.
Cette librairie de fonctions est classé pas type de fonction, en voici la liste :

* event-listener
* inventory (inventaire)
* items (objets)
* recipe (recettes)
* ore (resources, minerais)
* technology (technologies)
* log (pour RitnLog)
* gui (construction de GUI, interface utilisateur)
* LuaStyle (des style prédéfini pour des GUI)
* other (autres fonctions utiles)

RitnLib charge automatiquement un fichier de définiton quand le mod est utilisé. Il charge ce fichier dans le ``data.lua`` et le ``control.lua`` ce qui rend ces définitions disponibles dans les 2 parties moddable du jeu.

voici comment le fichier de définition est chargé :

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
ritnlib étant pas une variable local il est disponible par votre mod.

Si dans votre mod vous avez besoin de fonction "recipe" il vous sufira de charger celle-ci de cette façon :
```lua
ritnlib.item = require(ritnlib.defines.item)
```

``ritnlib.item`` obtiendra l'intégralité de la librairie de fonction des items.
