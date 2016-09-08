#! /usr/bin/env lua
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

