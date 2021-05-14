---
-- Fonction "GUI"
---
local flib = {}

-- Create Frame
local function createFrame(source, name, caption, direction)
    local dir = "vertical"
    if direction ~= nil then dir = direction end
    
    local frame = 
    {
        type = "frame",
        direction = dir,
        name = name,
        caption = caption,
    }

    return source.add(frame)
end

--> auto_center = true (frame)
local function frameAutoCenter(frame)
    if frame.type == "frame" then 
        frame.auto_center = true
    end
end

-- Create Flow (vertical)
local function createFlowV(source, name, visible)
    local vis = true
    if visible ~= nil then vis = visible end

    local flow = {
        type = "flow",
        name = name,
        direction = "vertical",
        visible = vis,
    }

    return source.add(flow)
end

-- Create Flow (horizontal)
local function createFlowH(source, name, visible)
    local vis = true
    if visible ~= nil then vis = visible end

    local flow = {
        type = "flow",
        name = name,
        direction = "horizontal",
        visible = vis,
    }

    return source.add(flow)
end

-- Create Empty-widget
local function createLabel(source, name, caption, visible)
    local vis = true
    if visible ~= nil then vis = visible end

    local empty = {
        type = "label",
        name = name,
        caption = caption,
        visible = vis,
    }

    return source.add(empty)
end

-- Create Textfield
local function createTextField(source, name, text)
    local textfield = {
        type = "textfield",
        name = name,
    }
    return source.add(textfield)
end

-- Create Sprite-Button
local function createSpriteButton(source, name, sprite, style, tooltip)
    local sprite = {
        type = "sprite-button",
        name = name,
        sprite = sprite,
        style = style,
    }

    if tooltip ~= nil then 
        sprite.tooltip = tooltip
    end

    return source.add(sprite)
end

-- Create Button
local function createButton(source, name, caption, style)
    local button = {
        type = "button",
        name = name,
        caption = caption,
    }

    if style ~= nil then 
        button.style = style
    end

    return source.add(button)
end

-- Create Scroll-Pane
local function createScrollPane(source, name, horizontal_scroll_policy)
    local hsp = "never"
    if horizontal_scroll_policy ~= nil then hsp = horizontal_scroll_policy end

    local pane = {
        type = "scroll-pane",
        name = name,
        horizontal_scroll_policy = hsp,
    }

    return source.add(pane)
end


-- Create List-Box
local function createList(source, name)
    local list = {
        type = "list-box",
        name = name,
    }

    return source.add(list)
end


-- Create Empty-widget
local function createEmptyWidget(source)
    local empty = {
        type = "empty-widget",
    }

    return source.add(empty)
end

----------------------------
-- Chargement des fonctions
flib.createFrame = createFrame
flib.frameAutoCenter = frameAutoCenter
flib.createFlowV = createFlowV
flib.createFlowH = createFlowH
flib.createLabel = createLabel
flib.createTextField = createTextField
flib.createSpriteButton = createSpriteButton
flib.createButton = createButton
flib.createScrollPane = createScrollPane
flib.createList = createList
flib.createEmptyWidget = createEmptyWidget

-- Retourne la liste des fonctions
return flib