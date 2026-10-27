---@diagnostic disable: lowercase-global
package = "mona"
version = "dev-1"
source = {
    url = "git://github.com/b-swist/mona",
}
description = {
    homepage = "https://github.com/b-swist/mona",
    license = "MIT",
}
dependencies = {
    "lua >= 5.1",
}
build = {
    type = "builtin",
    modules = {
        ["mona.functor"] = "src/functor.lua",
        ["mona.applicative"] = "src/applicative.lua",
        ["mona.monad"] = "src/monad.lua",
        ["mona.identity"] = "src/identity.lua",
        ["mona.option"] = "src/option.lua",
        ["mona.either"] = "src/either.lua",
        ["mona.list"] = "src/list.lua",
    },
}
