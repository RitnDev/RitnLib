-- Properties
local stretch = true
local visible = false
local center = "center"

-- Declartion du LuaStyle général
local LuaStyle = {}


local function ritn_small_button(style)
    style.height = 30
    style.horizontally_stretchable = stretch
    style.minimal_width = 90
    style.maximal_width = 100
end

local function ritn_normal_button(style)
    style.minimal_height = 45
    style.minimal_width = 200
    style.horizontally_stretchable = stretch
end

local function ritn_sprite_button(style)
    style.padding = 0
    style.width = 32
    style.height = 32
end

local function ritn_button_close(style)
    ritn_small_button(style)
    style.width = 100
end

local function ritn_frame_style(style) 
    style.left_padding = 4
    style.right_padding = 4
    style.bottom_padding = 4
    style.maximal_height = 338
    style.maximal_width = 220
end

local function ritn_frame_remote_style(style)
    ritn_frame_style(style) 
    style.minimal_width = 220
    style.maximal_height = 310
end

local function ritn_flow_no_padding(style)
    style.padding = 0
end

local function ritn_flow_strechable(style)
    style.horizontally_stretchable = stretch
    style.vertically_stretchable = stretch
end

local function ritn_flow_panel_main(style)
    ritn_flow_no_padding(style)
    ritn_flow_strechable(style)
    style.vertical_spacing = 8
end

local function ritn_flow_dialog(style)
    ritn_flow_strechable(style)
    style.top_padding = 4
end

local function ritn_flow_surfaces(style)
    style.horizontal_align = center
    style.vertical_align = center
end

local function ritn_scroll_pane(style)
    style.minimal_height = 220
    style.horizontally_stretchable = stretch
end

local function ritn_remote_listbox(style)
    style.minimal_height = 220
    style.maximal_height = 220
    style.horizontally_stretchable = stretch
end

local function ritn_label(style)
    style.minimal_height = 25
end



-- Chargement des fonctions
LuaStyle.ritn_small_button       = ritn_small_button
LuaStyle.ritn_normal_button      = ritn_normal_button
LuaStyle.ritn_sprite_button      = ritn_sprite_button
LuaStyle.ritn_button_close       = ritn_button_close
LuaStyle.ritn_frame_style        = ritn_frame_style
LuaStyle.ritn_frame_remote_style = ritn_frame_remote_style
LuaStyle.ritn_flow_no_padding    = ritn_flow_no_padding
LuaStyle.ritn_flow_panel_main    = ritn_flow_panel_main
LuaStyle.ritn_flow_dialog        = ritn_flow_dialog
LuaStyle.ritn_flow_surfaces      = ritn_flow_surfaces
LuaStyle.ritn_scroll_pane        = ritn_scroll_pane
LuaStyle.ritn_remote_listbox     = ritn_remote_listbox
LuaStyle.ritn_label              = ritn_label

return LuaStyle