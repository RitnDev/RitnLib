-- if not ritnmods.lib.entity then ritnmods.lib.entity = {} end



-------------------------------------------------------------------------------
-- Calcule de : Selection_box
--
-- function ritnmods.lib.entity.selection_box
--
-- -- 471x471, 395x287    ,scale = 0.426
local function calcul_box(width_img, height_img, width_select, height_select, scale, collision)
    local center_img = {x, y}
    local center_select = {x, y}
    local offset = {x, y}

    local result = {{left, top }, {right, bottom}}

    center_img.x = width_img*scale/64                      -- 100.323 / 3.1
    center_img.y = height_img*scale/64                     -- 100.323 / 3.1
    center_select.x = width_select*scale/64                -- 84,135‬  / 2,63
    center_select.y = height_select*scale/64               -- 61,131‬  / 1.91
    offset.x = math.abs(center_img.x - center_select.x)   -- 16,188‬   / 0.47
    offset.y = math.abs(center_img.y - center_select.y)   -- 39,192‬   / 1.19

    if collision == true then
      result.left = (- center_select.x + offset.x)-0.1
      result.top = (- center_select.y + offset.y)-0.1
      result.right = (center_select.x + offset.x)-0.1
      result.bottom = (center_select.y + offset.y)-0.1
    else
      result.left = (- center_select.x + offset.x)    -- 
      result.top = (- center_select.y + offset.y)     -- 
      result.right = (center_select.x + offset.x)     -- 
      result.bottom = (center_select.y + offset.y)    -- 
    end

    return result
end


-- local collision = calcul_selection_box(471, 471, 395, 287, 0.426, true)
-- local selection = calcul_selection_box(471, 471, 395, 287, 0.426, false)

local flib = {}
flib.calcul_box = calcul_box

return flib