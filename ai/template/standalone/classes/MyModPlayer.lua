---------------------------------------------------------------------------------------------
-- MYMOD PLAYER
---------------------------------------------------------------------------------------------
-- FR : Copié de gvv 0.6 (lui-même adapté de RitnLib), renommé pour MyMod. Garder la mention de la source.
-- EN : Copied from gvv 0.6 (itself adapted from RitnLib), renamed for MyMod. Keep the source note.
-- FR : Source : RitnLib (Ritn), classes/LuaClass/RitnPlayer.lua (RitnLibPlayer), version 0.10.7.
--      Wrapper temporaire d'un LuaPlayer, copié et adapté pour que MyMod reste autonome.
--      Différences : seuls les champs utiles à MyMod sont repris (pas de surface, force, véhicule...),
--      vérifications via check.lua, ajout de l'accès aux données MyMod du joueur (storage.players)
--      et du droit d'utiliser MyMod.
-- EN : Source: RitnLib (Ritn), classes/LuaClass/RitnPlayer.lua (RitnLibPlayer), version 0.10.7.
--      Temporary wrapper of a LuaPlayer, copied and adapted so MyMod stays standalone.
--      Differences: only the fields useful to MyMod are kept (no surface, force, vehicle...),
--      checks through check.lua, added access to the player's MyMod data (storage.players)
--      and to the right to use MyMod.
---------------------------------------------------------------------------------------------
-- FR : Utilisation : MyModPlayer(LuaPlayer) crée un objet temporaire, jamais rangé dans storage.
--      On en crée un nouveau à chaque évènement : il reflète toujours l'état actuel du joueur.
-- EN : Usage: MyModPlayer(LuaPlayer) creates a temporary object, never stored in storage.
--      A new one is created on each event: it always reflects the current player state.
---------------------------------------------------------------------------------------------
local check = require(mymod.defines.lualib.common.check)
---------------------------------------------------------------------------------------------


---**EN**
---
---Description: Wrapper of a LuaPlayer for MyMod: copies the useful player fields (snapshot), gives access to the
---player's MyMod data (`storage.players[index]`) and to the right to use MyMod. Base of every MyMod window.
---
---⚠ Temporary wrapper, created on each event. Do not store the instance in `storage`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Wrapper d'un LuaPlayer pour MyMod : copie les champs utiles du joueur (instantané), donne accès aux
---données MyMod du joueur (`storage.players[index]`) et au droit d'utiliser MyMod. Base de toutes les fenêtres.
---
---⚠ Wrapper temporaire, créé à chaque évènement. Ne pas stocker l'instance dans `storage`.
---@class MyModPlayer
---@field object_name string     "MyModPlayer" (overridden by sub-classes)
---@field isPresent boolean      True if the player is valid; otherwise methods do nothing
---@field player LuaPlayer       Wrapped player (live reference)
---@field index uint             Player index (key of `storage.players`)
---@field name string            Player name (snapshot)
---@field admin boolean          Admin flag (snapshot)
---@field connected boolean      Connected flag (snapshot)
---@operator call(LuaPlayer?): MyModPlayer
---@type MyModPlayer
MyModPlayer = mymod.classFactory.newclass(function(self, LuaPlayer)
    -- FR : Nom de la classe, utile dans les logs
    -- EN : Class name, useful in logs
    self.object_name = "MyModPlayer"

    -- FR : Vérification du paramètre : il faut un LuaPlayer encore valide.
    --      Sinon l'objet reste « absent » (isPresent = false) et ses méthodes ne font rien.
    -- EN : Parameter check: a LuaPlayer still valid is required.
    --      Otherwise the object stays "absent" (isPresent = false) and its methods do nothing.
    self.isPresent = false
    if check.dataType(LuaPlayer) ~= "LuaPlayer" or not check.isValidLuaObject(LuaPlayer) then
        log('> MyModPlayer : not a valid LuaPlayer !')
        return
    end
    self.isPresent = true

    --------------------------------------------------
    -- FR : Copie des informations du joueur utiles à MyMod
    -- EN : Copy of the player information useful to MyMod
    self.player = LuaPlayer                 -- FR : le LuaPlayer lui-même / EN : the LuaPlayer itself
    self.index = LuaPlayer.index            -- FR : index, clé de storage.players / EN : index, key of storage.players
    self.name = LuaPlayer.name              -- FR : nom affiché / EN : displayed name
    self.admin = LuaPlayer.admin            -- FR : admin ? (droit d'utiliser MyMod en multijoueur) / EN : admin? (right to use MyMod in multiplayer)
    self.connected = LuaPlayer.connected    -- FR : connecté ? / EN : connected?
    --------------------------------------------------
end) --[[@as MyModPlayer]]
----------------------------------------------------------------


---**EN**
---
---Description: Prints a message to the player. A table is printed with serpent, any other value with tostring.
---A localised string ({"key", ...}) is printed as is.
---
---──────────────────────────────
---
---**FR**
---
---Description: Affiche un message au joueur. Une table est affichée avec serpent, une autre valeur avec tostring.
---Un texte localisé ({"clé", ...}) est affiché tel quel.
---@param text any
---@param color? Color
---@return MyModPlayer
function MyModPlayer:print(text, color)
    -- FR : Joueur absent ou invalide : rien à afficher
    -- EN : Missing or invalid player: nothing to print
    if not self.isPresent then
        return self
    end

    if check.isTable(text) and not check.isString(text[1]) then
        -- FR : Table ordinaire (pas un texte localisé) : on l'affiche en texte lisible
        -- EN : Ordinary table (not a localised string): print it as readable text
        text = serpent.block(text)
    elseif not check.isString(text) and not check.isTable(text) then
        -- FR : Nombre, booléen, nil... : converti en texte
        -- EN : Number, boolean, nil...: converted to text
        text = tostring(text)
    end

    -- FR : Affichage dans le chat du joueur
    -- EN : Print in the player's chat
    self.player.print(text, color)
    return self
end




---**EN**
---
---Description: The player's MyMod data (storage.players[index]), or nil if it does not exist yet
---(the player never opened MyMod).
---
---──────────────────────────────
---
---**FR**
---
---Description: Données MyMod du joueur (storage.players[index]), ou nil si elles n'existent pas encore
---(le joueur n'a jamais ouvert MyMod).
---@return table?
function MyModPlayer:getData()
    -- FR : Joueur absent ou invalide : pas de données
    -- EN : Missing or invalid player: no data
    if not self.isPresent then
        return nil
    end

    -- FR : storage.players[index], sans erreur si storage.players n'existe pas encore
    -- EN : storage.players[index], without error if storage.players doesn't exist yet
    return check.getPath(storage, {"players", self.index})
end


