local Monad = require("monad")

---@class mona.Identity<T>: mona.Monad<T>
---@field value T
local Identity = Monad:extend()

---@generic T
---@param value T
---@return mona.Identity<T>
function Identity.pure(value)
    return setmetatable({ value = value }, Identity)
end

---@generic T
---@param self mona.Identity<mona.Identity<T>>
---@return mona.Identity<T>
function Identity:join()
    return self.value
end

---@generic T
---@param self mona.Identity<T>
---@return T
function Identity:unwrap()
    return self.value
end

return Identity
