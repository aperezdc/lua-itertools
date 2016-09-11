package = "itertools"
version = "scm-0"
source = {
   url = "git://github.com/aperezdc/lua-itertools"
}
description = {
   maintainer = "Adrián Pérez de Castro <aperez@igalia.com>",
   summary = "Functional iteration using coroutines",
   homepage = "https://github.com/aperezdc/lua-itertools",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      itertools = "itertools.lua"
   }
}
