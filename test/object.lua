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
	this.lu.assertIs(assoc_obj.ref, ref_obj)
end

function TestObject.test_assocPath()
	this.lu.assertEquals(R.assocPath({'b', 'c'}, 5, {a = 1}), {a = 1, b = {c = 5}})
	this.lu.assertEquals(R.assocPath({'a', 'c'}, 5, {a = 1}), {a = {c = 5}})
end

function TestObject.test_clone()
	local obj = {{},{}}
	local obj_cloned = R.clone(obj)
	this.lu.assertNotIs(obj, obj_cloned)
	this.lu.assertNotIs(obj[1], obj_cloned[1])
end

function TestObject.test_dissoc()
	local obj = {a = {b = 1}, c = 2, d = 3}
	local obj_dissoced = R.dissoc('a', obj)
	this.lu.assertEquals(obj_dissoced, {c = 2, d = 3})

	obj_dissoced = R.dissoc('m', obj)
	this.lu.assertEquals(obj_dissoced, obj)
end

function TestObject.test_dissocPath()
	local obj = {a = {b = 1, e = 4}, c = 2, d = 3}
	local obj_dissoced = R.dissocPath({'a', 'b'}, obj)
	this.lu.assertEquals(obj_dissoced, {a = {e = 4}, c = 2, d = 3})

	obj_dissoced = R.dissocPath({'m'}, obj)
	this.lu.assertEquals(obj_dissoced, obj)
end

return TestObject