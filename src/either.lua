local Monad = require("monad")

---@alias mona.EitherKind "left" | "right"

---@class mona.Either<E, T>: mona.Monad<T>
---@field kind mona.EitherKind
---@field value T
local Either = Monad:extend()

---@generic E, T
---@param value E
---@return mona.Either<E, T>
function Either.left(value)
    return setmetatable({ kind = "left", value = value }, Either)
end

---@generic E, T
---@param value T
---@return mona.Either<E, T>
function Either.right(value)
    return setmetatable({ kind = "right", value = value }, Either)
end

Either.pure = Either.right

---@param self mona.Either<any, any>
---@return boolean
function Either:is_right()
    return self.kind == "right"
end

---@param self mona.Either<any, any>
---@return boolean
function Either:is_left()
    return self.kind == "left"
end

---@generic E, T
---@param self mona.Either<E, T>
---@return T
function Either:get_right()
    if self:is_right() then
        return self.value
    else
        error("tried to access Either value of kind `right` when kind is `left`", 2)
    end
end

---@generic E, T
---@param self mona.Either<E, T>
---@return E
function Either:get_left()
    if self:is_left() then
        return self.value
    else
        error("tried to access Either value of kind `left` when kind is `right`", 2)
    end
end

---@generic T, U
---@param self mona.Either<T>
---@param fn fun(value: T): mona.Either<U>
---@return mona.Either<U>
function Either:bind(fn)
    if self:is_right() then
        return fn(self:get_right())
    else
        return self
    end
end

return Either
