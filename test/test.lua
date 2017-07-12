package.path = package.path .. ";E:\\Projects\\lamda\\lamda\\?.lua"

local R = require("dist.lamda")

function id(v)
	return "id"..v
end

local curryid = R.curry1(id)
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