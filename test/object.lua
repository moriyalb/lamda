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

function TestObject.test_fromPairs()
	this.lu.assertEquals(R.fromPairs({{'a',1}, {'b', 2}}), {a = 1, b = 2})
	this.lu.assertEquals(R.fromPairs({}), {})
end

function TestObject.test_has()
	this.lu.assertTrue(R.has('a', {a = 1}))
	this.lu.assertFalse(R.has('b', {a = 1}))
	local has = R.has(R.__, {a = 1})
	this.lu.assertTrue(has('a'))
	this.lu.assertFalse(has('c'))
end

function TestObject.test_invert()
	local raceResultsByFirstName = {
		first = 'alice',
		second = 'jake',
		third = 'alice',
	}
	this.lu.assertEquals(R.invert(raceResultsByFirstName), {alice={"third", "first"}, jake={"second"}})
	this.lu.assertEquals(R.invertObj(raceResultsByFirstName), {alice="first", jake="second"})
	this.lu.assertEquals(R.invertObj({1,2,3}), {["1"]=1, ["2"]=2, ["3"]=3})
end

return TestObject