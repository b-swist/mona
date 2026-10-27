local Applicative = require("applicative")

---@class mona.Monad<T>: mona.Applicative<T>
local Monad = Applicative:extend()

---@generic T
---@param self mona.Monad<mona.Monad<T>>
---@return mona.Monad<T>
function Monad:join()
    return self:bind(function(value)
        return value
    end)
end

---@generic T, U
---@param self mona.Monad<T>
---@param fn fun(value: T): mona.Monad<U>
---@return mona.Monad<U>
---@diagnostic disable-next-line: unused-local
function Monad:bind(fn)
    error("Monad.join must be implemented by a Monad instance", 2)
end

---@generic T, U
---@param self mona.Monad<T>
---@param fn fun(value:T): U
---@return mona.Monad<U>
function Monad:map(fn)
    return self:bind(function(value)
        return self.pure(fn(value))
    end)
end

---@generic T, U
---@param self mona.Monad<T>
---@param fns mona.Monad<fun(value: T): U>
---@return mona.Monad<U>
function Monad:apply(fns)
    return fns:bind(function(fn)
        return self:map(fn)
    end)
end

return Monad
