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

describe("itertools.items", function ()
   it("iterates over k/v pairs", function ()
      local data = { foo = 1, bar = 2, baz = 3 }
      local count = 0
      for pair in iter.items(data) do
         count = count + 1
         local k, v = pair[1], pair[2]
         assert.equal(data[k], v)
      end
      assert.equal(3, count)
   end)
end)

describe("itertools.count", function ()
   it("counts ad infinitum", function ()
      local nextvalue = iter.count()
      for i = 1, 10 do
         assert.equal(i, nextvalue())
      end
   end)
   it("counts from a given value", function ()
      local nextvalue = iter.count(10)
      for i = 10, 20 do
         assert.equal(i, nextvalue())
      end
   end)
   it("counts using a step", function ()
      local nextvalue = iter.count(nil, 2)
      for i = 1, 10, 2 do
         assert.equal(i, nextvalue())
      end
   end)
   it("counts from a given value using a step", function ()
      local nextvalue = iter.count(10, 5)
      for i = 10, 30, 5 do
         assert.equal(i, nextvalue())
      end
   end)
   it("accepts a negative step", function ()
      local nextvalue = iter.count(10, -1)
      for i = 10, 1, -1 do
         assert.equal(i, nextvalue())
      end
   end)
end)

describe("itertools.cycle", function ()
   it("repeats", function ()
      local nextvalue = iter.cycle(iter.values { "foo", "bar" })
      for i = 1, 10 do
         assert.equal("foo", nextvalue())
         assert.equal("bar", nextvalue())
      end
   end)
end)

describe("itertools.value", function ()
   it("always returns the same value", function ()
      local value = { foo = "bar" }
      local nextvalue = iter.value(value)
      for i = 1, 10 do
         assert.same(value, nextvalue())
      end
   end)
   it("accepts a number of times", function ()
      local value = { foo = "bar" }
      local result = iter.collect(iter.value(value, 15))
      assert.equal(15, #result)
      for i = 1, #result do
         assert.same(value, result[i])
      end
   end)
end)

describe("itertools.islice", function ()
   local function check(result, nextvalue)
      local count = 0
      for _, v in ipairs(result) do
         assert.equal(v, nextvalue())
         count = count + 1
      end
      assert.equal(count, #result)
   end

   local input = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

   it("skips elements at the beginning", function ()
      check({ 5, 6, 7, 8, 9, 10 },
            iter.islice(iter.values(input), 5))
   end)
   it("skips elements at the end", function ()
      check({ 1, 2, 3, 4 },
            iter.islice(iter.values(input), nil, 5))
   end)
   it("skips elements at both ends", function ()
      check({ 4, 5, 6, 7 },
            iter.islice(iter.values(input), 4, 7))
   end)
   it("returns one element for start==stop", function ()
      check({ 5 }, iter.islice(iter.values(input), 5, 6))
   end)
   it("returns no elements for an empty slice", function ()
      check({}, iter.islice(iter.values(input), 7, 3))
   end)
end)

describe("itertools.takewhile", function ()
   it("filters elements", function ()
      local data = { 1, 1, 1, 1, -1, 1, -1, 1, 1 }
      local result = iter.collect(iter.takewhile(function (x) return x > 0 end,
                                                 iter.values(data)))
      assert.equal(4, #result)
      for _, v in ipairs(result) do
         assert.equal(1, v)
      end
   end)
end)

describe("itertools.filter", function ()
   it("filters elements", function ()
      local data = { 6, 1, 2, 3, 4, 5, 6 }
      local result = iter.collect(iter.filter(function (x) return x < 4 end,
                                              iter.values(data)))
      assert.equal(3, #result)
      for i, v in ipairs(result) do
         assert.equal(i, v)
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
