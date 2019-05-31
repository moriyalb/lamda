local R = require("../dist/lamda")
TestString = {}
local this = TestString

function TestString.test_join()
	this.lu.assertEquals(R.join(" ", {1,2,3}), "1 2 3")
	this.lu.assertEquals(R.join(".")({192,168,1,1}), "192.168.1.1")
	this.lu.assertEquals(R.join("")({"hello", "world"}), "helloworld")
end

function TestString.test_match()
	this.lu.assertEquals(R.match("[a-z]a", 'bananas'), {"ba", "na", "na"})
	this.lu.assertEquals(R.match("a", 'b'), {})
end

function TestString.test_toLower()
	this.lu.assertEquals(R.toLower("hELlo"), "hello")
	this.lu.assertEquals(R.toLower(""), "")
end

function TestString.test_toUpper()
	this.lu.assertEquals(R.toUpper("hELlo"), "HELLO")
	this.lu.assertEquals(R.toUpper(""), "")
end

return TestString