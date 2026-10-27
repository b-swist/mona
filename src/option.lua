local Monad = require("monad")

---@alias mona.OptionKind "some" | "none"

---@class mona.Option<T>: mona.Monad<T>
---@field kind mona.OptionKind
---@field value T
local Option = Monad:extend()

---@generic T
---@param value T
---@return mona.Option<T>
function Option.some(value)
    return setmetatable({ kind = "some", value = value }, Option)
end

---@generic T
---@return mona.Option<T>
function Option.none()
    return setmetatable({ kind = "none" }, Option)
end

---@param self mona.Option<any>
---@return boolean
function Option:is_some()
    return self.kind == "some"
end

---@param self mona.Option<any>
---@return boolean
function Option:is_none()
    return self.kind == "none"
end

Option.pure = Option.some

---@generic T, U
---@param self mona.Option<T>
---@param fn fun(value: T): mona.Option<U>
---@return mona.Option<U>
function Option:bind(fn)
    if self:is_some() then
        return fn(self.value)
    else
        return self
    end
end

---@param self mona.Option<T>
---@return T
function Option:unwrap()
    if self:is_some() then
        return self.value
    else
        error("tried to unwrap Option of kind `none`", 2)
    end
end

return Option
