lua-itertools
=============

[![Build Status](https://travis-ci.org/aperezdc/lua-itertools.svg?branch=master)](https://travis-ci.org/aperezdc/lua-itertools)
[![Coverage Status](https://coveralls.io/repos/github/aperezdc/lua-itertools/badge.svg?branch=master)](https://coveralls.io/github/aperezdc/lua-itertools?branch=master)
[![Documentation](https://img.shields.io/badge/doc-api-blue.png)](https://aperezdc.github.io/lua-itertools)


Example
-------

```lua
-- Import the module.
local itertools = require "itertools"

-- Create an infinite iterator which produces numbers starting at 100
local iterable = itertools.count(100)

-- Filter (select) the numbers which are divisible by three.
iterable = itertools.filter(function (x) return x % 3 == 0 end, iterable)

-- Pick only 10 of the numbers.
iterable = itertools.islice(iterable, 1, 10)

-- Calculate the square of each number
iterable = itertools.map(function (x) return x * x end, iterable)

-- Print them using a for-loop.
for item in iterable do print(item) end
```

