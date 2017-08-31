package.path = package.path .. ";E:\\Projects\\lamda\\lamda\\?.lua"

local R = require("dist.lamda")

function id(v)
	return "id"..v
end

local curryid = R._curry1(id)
--print(curryid("a"))
--print(curryid)
--print(curryid(R.__)(R.__)(R.__)('a'))
--print(R.add(1, 3))

-- print(R.add)
-- print(R.add(1))
-- print(R.add(R.__))
-- print(R.add(1, R.__))
-- print(R.add(R.__, 1))
-- print(R.add(1)(2))
-- print(R.add(R.__, 1)(2))
-- print(R.add(1, R.__)(2))

print(R.T(), R.F())

--local cid = R._curryN(1, {}, id)
--print(cid('a')('b'))
-- local tmp = R.adjust(function(v) return v*5 end, 1, {1,2,3,4})
-- print(tmp[1], tmp[2], tmp[3], tmp[4])
-- tmp = R.adjust(function(v) return v*5 end, -1, {1,2,3,4})
-- print(tmp[1], tmp[2], tmp[3], tmp[4])
-- local addto5 = R.adjust(R.add(5), 3)
-- tmp = addto5({1,2,3,4})
-- print(tmp[1], tmp[2], tmp[3], tmp[4])