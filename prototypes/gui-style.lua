local fGui = require("__RitnLib__.lualib.gui-functions")
local suffix = fGui.SUFFIX -- "-ritngui"
local ritnGui

local default_gui = data.raw['gui-style'].default

-- hflow-ritngui (horizontal_flow)
default_gui['hflow'..suffix] = {
  type = "horizontal_flow_style",
  padding = 0,
  horizontal_spacing = 0,
}

-- vflow-ritngui (vertical_flow)
default_gui['vflow'..suffix] = {
  type = "vertical_flow_style",
  padding = 0,
  vertical_spacing = 0,
}

-- transparent-frame-ritngui (frame)
default_gui['transparent-frame'..suffix] = {
  type = "frame_style",
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0,
  horizontal_flow_style = {type = 'horizontal_flow_style', parent = 'hflow'..suffix},
  vertical_flow_style = {type = 'vertical_flow_style', parent = 'vflow'..suffix},
  graphical_set = {base = {center = {position = {25, 8}, size = {1, 1}}}},
}

-- highlighted-frame-ritngui (frame)
ritnGui = fGui.copyDefaultGui('highlighted-frame'..suffix, default_gui['transparent-frame'..suffix])
ritnGui.graphical_set.base.center = {position = {287, 79}, size = {1, 1}}

-- output-ritngui (label)
ritnGui = fGui.copyDefaultGui('output'..suffix, default_gui.label)
ritnGui.single_line = false

-- frame-ritngui (frame)
ritnGui = fGui.copyDefaultGui('frame'..suffix, default_gui.frame)
ritnGui.graphical_set.base.draw_type = 'outer'
ritnGui.graphical_set.base.center = {position = {25, 8}, size = {1, 1}}
ritnGui.top_padding = 0
ritnGui.right_padding = 0
ritnGui.bottom_padding = 0
ritnGui.left_padding = 0
ritnGui.horizontal_flow_style = default_gui['hflow'..suffix]
ritnGui.vertical_flow_style = default_gui['vflow'..suffix]

-- frame-bg-ritngui (frame)
ritnGui = fGui.copyDefaultGui('frame-bg'..suffix, default_gui.frame)
ritnGui.graphical_set = {base = {center = {position = {8, 8}, size = {1, 1}}}}
ritnGui.top_padding = 0
ritnGui.right_padding = 0
ritnGui.bottom_padding = 0
ritnGui.left_padding = 0
ritnGui.use_header_filler = false

-- frame-bg-ritngui (empty-widget)
ritnGui = fGui.convertEmpty('empty-frame-bg'..suffix)
ritnGui.graphical_set = {base = {center = {position = {8, 8}, size = {1, 1}}}}

ritnGui = fGui.copyDefaultGui('tabbed_pane_frame'..suffix, default_gui.tabbed_pane_frame)
ritnGui.top_padding = 0
ritnGui.right_padding = 0
ritnGui.bottom_padding = 0
ritnGui.left_padding = 0
ritnGui.graphical_set.base.center = {position = {25, 8}, size = {1, 1}}
ritnGui.graphical_set.base.bottom = nil

-- empty-tabbed_pane_frame-bg-ritngui (empty-widget)
ritnGui = fGui.convertEmpty('empty-tabbed_pane_frame-bg'..suffix)
ritnGui.graphical_set = {
  base = {
    center = {position = {76, 8}, size = {1, 1}},
    bottom = {position = {76, 9}, size = {1, 8}}
  },
  shadow = table.deepcopy(default_gui.subheader_frame.graphical_set.shadow)
}
ritnGui.horizontally_stretchable = 'on'

-- vertical-divider-ritngui (empty-widget)
ritnGui = fGui.convertEmpty('vertical-divider'..suffix)
ritnGui.graphical_set = {
  base = {
    left = {position = {68, 8}, size = {8, 1}},
    center = {position = {76, 8}, size = {1, 1}},
    right = {position = {77, 8}, size = {8, 1}}
  },
  shadow = table.deepcopy(default_gui.frame.graphical_set.shadow)
}
ritnGui.vertically_stretchable = 'on'

ritnGui = fGui.copyDefaultGui('tabbed_pane'..suffix, default_gui.tabbed_pane)
ritnGui.tab_content_frame.parent = 'tabbed_pane_frame'..suffix

ritnGui = fGui.copyDefaultGui('inside-wrap'..suffix, default_gui['frame'..suffix])
ritnGui.graphical_set = {
  base = {
    position = {17, 0}, corner_size = 8, draw_type = 'inner',
    center = {position = {25, 8}, size = {1, 1}},
  }
}

ritnGui = fGui.copyDefaultGui('inside_deep_frame'..suffix, default_gui.inside_deep_frame)
ritnGui.graphical_set.base = {
  center = {position = {336, 0}, size = {1, 1}},
  opacity = 0.75,
  background_blur = true
}

ritnGui = fGui.copyDefaultGui('scroll_pane'..suffix, default_gui.scroll_pane_under_subheader)
ritnGui.horizontally_stretchable = 'on'
ritnGui.vertically_stretchable = 'on'
ritnGui.horizontal_scrollbar_style = table.deepcopy(default_gui.scroll_pane.horizontal_scrollbar_style)
ritnGui.horizontal_scrollbar_style.height=18
ritnGui.horizontal_scrollbar_style.thumb_button_style = table.deepcopy(default_gui.horizontal_scrollbar.thumb_button_style)
ritnGui.horizontal_scrollbar_style.thumb_button_style.height=16
ritnGui.vertical_scrollbar_style = table.deepcopy(default_gui.scroll_pane.vertical_scrollbar_style)
ritnGui.vertical_scrollbar_style.width=18
ritnGui.vertical_scrollbar_style.thumb_button_style = table.deepcopy(default_gui.vertical_scrollbar.thumb_button_style)
ritnGui.vertical_scrollbar_style.thumb_button_style.width=16

ritnGui = fGui.copyDefaultGui('c_sub_mod'..suffix, default_gui.rounded_button)
ritnGui.horizontally_stretchable = 'on'
ritnGui.horizontally_squashable = 'off'
ritnGui.horizontal_align = "left"

ritnGui = fGui.convertEmpty('branch'..suffix)
ritnGui.graphical_set = {base = {center = {position = {76, 8}, size = {1, 1}}}}

ritnGui = fGui.convertEmpty('branch-hide'..suffix)
ritnGui.graphical_set = {base = {center = {position = {25, 8}, size = {1, 1}}}}

default_gui['tree-item'..suffix] = {
  type = "button_style",
  font = "default",
  horizontal_align = "left",
  vertical_align = "center",
  icon_horizontal_align = "left",
  default_font_color = {1, 1, 1},
  top_padding = 0,
  bottom_padding = 0,
  left_padding = 0,
  right_padding = 0,
  minimal_width = 1,
  minimal_height = 1,
  default_graphical_set = {base = {center = {position = {25, 8}, size = {1, 1}}}},
  hovered_font_color = {1, 1, 1},
  hovered_graphical_set =
  {
    base = {center = {position = {25, 8}, size = {1, 1}}},
    glow = table.deepcopy(default_gui.button.hovered_graphical_set.glow),
  },
  clicked_font_color = {1, 1, 1},
  clicked_vertical_offset = 0,
  clicked_graphical_set =
  {
    base = {center = {position = {8, 25}, size = {1, 1}}},
    glow = table.deepcopy(default_gui.button.hovered_graphical_set.glow),
  },
  left_click_sound = table.deepcopy(default_gui.button.left_click_sound),
  disabled_font_color = {179, 179, 179},
  disabled_graphical_set =
  {
    base = {center = {position = {25, 8}, size = {1, 1}}},
  },
  selected_font_color = button_hovered_font_color,
  selected_graphical_set =
  {
    base = {center = {position = {25, 8}, size = {1, 1}}},
  },
  selected_hovered_font_color = button_hovered_font_color,
  selected_hovered_graphical_set =
  {
    base = {center = {position = {25, 8}, size = {1, 1}}},
    glow = table.deepcopy(default_gui.button.hovered_graphical_set.glow),
  },
  selected_clicked_font_color = button_hovered_font_color,
  selected_clicked_graphical_set =
  {
    base = {center = {position = {8, 25}, size = {1, 1}}},
    glow = table.deepcopy(default_gui.button.hovered_graphical_set.glow),
  },
  strikethrough_color = {0.5, 0.5, 0.5},
  pie_progress_color = {1, 1, 1},
}

ritnGui = fGui.copyDefaultGui('tree-item-folder'..suffix, default_gui['tree-item'..suffix])
ritnGui.hovered_graphical_set.glow = table.deepcopy(default_gui.green_button.hovered_graphical_set.glow)
ritnGui.clicked_graphical_set.glow = table.deepcopy(default_gui.green_button.hovered_graphical_set.glow)
ritnGui.selected_hovered_graphical_set.glow = table.deepcopy(default_gui.green_button.hovered_graphical_set.glow)
ritnGui.selected_clicked_graphical_set.glow = table.deepcopy(default_gui.green_button.hovered_graphical_set.glow)

ritnGui = fGui.copyDefaultGui('load-cont'..suffix, default_gui['tree-item'..suffix])
ritnGui.hovered_graphical_set.glow = table.deepcopy(default_gui.red_button.hovered_graphical_set.glow)
ritnGui.clicked_graphical_set.glow = table.deepcopy(default_gui.red_button.hovered_graphical_set.glow)

ritnGui = fGui.copyDefaultGui('tracked-tree-item'..suffix, default_gui['tree-item'..suffix])
local a, b = 337, 56
ritnGui.default_graphical_set.base.center.position = {a, b}
ritnGui.hovered_graphical_set.base.center.position = {a, b}
ritnGui.disabled_graphical_set.base.center.position = {a, b}
ritnGui.selected_graphical_set.base.center.position = {a, b}
ritnGui.selected_hovered_graphical_set.base.center.position = {a, b}

ritnGui = fGui.copyDefaultGui('tracked-tree-item-folder'..suffix, default_gui['tree-item-folder'..suffix])
local a, b = 337, 56
ritnGui.default_graphical_set.base.center.position = {a, b}
ritnGui.hovered_graphical_set.base.center.position = {a, b}
ritnGui.disabled_graphical_set.base.center.position = {a, b}
ritnGui.selected_graphical_set.base.center.position = {a, b}
ritnGui.selected_hovered_graphical_set.base.center.position = {a, b}

ritnGui = fGui.copyDefaultGui('tree-item-luaobj'..suffix, default_gui['tree-item'..suffix])
ritnGui.hovered_graphical_set.glow = table.deepcopy(default_gui.red_button.hovered_graphical_set.glow)
ritnGui.clicked_graphical_set.glow = table.deepcopy(default_gui.red_button.hovered_graphical_set.glow)
ritnGui.selected_hovered_graphical_set.glow = table.deepcopy(default_gui.red_button.hovered_graphical_set.glow)
ritnGui.selected_clicked_graphical_set.glow = table.deepcopy(default_gui.red_button.hovered_graphical_set.glow)

ritnGui = fGui.copyDefaultGui('tracked-tree-item-luaobj'..suffix, default_gui['tree-item-luaobj'..suffix])
local a, b = 355, 161
ritnGui.default_graphical_set.base.center.position = {a, b}
ritnGui.hovered_graphical_set.base.center.position = {a, b}
ritnGui.disabled_graphical_set.base.center.position = {a, b}
ritnGui.selected_graphical_set.base.center.position = {a, b}
ritnGui.selected_hovered_graphical_set.base.center.position = {a, b}

ritnGui = fGui.copyDefaultGui('tree-item-func'..suffix, default_gui['tree-item'..suffix])
ritnGui.clicked_graphical_set = {base = {center = {position = {25, 8}, size = {1, 1}}}}
ritnGui.selected_clicked_graphical_set = {base = {center = {position = {25, 8}, size = {1, 1}}}}
ritnGui.hovered_graphical_set.glow = nil
ritnGui.clicked_graphical_set.glow = nil
ritnGui.selected_hovered_graphical_set.glow = nil
ritnGui.left_click_sound = nil

ritnGui = fGui.copyDefaultGui('tree-item-na'..suffix, default_gui['tree-item-func'..suffix])

ritnGui = fGui.copyDefaultGui('list_box_scroll_pane-transparent'..suffix, default_gui.list_box_scroll_pane)
ritnGui.background_graphical_set = {
  position = {187, 0},
  corner_size = 1,
  overall_tiling_vertical_size = 20,
  overall_tiling_vertical_spacing = 8,
  overall_tiling_vertical_padding = 4,
  overall_tiling_horizontal_padding = 4,
}
ritnGui.graphical_set = {base = {center = {position = {25, 8}, size = {1, 1}}}}

ritnGui = fGui.copyDefaultGui('list_box-transparent'..suffix, default_gui.list_box)
ritnGui.scroll_pane_style.parent = 'list_box_scroll_pane-transparent'..suffix
