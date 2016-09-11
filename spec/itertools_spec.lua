--
-- itertools_spec.lua
-- Copyright (C) 2016 Adrian Perez <aperez@igalia.com>
--
-- Distributed under terms of the MIT license.
--

local iter = require "itertools"

describe("itertools.map", function ()
   it("iterates", function ()
      local input = { 1, 2, 3, 4, 5 }
      local l = iter.collect(iter.map(function (x) return x + 1 end,
                             iter.each(input)))
      for i = 1, #l do
         assert.equal(i + 1, l[i])
      end
   end)
end)

describe("itertools.keys", function ()
   it("iterates over table keys", function ()
      local t = { foo = 1, bar = 2, baz = 3 }
      local l = { }
      for k in iter.keys(t) do
         table.insert(l, k)
      end
      assert.equal(3, #l)
      assert.truthy(t[l[1]])
      assert.truthy(t[l[2]])
      assert.truthy(t[l[3]])
      local m = { }
      for k, _ in pairs(t) do
         table.insert(m, k)
      end
      assert.equal(#m, #l)
      table.sort(m)
      table.sort(l)
      for i = 1, #m do
         assert.equal(m[i], l[i])
      end
   end)
end)

describe("itertools.sorted", function ()
   it("iterates over sorted items", function ()
      local data = { 1, 45, 9, 2, -2, 42, 0, 42 }
      local sorted = iter.collect(iter.sorted(iter.values(data)))
      assert.equal(#data, #sorted)
      table.sort(data)
      for i = 1, #data do
         assert.equal(data[i], sorted[i])
      end
   end)

   it("can sort in reverse order", function ()
      local data = { 1, 45, 9, 2, -2, 42, 0, 42 }
      local sorted = iter.collect(iter.sorted(iter.values(data), nil, true))
      assert.equal(#data, #sorted)
      table.sort(data, function (a, b) return a >= b end)
      for i = 1, #data do
         assert.equal(data[i], sorted[i])
      end
   end)

   it("accepts a 'sort key' function", function ()
      local data = { { z = 1 }, { z = 0 }, { z = 42 }, { z = -1 } }
      local sorted = iter.collect(iter.sorted(iter.values(data),
                                  function (v) return v.z end))
      assert.equal(#data, #sorted)
      table.sort(data, function (a, b) return a.z < b.z end)
      for i = 1, #data do
         assert.equal(data[i], sorted[i])
      end
   end)
end)
