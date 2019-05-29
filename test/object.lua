local R = require("../dist/lamda")
TestObject = {}
local this = TestObject

function TestObject.test_assoc()
	this.lu.assertEquals(R.assoc("c", 5, {a = 1}), {a = 1, c = 5})
	this.lu.assertEquals(R.assoc("c", 5, {a = 1, c = 3}), {a = 1, c = 5})
	local ref_obj = {a = 1}
	local assoc_obj = R.assoc("c", 5)({ref = ref_obj})
	this.lu.assertEquals(assoc_obj, {ref = {a = 1}, c = 5})
	ref_obj.a = 2
	this.lu.assertEquals(assoc_obj, {ref = {a = 2}, c = 5})
end

function TestObject.test_assocPath()
	this.lu.assertEquals(R.assocPath({'b', 'c'}, 5, {a = 1}), {a = 1, b = {c = 5}})
	this.lu.assertEquals(R.assocPath({'a', 'c'}, 5, {a = 1}), {a = {c = 5}})
end

return TestObject