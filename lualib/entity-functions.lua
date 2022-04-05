--[[
Licensed : CC BY-NC-ND 4.0 https://creativecommons.org/licenses/by-nc-nd/4.0/
Author: Deadlock989
Mod portal: https://mods.factorio.com/mod/IndustrialRevolution
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

local function standard_3x3_collision()
  return { {-1.25,-1.25}, {1.25,1.25} }
end

local function standard_3x3_selection()
  return { {-1.5,-1.5}, {1.5,1.5} }
end

local function shift_calc(x,y,tw,th,w,h)
	return {((tw/2) - (x + (w/2)))/64, ((th/2) - (y + (h/2)))/64}
end

local function offset(shift1, shift2)
	return ({shift1[1]-shift2[1], shift1[2]-shift2[2]})
end

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


local function get_layer(data) 
  local shift = data.shift
	if shift then data.shift = offset(data.shift, shift_calc(data.x, data.y, data.tw, data.th, data.width, data.height)) end
	return get_sprite_def(data)
end

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

local function standard_status_light()
  return {
      intensity = 0.5,
      size = 3,
      shift = {0,0.75-(6/64)},
  }
end

-------------------------------------------------------------
local flib = {}
flib.standard_3x3_collision = standard_3x3_collision
flib.standard_3x3_selection = standard_3x3_selection
flib.standard_status_light = standard_status_light
flib.standard_status_colours = standard_status_colours
flib.get_layer = get_layer

return flib