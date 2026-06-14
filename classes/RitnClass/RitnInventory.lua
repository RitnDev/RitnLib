-- RitnLibInventory
----------------------------------------------------------------
local util = require(ritnlib.defines.other)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: Per-player inventory snapshot/restore helper backed by `game.create_inventory`.
---
---The consumer mod owns the persistence: it must pass an external `inventoryGlobal` table (typically a `storage.X`) where snapshots are stored. RitnLib only provides the logic; the table belongs to the consumer.
---
---⚠ Temporary wrapper. Do not store the `RitnLibInventory` instance in `storage`. Only the `inventoryGlobal` table passed as 2nd arg is persistent.
---
---Cursor mechanic: `:save(true)` and `:load(true)` both call `:saveCursor()` internally — this works because `LuaItemStack.swap_stack` is symmetric (its own inverse). The save→load round-trip restores both player and snapshot cursor correctly.
---
---Persistent shape expected by the consumer:
---```lua
---storage.inventory_snapshots = {
---    ["<player_name>"] = {
---        [defines.inventory.character_main]  = LuaInventory,
---        [defines.inventory.character_guns]  = LuaInventory,
---        [defines.inventory.character_ammo]  = LuaInventory,
---        [defines.inventory.character_armor] = LuaInventory,
---        [defines.inventory.character_trash] = LuaInventory,
---        ["cursor"] = LuaInventory,
---        ["logistic_param"] = { {name=, value=}, {name=, value=} }
---    }
---}
---```
---
---See: [`inventory-snapshot.md`](../../docs/en/guides/inventory-snapshot.md), [`delegated-persistence.md`](../../docs/en/concepts/delegated-persistence.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: Helper de snapshot/restauration d'inventaire par joueur, basé sur `game.create_inventory`.
---
---Le mod consommateur possède la persistance : il doit passer une table externe `inventoryGlobal` (typiquement un `storage.X`) où les snapshots sont stockés. RitnLib fournit la logique ; la table appartient au consommateur.
---
---⚠ Wrapper temporaire. Ne pas stocker l'instance `RitnLibInventory` dans `storage`. Seule la table `inventoryGlobal` passée en 2e arg est persistante.
---
---Mécanique cursor : `:save(true)` et `:load(true)` appellent tous deux `:saveCursor()` en interne — ça fonctionne car `LuaItemStack.swap_stack` est symétrique (son propre inverse). L'aller-retour save→load restaure correctement le cursor du joueur et du snapshot.
---
---Structure persistante attendue par le consommateur :
---```lua
---storage.inventory_snapshots = {
---    ["<nom_joueur>"] = {
---        [defines.inventory.character_main]  = LuaInventory,
---        [defines.inventory.character_guns]  = LuaInventory,
---        [defines.inventory.character_ammo]  = LuaInventory,
---        [defines.inventory.character_armor] = LuaInventory,
---        [defines.inventory.character_trash] = LuaInventory,
---        ["cursor"] = LuaInventory,
---        ["logistic_param"] = { {name=, value=}, {name=, value=} }
---    }
---}
---```
---
---Voir : [`inventory-snapshot.md`](../../docs/fr/guides/inventory-snapshot.md), [`persistance-deleguee.md`](../../docs/fr/concepts/persistance-deleguee.md)
---@class RitnLibInventory
---@field object_name "RitnLibInventory"             Sentinel read by the custom `util.type()`
---@field data table<string, table>                  Reference to the consumer's persistent `inventoryGlobal` table
---@field player LuaPlayer                           Wrapped player (live reference)
---@field name string                                Player name (used as key in `self.data`)
---@field INVENTORY_SIZE_MAX 65535                   Inventory cap passed to `game.create_inventory`
---@field inventory_size integer                     Effective size used by `:init` (defaults to `INVENTORY_SIZE_MAX`)
---@operator call(LuaPlayer, table): RitnLibInventory
---@type RitnLibInventory
RitnLibInventory = ritnlib.classFactory.newclass(function(self, LuaPlayer, inventoryGlobal)
    self.object_name = "RitnLibInventory"
    -- check input params
    if util.type(LuaPlayer) ~= "LuaPlayer" then
        log('not LuaPlayer !')
        return
    end
    if LuaPlayer.valid == false then
        log('not LuaPlayer valid !')
        return
    end
    if LuaPlayer.is_player() == false then
        log('not LuaPlayer !')
        return
    end
    --
    if LuaPlayer.character == nil then return end
    if inventoryGlobal == nil then
        log('inventoryGlobal is nil')
        return
    end
    --------------------------------------------------
    self.data = inventoryGlobal
    self.player = LuaPlayer
    self.name = LuaPlayer.name
    ---
    self.INVENTORY_SIZE_MAX = 65535
    self.inventory_size = self.INVENTORY_SIZE_MAX
    --------------------------------------------------
end) --[[@as RitnLibInventory]]
----------------------------------------------------------------


-- init data inventory

---**EN**
---
---Description: Initialises the player's snapshot dict in `self.data` if not already present. Creates 5 character-inventory snapshots + 1 cursor snapshot + a `logistic_param` table via `game.create_inventory`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Initialise le dict de snapshot du joueur dans `self.data` si pas déjà présent. Crée 5 snapshots d'inventaire character + 1 snapshot cursor + une table `logistic_param` via `game.create_inventory`.
---@return RitnLibInventory self  Chainable
function RitnLibInventory:init()
    if self.data[self.name] ~= nil then return self end
    log('> ' .. self.object_name .. ':init() -> ' .. self.name)


    self.data[self.name] = {
        [defines.inventory.character_main] = game.create_inventory(self.inventory_size),
        [defines.inventory.character_guns] = game.create_inventory(self.inventory_size),
        [defines.inventory.character_ammo] = game.create_inventory(self.inventory_size),
        [defines.inventory.character_armor] = game.create_inventory(self.inventory_size),
        [defines.inventory.character_trash] = game.create_inventory(self.inventory_size),
        ["cursor"] = game.create_inventory(1),
        ["logistic_param"] = {
            { name = "slot_count",                                   value = 0 },
            { name = "character_personal_logistic_requests_enabled", value = false }
        }
    }

    return self
end

----------------------------------------------------------------
-- INVENTORY
----------------------------------------------------------------

-- SaveInventory

---**EN**
---
---Description: Snapshots the player's inventory at the given `defines.inventory.*` slot via `swap_stack` (auto-inits if needed).
---
---──────────────────────────────
---
---**FR**
---
---Description: Snapshot l'inventaire du joueur au slot `defines.inventory.*` donné via `swap_stack` (auto-init si nécessaire).
---@param define defines.inventory
---@return RitnLibInventory self  Chainable
function RitnLibInventory:saveInventory(define)
    if self.data[self.name] == nil then self:init() end

    local inventory = self.player.get_inventory(define)
    if inventory ~= nil then
        for i = 1, #inventory do
            local stack = inventory[i]
            if stack.valid then
                self.data[self.name][define][i].swap_stack(stack)
            end
        end
    end

    return self
end

--LoadInventory

---**EN**
---
---Description: Restores the player's inventory at the given slot from the snapshot via `swap_stack`. No-op if no snapshot exists.
---
---──────────────────────────────
---
---**FR**
---
---Description: Restaure l'inventaire du joueur au slot donné depuis le snapshot via `swap_stack`. No-op si aucun snapshot n'existe.
---@param define defines.inventory
---@return RitnLibInventory self  Chainable
function RitnLibInventory:loadInventory(define)
    if self.data[self.name] == nil then return self end

    local inventory1 = self.player.get_inventory(define)
    local inventory = self.data[self.name][define]
    if inventory1 ~= nil then
        for i = 1, #inventory1 do
            local stack = inventory[i]
            if stack.valid then
                inventory1[i].swap_stack(stack)
            end
        end
    end

    return self
end

--insertInventory

---**EN**
---
---Description: `LuaPlayer.insert`'s every stack from the snapshot into the player's current inventory. Doesn't clear the snapshot.
---
---──────────────────────────────
---
---**FR**
---
---Description: `LuaPlayer.insert` chaque stack du snapshot dans l'inventaire courant du joueur. Ne vide pas le snapshot.
---@param define defines.inventory
---@return RitnLibInventory self  Chainable
function RitnLibInventory:insertInventory(define)
    if self.data[self.name] == nil then return self end
    log('> ' .. self.object_name .. ':insertInventory(define) : -> define = ' .. define)

    local inventory = self.data[self.name][define]
    if inventory ~= nil then
        if (#inventory > 0) then
            for i = 1, #inventory do
                local stack = inventory[i]
                if stack.valid and stack.valid_for_read then
                    self.player.insert { name = stack.name, count = stack.count }
                    log('> self.player.insert(stack) -> stack = {name="' ..
                        stack.name .. '", count="' .. stack.count .. '"}')
                end
            end
        end
    end

    return self
end

--deleteInventory

---**EN**
---
---Description: Clears the player's inventory at the given slot.
---
---──────────────────────────────
---
---**FR**
---
---Description: Vide l'inventaire du joueur au slot donné.
---@param define defines.inventory
---@return RitnLibInventory self  Chainable
function RitnLibInventory:deleteInventory(define)
    self.player.get_inventory(define).clear()
    return self
end

----------------------------------------------------------------
-- SAVE ALL INVENTORY

---**EN**
---
---Description: Saves all 5 character inventories (main/guns/ammo/armor/trash).
---
---──────────────────────────────
---
---**FR**
---
---Description: Sauvegarde les 5 inventaires character (main/guns/ammo/armor/trash).
---@return RitnLibInventory self  Chainable
function RitnLibInventory:save_all_inventory()
    self:saveInventory(defines.inventory.character_main)
    self:saveInventory(defines.inventory.character_guns)
    self:saveInventory(defines.inventory.character_ammo)
    self:saveInventory(defines.inventory.character_armor)
    self:saveInventory(defines.inventory.character_trash)

    return self
end

-- LOAD ALL INVENTORY

---**EN**
---
---Description: Loads all 5 character inventories in order armor → main → guns → ammo → trash. Armor first is intentional to avoid item-loss when the player has no armor slot.
---
---──────────────────────────────
---
---**FR**
---
---Description: Charge les 5 inventaires character dans l'ordre armor → main → guns → ammo → trash. Armor en premier est intentionnel pour éviter la perte d'items quand le joueur n'a pas de slot d'armure.
---@return RitnLibInventory self  Chainable
function RitnLibInventory:load_all_inventory()
    self:loadInventory(defines.inventory.character_armor) -- /!\ priority armor
    self:loadInventory(defines.inventory.character_main)
    self:loadInventory(defines.inventory.character_guns)
    self:loadInventory(defines.inventory.character_ammo)
    self:loadInventory(defines.inventory.character_trash)

    return self
end

-- INSERT ALL INVENTORY

---**EN**
---
---Description: Inserts all snapshots back into the live player (armor priority first). Trash is intentionally skipped.
---
---──────────────────────────────
---
---**FR**
---
---Description: Insère tous les snapshots dans le joueur courant (armor en priorité). Trash est intentionnellement skip.
---@return RitnLibInventory self  Chainable
function RitnLibInventory:insert_all_inventory()
    self:insertInventory(defines.inventory.character_armor) -- /!\ priority armor
    self:insertInventory(defines.inventory.character_main)
    self:insertInventory(defines.inventory.character_guns)
    self:insertInventory(defines.inventory.character_ammo)

    return self
end

-- DELETE ALL INVENTORY

---**EN**
---
---Description: Clears all 5 character inventories on the live player.
---
---──────────────────────────────
---
---**FR**
---
---Description: Vide les 5 inventaires character sur le joueur courant.
function RitnLibInventory:delete_all_inventory()
    self:deleteInventory(defines.inventory.character_main)
    self:deleteInventory(defines.inventory.character_guns)
    self:deleteInventory(defines.inventory.character_ammo)
    self:deleteInventory(defines.inventory.character_armor)
    self:deleteInventory(defines.inventory.character_trash)
end

----------------------------------------------------------------
-- CURSOR
----------------------------------------------------------------

-- Save Cursor

---**EN**
---
---Description: Swaps the player's `cursor_stack` with the `["cursor"]` 1-slot snapshot via `swap_stack`. Used both for save and for load thanks to swap symmetry.
---
---──────────────────────────────
---
---**FR**
---
---Description: Échange le `cursor_stack` du joueur avec le snapshot 1-slot `["cursor"]` via `swap_stack`. Utilisée à la fois pour save et pour load grâce à la symétrie de swap.
---@return RitnLibInventory self  Chainable
function RitnLibInventory:saveCursor()
    if self.data[self.name] == nil then self:init() end

    local stack = self.player.cursor_stack
    if stack.valid then
        self.data[self.name]["cursor"][1].swap_stack(stack)
    end

    return self
end

-- Load Cursor

---**EN**
---
---Description: Loads the cursor stack from the snapshot via `swap_stack`. Equivalent to a second call of `:saveCursor()` due to swap symmetry.
---
---──────────────────────────────
---
---**FR**
---
---Description: Charge le cursor stack depuis le snapshot via `swap_stack`. Équivalent à un second appel de `:saveCursor()` du fait de la symétrie de swap.
---@return RitnLibInventory self  Chainable
function RitnLibInventory:loadCursor()
    if self.data[self.name] == nil then return self end

    local stack = self.data[self.name]["cursor"][1]
    if stack.valid then
        self.player.cursor_stack.swap_stack(stack)
    end

    return self
end

-- Delete Cursor

---**EN**
---
---Description: Clears the player's `cursor_stack` (live).
---
---──────────────────────────────
---
---**FR**
---
---Description: Vide le `cursor_stack` du joueur (live).
---@return RitnLibInventory self  Chainable
function RitnLibInventory:deleteCursor()
    local stack = self.player.cursor_stack
    if stack.valid then
        self.player.cursor_stack.clear()
    end

    return self
end

----------------------------------------------------------------

--- MASTER SAVE

---**EN**
---
---Description: Master save: all character inventories + logistic (currently no-op) + optionally cursor.
---
---──────────────────────────────
---
---**FR**
---
---Description: Master save : tous les inventaires character + logistique (currently no-op) + optionnellement cursor.
---@param cursor? boolean   When true, also calls `:saveCursor`
---@return RitnLibInventory self  Chainable
function RitnLibInventory:save(cursor)
    if self.data[self.name] == nil then self:init() end
    local option = false
    if cursor ~= nil then option = cursor end
    log('> ' .. self.object_name .. ':save(' .. tostring(option) .. ') -> ' .. self.name)

    self:save_all_inventory()
    if option then self:saveCursor() end

    return self
end

--- MASTER LOAD

---**EN**
---
---Description: Master load: all character inventories + logistic (currently no-op) + optionally cursor. Note: when `cursor == true`, calls `:saveCursor()` — the swap symmetry means this restores the cursor correctly after a prior `:save(true)`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Master load : tous les inventaires character + logistique (currently no-op) + optionnellement cursor. Note : quand `cursor == true`, appelle `:saveCursor()` — la symétrie de swap fait que ça restaure correctement le cursor après un `:save(true)` préalable.
---@param cursor? boolean   When true, calls `:saveCursor` (which restores cursor via swap symmetry)
---@return RitnLibInventory self  Chainable
function RitnLibInventory:load(cursor)
    if self.data[self.name] == nil then return self end
    local option = false
    if cursor ~= nil then option = cursor end
    log('> ' .. self.object_name .. ':load(' .. tostring(option) .. ') -> ' .. self.name)

    self:load_all_inventory()
    if option then self:saveCursor() end

    return self
end

-- MASTER INSERT

---**EN**
---
---Description: Master insert: re-injects the snapshot into the live player (armor/main/guns/ammo, no trash).
---
---──────────────────────────────
---
---**FR**
---
---Description: Master insert : ré-injecte le snapshot dans le joueur courant (armor/main/guns/ammo, sans trash).
---@return RitnLibInventory self  Chainable
function RitnLibInventory:insert()
    if self.data[self.name] == nil then return self end
    log('> ' .. self.object_name .. ':insert() -> ' .. self.name)

    self:insert_all_inventory() --:insertLogistic()

    return self
end

-- MASTER DELETE

---**EN**
---
---Description: Master delete: clears all character inventories + cursor on the live player.
---
---──────────────────────────────
---
---**FR**
---
---Description: Master delete : vide tous les inventaires character + cursor sur le joueur courant.
function RitnLibInventory:delete()
    log('> ' .. self.object_name .. ':delete() -> ' .. self.name)

    self:delete_all_inventory()
    self:deleteCursor()

    return self
end
