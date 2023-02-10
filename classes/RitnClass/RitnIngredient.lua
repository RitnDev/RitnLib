-- RitnIngredient
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
----------------------------------------------------------------


local RitnIngredient = class.newclass(function(base, ingredient)
    if type(ingredient) ~= "table" and type(ingredient) ~= "string" then return end
    -- prototype base
    base.object_name = "RitnIngredient"
    base.ingredient = ingredient
    base.name = ingredient.name or ingredient[1]
    
    if type(ingredient) == "string" then 
        base.name = ingredient
    end

    log("RitnIngredient.name = " .. base.name)

    base.type = ingredient.type
    base.amount = ingredient.amount or ingredient[2]
    base.amount_min = ingredient.amount_min
    base.amount_max = ingredient.amount_max
    base.probability = ingredient.probability
    -- get basic type
    if not base.type then
        local item_type = "item"
        if data.raw.fluid[base.name] then item_type = "fluid" end
        base.type = item_type
    end
    -- get amount if not integer value
    if base.type == "item" then
        if base.amount then
            if base.amount > 0 and base.amount < 1 then
                base.amount = 1
            else
                base.amount = math.floor(base.amount)
            end
        end
    end
    --------------------------------------------------
    base.item = {
        name = base.name,
        type = base.type,
        amount = base.amount,
        amount_min = base.amount_min,
        amount_max = base.amount_max,
        probability = base.probability
    }
    base.addit = true
    --------------------------------------------------
end)


-- GET ITEM BY INGREDIENT
local function getItem(ingredient)
    local item = {}

    if ingredient.name then
        item.name = ingredient.name
    else
        item.name = ingredient[1]
    end

    if ingredient.amount then
        item.amount = ingredient.amount
    else
        if ingredient[2] then item.amount = ingredient[2] end
    end

    if not item.amount then
        if ingredient.amount_min and ingredient.amount_max then
            item.amount_min = ingredient.amount_min
            item.amount_max = ingredient.amount_max
        else
            item.amount = 1
        end
    end

    if ingredient.probability then item.probability = iingredientnputs.probability end

    if ingredient.type then
        item.type = ingredient.type
    else
        local item_type = "item"
        if data.raw.fluid[name] then item_type = "fluid" end
        item.type = item_type
    end

    if item.type == "item" then
        if item.amount > 0 and item.amount < 1 then
            item.amount = 1
        else
            item.amount = math.floor(item.amount)
        end
    end

    return item
end



-- COMBINE INGREDIENT
function RitnIngredient:combine(ingredient)
    --log("RitnIngredient - combine() - ingredient -> " .. ingredient.name)
    local item = {}
    local item1 = getItem(ingredient)
  
    item.name = item1.name
    item.type = item1.type
  
    if item1.amount and self.amount then
      item.amount = item1.amount + self.amount
    elseif item1.amount_min and item1.amount_max and self.amount_min and self.amount_max then
      item.amount_min = item1.amount_min + self.amount_min
      item.amount_max = item1.amount_max + self.amount_max
    else
      if item1.amount_min and item1.amount_max and self.amount then
        item.amount_min = item1.amount_min + self.amount
        item.amount_max = item1.amount_max + self.amount
      elseif item1.amount and self.amount_min and self.amount_max then
        item.amount_min = item1.amount + self.amount_min
        item.amount_max = item1.amount + self.amount_max
      end
    end
  
    if item1.probability and self.probability then
      item.probability = (item1.probability + self.probability) / 2
    elseif item1.probability then
      item.probability = (item1.probability + 1) / 2
    elseif self.probability then
      item.probability = (self.probability + 1) / 2
    end

    self.item = item
    return item
  end



 --increments amount if exists
function RitnIngredient:add(listIngredients)
    log("RitnIngredient - add() -> " .. self.name)
    for i, ingredient in pairs(listIngredients) do
        if ingredient[1] == self.name or ingredient.name == self.name then
            self.addit = false
            listIngredients[i] = self:combine(ingredient)
        end
    end

    if self.addit then table.insert(listIngredients, self.item) end
end


-- ignores if exists
function RitnIngredient:addNew(listIngredients) 
    log("RitnIngredient - addNew() -> " .. self.name)
    for i, ingredient in pairs(listIngredients) do
        if self.name == getItem(ingredient).name then self.addit = false end
    end
    if self.addit then table.insert(listIngredients, self.item) end
end


--remove ingredient
function RitnIngredient:remove(listIngredients)
    log("RitnIngredient - remove() -> " .. self.name)
    for i, ingredient in ipairs(listIngredients) do
        if ingredient[1] == self.name or ingredient.name == self.name then
            table.remove(listIngredients, i)
        end
    end
end


-- set ingredient
function RitnIngredient:set(listIngredients)
    log("RitnIngredient - set() -> " .. self.name)
    for i, ingredient in pairs(listIngredients) do
        if ingredient[1] == self.name or ingredient.name == self.name then
            listIngredients[i] = self.item
        end
    end
end


------------------------
return RitnIngredient