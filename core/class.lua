-- class.lua
-- Compatible with Lua 5.1 (not 5.0).

---@class RitnClassFactory
---@field newclass fun(super: table|fun(self: any, ...: any): any, init?: fun(self: any, ...: any): any): table
---@field new fun(super: table|fun(self: any, ...: any): any, init?: fun(self: any, ...: any): any): table

---Creates a new class, optionally inheriting from a parent.
---
---Usage:
--- ```lua
--- local A = newclass(function(self, arg) self.value = arg end)
--- local B = newclass(A, function(self, arg) A.init(self, arg); self.extra = 42 end)
--- local instance = B(10)
--- instance:is_a(A) -- true
--- ```
---
---The returned class is callable: `MyClass(args)` creates an instance and runs `init`.
---Each instance gains an `:is_a(klass)` method that walks the `_super` chain.
---⚠ The parent's fields are shallow-copied into the child class — shared tables remain shared by reference.
---@param super table|fun(self: any, ...: any): any  Parent class (when inheriting) or init function (when no parent)
---@param init? fun(self: any, ...: any): any        Init function (required only when first arg is a parent class)
---@return table  The new class with `__call` constructor and `:is_a()`
local function newclass(super, init)
    local c = {}    -- a new class instance
    if not init and type(super) == 'function' then
        init = super
        super = nil
    elseif type(super) == 'table' then
        -- our new class is a shallow copy of the super class!
        for i,v in pairs(super) do
            c[i] = v
        end
        c._super = super
    end
    -- the class will be the metatable for all its objects,
    -- and they will look up their methods in it.
    c.__index = c

    -- expose a constructor which can be called by <classname>(<args>)
    local mt = {}
    mt.__call = function(class_tbl, ...)
        local obj = {}
        setmetatable(obj,c)
        if init then
            init(obj,...)
        else
            -- make sure that any stuff from the super class is initialized!
            if super and super.init then
                super.init(obj, ...)
            end
        end
        return obj
    end
    c.init = init
    c.is_a = function(self, klass)
        local m = getmetatable(self)
        while m do
            if m == klass then return true end
                m = m._super
            end
        return false
    end
    setmetatable(c, mt)
    return c
end



---⚠ **Deprecated / unused.** Alternative variant of `newclass` kept in parallel during early development. Not referenced anywhere in the codebase. Scheduled for removal — do not write new code against it.
---@param super table|fun(self: any, ...: any): any
---@param init? fun(self: any, ...: any): any
---@return table
local function new(super, init)
    local instance = {}  -- a new class instance

    if not init and type(super) == 'function' then
        init = super
        super = nil
    elseif type(super) == 'table' then
        -- our new class is a shallow copy of the super class!
        for i, v in pairs(super) do
            instance[i] = v
        end
        instance._super = super
    end

    -- the class will be the metatable for all its objects,
    -- and they will look up their methods in it.
    instance.__index = instance

    -- expose a constructor which can be called by <classname>(<args>)
    local vMetatable = {}
    vMetatable.__call = function(class_tbl, ...)
        local obj = {}
        setmetatable(obj, instance)
        if init then
            init(obj, ...)
        else
            -- make sure that any stuff from the super class is initialized!
            if super and super.__call then
                super.__call(class_tbl, obj, ...)
            end
        end
        return obj
    end

    instance.is_a = function(self, klass)
        local metatable = getmetatable(self)
        while metatable do
            if metatable == klass then return true end
                metatable = metatable._super
            end
        return false
    end

    setmetatable(instance, vMetatable)

    return instance
end

-------------------------
---@type RitnClassFactory
local class = {
    newclass = newclass,
    new = new,
}
return class
