--[[
For functions :
- standard_3x3_collision
- standard_3x3_selection
- standard_status_light
- standard_status_colours
- get_layer
]]--


--[[
  name =
  sprite_path =
  line_length =
  shadow =
  repeat_count =
  animation_speed =
  width =
  height =
  x =
  y =
  tw =
  th =
  shift =
  blend_mode =
  flags =
  tint =
  direction_count =
  apply_runtime_tint =
  run_mode =
  scale =
  sequence =
]]

---**EN**
---
---Description: Returns the standard collision box for a 3x3 entity: `{{-1.25,-1.25},{1.25,1.25}}`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne la collision box standard d'une entité 3x3 : `{{-1.25,-1.25},{1.25,1.25}}`.
---@return number[][]
local function standard_3x3_collision()
  return { {-1.25,-1.25}, {1.25,1.25} }
end

---**EN**
---
---Description: Returns the standard selection box for a 3x3 entity: `{{-1.5,-1.5},{1.5,1.5}}`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne la selection box standard d'une entité 3x3 : `{{-1.5,-1.5},{1.5,1.5}}`.
---@return number[][]
local function standard_3x3_selection()
  return { {-1.5,-1.5}, {1.5,1.5} }
end

---**EN**
---
---Description: Computes the centering shift (in tiles, /64 px) for a sprite of size `w`×`h` positioned at `(x,y)` inside a spritesheet of total size `tw`×`th`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Calcule le shift de centrage (en tiles, /64 px) pour un sprite de taille `w`×`h` positionné à `(x,y)` dans une spritesheet de taille totale `tw`×`th`.
---@param x number
---@param y number
---@param tw number   Total spritesheet width
---@param th number   Total spritesheet height
---@param w number    Sprite width
---@param h number    Sprite height
---@return number[]
local function shift_calc(x,y,tw,th,w,h)
	return {((tw/2) - (x + (w/2)))/64, ((th/2) - (y + (h/2)))/64}
end

---**EN**
---
---Description: Component-wise subtraction of two `{x, y}` shifts.
---
---──────────────────────────────
---
---**FR**
---
---Description: Soustraction composante par composante de deux shifts `{x, y}`.
---@param shift1 number[]
---@param shift2 number[]
---@return number[]
local function offset(shift1, shift2)
	return ({shift1[1]-shift2[1], shift1[2]-shift2[2]})
end

---**EN**
---
---Description: Builds a Factorio sprite/animation definition table from a flat `data` descriptor (see field list in the header comment). Special handling: `shadow` accepts `true`/`"shadow"`/`"light"`/`"glow"`; a negative `frame_count` is converted to `variation_count`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Construit une table de définition sprite/animation Factorio depuis un descripteur plat `data` (voir liste des champs dans le commentaire d'entête). Gestion spéciale : `shadow` accepte `true`/`"shadow"`/`"light"`/`"glow"` ; un `frame_count` négatif est converti en `variation_count`.
---@param data table  Flat sprite descriptor (`name`, `sprite_path`, `width`, `height`, `shift`, `frame_count`, `shadow`, …)
---@return table      Factorio sprite definition
local function get_sprite_def(data)
	local variation_count = nil
  local shadow = data.shadow
	if data.frame_count and data.frame_count < 0 then
		variation_count = math.abs(data.frame_count)
		data.frame_count = nil
	end
	if shadow == true then shadow = "shadow" elseif shadow == false then shadow = nil end
	return {
		draw_as_shadow = (shadow == "shadow"),
		draw_as_light = (shadow == "light"),
		draw_as_glow = (shadow == "glow"),
		filename = string.format("%s/%s.png", data.sprite_path , data.name),
		blend_mode = data.blend_mode,
		animation_speed = data.animation_speed,
		repeat_count = data.repeat_count,
		frame_count = data.frame_count,
		direction_count = data.direction_count,
		line_length = data.line_length,
		height = data.height,
		width = data.width,
		x = data.x,
		y = data.y,
		scale = data.scale,
		shift = data.shift,
		tint = data.tint,
		apply_runtime_tint = data.apply_runtime_tint,
		run_mode = data.run_mode,
		priority = "high",
		flags = data.flags,
		variation_count = data.variation_count,
		frame_sequence = data.sequence,
	}
end


---**EN**
---
---Description: Like `get_sprite_def`, but first recentres `data.shift` by subtracting the spritesheet-centering offset computed by `shift_calc` (requires `data.x/y/tw/th/width/height`). Main entry point for building layered entity animations.
---
---──────────────────────────────
---
---**FR**
---
---Description: Comme `get_sprite_def`, mais recentre d'abord `data.shift` en soustrayant l'offset de centrage spritesheet calculé par `shift_calc` (nécessite `data.x/y/tw/th/width/height`). Point d'entrée principal pour construire des animations d'entités en layers.
---@param data table  Flat sprite descriptor (with `tw`/`th` total sheet dims when `shift` is set)
---@return table      Factorio sprite definition
local function get_layer(data)
  local shift = data.shift
	if shift then data.shift = offset(data.shift, shift_calc(data.x, data.y, data.tw, data.th, data.width, data.height)) end
	return get_sprite_def(data)
end

---**EN**
---
---Description: HSV→RGBA conversion with fixed saturation 0.75 and value 1. `h` is the hue in `[0, 1]`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Conversion HSV→RGBA avec saturation fixe 0.75 et value 1. `h` est la teinte dans `[0, 1]`.
---@param h number  Hue in [0, 1]
---@return Color
local function rgba(h)
	  local a, v, s = 1, 1, 0.75
    local r, g, b
    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    return { r = r, g = g, b = b, a = a }
end

---**EN**
---
---Description: Returns a standard `status_colors` table for crafting-machine prototypes — blue-ish idle, red disabled/low_power, orange-ish full_output/insufficient_input, green working, transparent no_power.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne une table `status_colors` standard pour les prototypes de machines de craft — idle bleuté, disabled/low_power rouge, full_output/insufficient_input orangé, working vert, no_power transparent.
---@return table
local function standard_status_colours()
  return {
      no_power = {0,0,0,0}, -- transparent
      idle = rgba(7/12),
      no_minable_resources = rgba(7/12),
      disabled = rgba(1),
      full_output = rgba(1/12),
      insufficient_input = rgba(1/12),
      low_power = rgba(1),
      working = rgba(4/12),
  }
end

---**EN**
---
---Description: Returns a standard status-light descriptor (`intensity = 0.5`, `size = 3`, slight downward shift) for crafting-machine prototypes.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un descripteur de status-light standard (`intensity = 0.5`, `size = 3`, léger shift vers le bas) pour les prototypes de machines de craft.
---@return table
local function standard_status_light()
  return {
      intensity = 0.5,
      size = 3,
      shift = {0,0.75-(6/64)},
  }
end

-------------------------------------------------------------

---**EN**
---
---Description: RitnLib entity-graphics data-stage helpers — collision/selection boxes, sprite layer builder, status colours/light presets.
---
---──────────────────────────────
---
---**FR**
---
---Description: Helpers data-stage graphismes d'entités de RitnLib — collision/selection boxes, builder de layers de sprites, presets de couleurs/lumière de statut.
---@class RitnLibEntityFunctions
---@field standard_3x3_collision fun(): number[][]
---@field standard_3x3_selection fun(): number[][]
---@field standard_status_light fun(): table
---@field standard_status_colours fun(): table
---@field get_layer fun(data: table): table
local flib = {}
flib.standard_3x3_collision = standard_3x3_collision
flib.standard_3x3_selection = standard_3x3_selection
flib.standard_status_light = standard_status_light
flib.standard_status_colours = standard_status_colours
flib.get_layer = get_layer

return flib
