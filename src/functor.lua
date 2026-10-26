---@class mona.Functor<T>
local Functor = {}
Functor.__index = Functor

---@return table
function Functor:extend()
    local subclass = setmetatable({}, self)
    subclass.__index = subclass
    return subclass
end

---@generic T, U
---@param self mona.Functor<T>
---@param fn fun(value:T): U
---@return mona.Functor<U>
---@diagnostic disable-next-line: unused-local
function Functor:map(fn)
    error("Functor.map must be implemented by a Functor instance", 2)
end

return Functor
