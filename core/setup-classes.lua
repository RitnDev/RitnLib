---**EN**
---
---Description: Runtime classes loader — required by RitnLib's `control.lua`. Ensures the `ritnlib` global exists (requires `defines.lua` if not), then requires every runtime class file. Each of those files registers its class into `_G` (e.g. `RitnLibPlayer`, `RitnLibEvent`, …), making them directly available to consumer mods without any `require`.
---
---Load order matters: `RitnLibPlayer` must come before `RitnLibGui` (which extends it), and `RitnLibGui` before `RitnLibInformatron`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Chargeur des classes runtime — requis par le `control.lua` de RitnLib. S'assure que le global `ritnlib` existe (require `defines.lua` sinon), puis require chaque fichier de classe runtime. Chacun de ces fichiers enregistre sa classe dans `_G` (ex: `RitnLibPlayer`, `RitnLibEvent`, …), les rendant directement disponibles aux mods consommateurs sans aucun `require`.
---
---L'ordre de chargement compte : `RitnLibPlayer` doit venir avant `RitnLibGui` (qui l'étend), et `RitnLibGui` avant `RitnLibInformatron`.

if not ritnlib then
    require("__RitnLib__.defines")
    log('> imported : ritnlib.defines')
end
-----------------------------------------------------------
require(ritnlib.defines.class.luaClass.recipe)                  -- RitnLibRecipe
require(ritnlib.defines.class.luaClass.tech)                    -- RitnLibTechnology
require(ritnlib.defines.class.luaClass.force)                   -- RitnLibForce
require(ritnlib.defines.class.luaClass.surface)                 -- RitnLibSurface
require(ritnlib.defines.class.luaClass.player)                  -- RitnLibPlayer
require(ritnlib.defines.class.luaClass.entity)                  -- RitnLibEntity
require(ritnlib.defines.class.luaClass.event)                   -- RitnLibEvent
require(ritnlib.defines.class.luaClass.gui)                     -- RitnLibGui               extends: RitnLibPlayer
-- specifics
require(ritnlib.defines.class.ritnClass.inventory)              -- RitnLibInventory
-- gui
require(ritnlib.defines.class.gui.element)                      -- RitnLibGuiElement
require(ritnlib.defines.class.gui.style)                        -- RitnLibStyle
-- informatron
require(ritnlib.defines.class.ritnClass.informatron)            -- RitnLibInformatron       extends: RitnLibGui
