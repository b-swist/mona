local Monad = require("monad")
local Option = require("option")

---@class mona.List<T>: mona.Monad<T>
---@field value T[]
local List = Monad:extend()

---@param self mona.List<any>
---@return integer
function List:length()
    return #self.value
end

---@param self mona.List<any>
---@return boolean
function List:is_empty()
    return self:length() == 0
end

---@generic T
---@param self mona.List<T>
---@param i integer
---@return T
function List:at(i)
    return self.value[i]
end

---@generic T
---@param self mona.List<T>
---@return T
function List:head()
    return self:at(1)
end

---@generic T
---@param self mona.List<T>
---@return T
function List:last()
    return self:at(self:length())
end

---@protected
---@generic T
---@param values T[]
---@return mona.List<T>
function List._wrap(values)
    return setmetatable({ value = values }, List)
end

---@generic T
---@param self mona.List<T>
---@param n integer
---@return mona.List<T>
function List:take(n)
    return List._wrap(table.move(self.value, 1, n, 1, {}))
end

---@generic T
---@param self mona.List<T>
---@param n integer
---@return mona.List<T>
function List:drop(n)
    return List._wrap(table.move(self.value, n + 1, self:length(), 1, {}))
end

---@generic T
---@param self mona.List<T>
---@return mona.List<T>
function List:tail()
    return self:drop(1)
end

---@generic T
---@param self mona.List<T>
---@return mona.List<T>
function List:init()
    return self:take(self:length() - 1)
end

---@generic T
---@param self mona.List<T>
---@param xs mona.List<T>
---@return mona.List<T>
function List:append(xs)
    local copy = table.move(self.value, 1, self:length(), 1, {})
    return List._wrap(table.move(xs.value, 1, xs:length(), self:length() + 1, copy))
end

---@generic T
---@param self mona.List<T>
---@param xs mona.List<T>
---@return mona.List<T>
function List:prepend(xs)
    return xs:append(self)
end

---@generic T
---@return mona.List<T>
function List.empty()
    return List._wrap({})
end

---@generic T
---@param value T
---@return mona.List<T>
function List.pure(value)
    return List._wrap({ value })
end

---@generic T
---@param values T[]
---@return mona.List<T>
function List.from(values)
    local copy = table.move(values, 1, #values, 1, {})
    return List._wrap(copy)
end

---@generic T
---@param ... T
---@return mona.List<T>
function List.of(...)
    return List._wrap({ ... })
end

---@generic T
---@param self mona.List<T>
---@param fn fun(x: T): boolean
---@return mona.List<T>
function List:filter(fn)
    return self:bind(function(x)
        if fn(x) then
            return List.pure(x)
        else
            return List.empty()
        end
    end)
end

---@generic T
---@param self mona.List<T>
---@param fn fun(x: T): boolean
---@return mona.Option<T>
function List:find(fn)
    local head = self:filter(fn):head()
    if head ~= nil then
        return Option.some(head)
    else
        return Option.none()
    end
end

---@generic T, U
---@param self mona.List<T>
---@param fn fun(acc: U, x: T): U
---@param acc U
---@return U
function List:foldr(fn, acc)
    return self:_foldr(fn, acc, self:length())
end

---@protected
---@generic T, U
---@param self mona.List<T>
---@param fn fun(acc: U, x: T): U
---@param acc U
---@param i integer
---@return U
function List:_foldr(fn, acc, i)
    if i == 0 then
        return acc
    else
        return self:_foldr(fn, fn(acc, self:at(i)), i - 1)
    end
end

---@generic T, U
---@param self mona.List<T>
---@param fn fun(acc: U, x: T): U
---@param acc U
---@return U
function List:foldl(fn, acc)
    return self:_foldl(fn, acc, 1)
end

---@protected
---@generic T, U
---@param self mona.List<T>
---@param fn fun(acc: U, x: T): U
---@param acc U
---@param i integer
---@return U
function List:_foldl(fn, acc, i)
    if i > self:length() then
        return acc
    else
        return self:_foldl(fn, fn(acc, self:at(i)), i + 1)
    end
end

---@param self mona.List<number>
---@return number
function List:sum()
    return self:foldl(function(acc, x)
        return acc + x
    end, 0)
end

---@generic T
---@param ... mona.List<T>
---@return mona.List<T>
function List.concat(...)
    return List.join(List.of(...))
end

---@generic T, U
---@param self mona.List<T>
---@param fn fun(value: T): mona.List<U>
---@return mona.List<U>
function List:bind(fn)
    return self:foldr(function(acc, x)
        return fn(x):append(acc)
    end, List.empty())
end

return List
