local R = require("../dist/lamda")
TestString = {}
local this = TestString

function TestString.test_join()
	this.lu.assertEquals(R.join(" ", {1,2,3}), "1 2 3")
	this.lu.assertEquals(R.join(".")({192,168,1,1}), "192.168.1.1")
end

function TestString.test_match()
	this.lu.assertEquals(R.match("[a-z]a", 'bananas'), {"ba", "na", "na"})
	this.lu.assertEquals(R.match("a", 'b'), {})
end

return TestString