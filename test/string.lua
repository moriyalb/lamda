local R = require("../dist/lamda")
TestString = {}
local this = TestString

function TestString.test_join()
	this.lu.assertEquals(R.join(" ", {1,2,3}), "1 2 3")
	this.lu.assertEquals(R.join(".")({192,168,1,1}), "192.168.1.1")
end

return TestString