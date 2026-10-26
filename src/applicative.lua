local Functor = require("functor")

---@class mona.Applicative<T>: mona.Functor<T>
local Applicative = Functor:extend()

---@generic T
---@param value T
---@return mona.Applicative<T>
---@diagnostic disable-next-line: unused-local
function Applicative.pure(value)
    error("Applicative.pure must be implemented by an Applicative instance", 2)
end

---@generic T, U
---@param self mona.Applicative<T>
---@param fn mona.Applicative<fun(value: T): U>
---@return mona.Applicative<U>
---@diagnostic disable-next-line: unused-local
function Applicative:apply(fn)
    error("Applicative.apply must be implemented by an Applicative instance", 2)
end

return Applicative
