local R = require("../dist/lamda")

TestUtil = {}
local this = TestUtil

function TestUtil.test_first() 
	local head = R.first()
	this.lu.assertNil(head)

	head = R.first(101)
	this.lu.assertEquals(head, 101)

	head = R.first('a', {}, 101)
	this.lu.assertEquals(head, 'a')
end

function TestUtil.test_second() 
	local head = R.second()
	this.lu.assertNil(head)

	head = R.second(101)
	this.lu.assertNil(head)

	head = R.second('a', {}, 101)
	this.lu.assertEquals(head, {})
end

function TestUtil.test_toString() 
	this.lu.assertEquals(R.toString(), "nil")
	this.lu.assertEquals(R.toString(nil), "nil")
	this.lu.assertEquals(R.toString(1), "1")
	this.lu.assertEquals(R.toString(0), "0")
	this.lu.assertEquals(R.toString('a'), '"a"')
	this.lu.assertEquals(R.toString('hello'), '"hello"')
	this.lu.assertEquals(R.toString(true), 'true')
	this.lu.assertEquals(R.toString(false), 'false')
	this.lu.assertEquals(R.toString({}), '{}')
	this.lu.assertEquals(R.toString({1,2,3}), '{1,2,3}')
	this.lu.assertEquals(R.toString({'a', true, 4}), '{"a",true,4}')
	this.lu.assertEquals(R.toString({'a', nil, true, 4}), '{[1]="a",[3]=true,[4]=4}') --nil treats like absent, so this is like an object
	this.lu.assertEquals(R.toString({{{{a = 1}}}}), '{{{{["a"]=1}}}}')

	this.lu.assertEquals(R.toJson(), "[null]")
	this.lu.assertEquals(R.toJson(nil), "[null]")
	this.lu.assertEquals(R.toJson(1), "[1]")
	this.lu.assertEquals(R.toJson(0), "[0]")
	this.lu.assertEquals(R.toJson('a'), '["a"]')
	this.lu.assertEquals(R.toJson('hello'), '["hello"]')
	this.lu.assertEquals(R.toJson(true), '[true]')
	this.lu.assertEquals(R.toJson(false), '[false]')
	this.lu.assertEquals(R.toJson({}), '[]')
	this.lu.assertEquals(R.toJson({1,2,3}), '[1,2,3]')
	this.lu.assertEquals(R.toJson({'a', true, 4}), '["a",true,4]')
	this.lu.assertEquals(R.toJson({'a', nil, true, 4}), '{"1":"a","3":true,"4":4}') --nil treats like absent, so this is like an object
	this.lu.assertEquals(R.toJson({{{{a = 1}}}}), "[[[{a:1}]]]")
end

function TestUtil.test_defaultTo()
	this.lu.assertEquals(R.defaultTo(42, nil), 42)
	this.lu.assertEquals(R.defaultTo(42, 1/0), 42)
	this.lu.assertEquals(R.defaultTo(42, 0/0), 42)
	this.lu.assertEquals(R.defaultTo(42, 100), 100)
end

function TestUtil.test_type()
	this.lu.assertTrue(R.isNumber(1))
	this.lu.assertTrue(R.isNumber(math.pi))
	this.lu.assertFalse(R.isNumber("a"))
	this.lu.assertFalse(R.isNumber(1/0))
	this.lu.assertFalse(R.isNumber(0/0))
	this.lu.assertFalse(R.isNumber({}))
	this.lu.assertFalse(R.isNumber(function() end))

	this.lu.assertTrue(R.isInteger(1.0))
	this.lu.assertFalse(R.isInteger(-1.1))
	this.lu.assertFalse(R.isInteger("a"))
	this.lu.assertFalse(R.isInteger(1/0))
	this.lu.assertFalse(R.isInteger(0/0))
	this.lu.assertFalse(R.isInteger({}))
	this.lu.assertFalse(R.isInteger(function() end))

	this.lu.assertFalse(R.isString(1.0))
	this.lu.assertTrue(R.isString("a"))
	this.lu.assertFalse(R.isString(1/0))
	this.lu.assertFalse(R.isString(0/0))
	this.lu.assertFalse(R.isString({}))
	this.lu.assertFalse(R.isString(function() end))

	this.lu.assertFalse(R.isFunction(1.0))
	this.lu.assertFalse(R.isFunction("a"))
	this.lu.assertFalse(R.isFunction(1/0))
	this.lu.assertFalse(R.isFunction(0/0))
	this.lu.assertFalse(R.isFunction({}))
	this.lu.assertTrue(R.isFunction(function() end))

	this.lu.assertFalse(R.isTable(1.0))
	this.lu.assertFalse(R.isTable("a"))
	this.lu.assertFalse(R.isTable(1/0))
	this.lu.assertFalse(R.isTable(0/0))
	this.lu.assertTrue(R.isTable({}))
	this.lu.assertFalse(R.isTable(function() end))

	this.lu.assertFalse(R.isArray(1.0))
	this.lu.assertFalse(R.isArray("a"))
	this.lu.assertFalse(R.isArray(1/0))
	this.lu.assertFalse(R.isArray(0/0))
	this.lu.assertTrue(R.isArray({}))
	this.lu.assertTrue(R.isArray({1,2,3}))
	this.lu.assertFalse(R.isArray({1,2,3,nil,4}))
	this.lu.assertFalse(R.isArray({a = 1}))
	this.lu.assertFalse(R.isArray(function() end))

	this.lu.assertFalse(R.isObject(1.0))
	this.lu.assertFalse(R.isObject("a"))
	this.lu.assertFalse(R.isObject(1/0))
	this.lu.assertFalse(R.isObject(0/0))
	this.lu.assertFalse(R.isObject({}))
	this.lu.assertFalse(R.isObject({1,2,3}))
	this.lu.assertTrue(R.isObject({1,2,3,nil,4}))
	this.lu.assertTrue(R.isObject({a = 1}))
	this.lu.assertFalse(R.isObject(function() end))

	this.lu.assertTrue(R.isNil(nil))
	this.lu.assertFalse(R.isNil(1.0))
	this.lu.assertFalse(R.isNil("a"))
	this.lu.assertFalse(R.isNil(1/0))
	this.lu.assertFalse(R.isNil(0/0))
	this.lu.assertFalse(R.isNil({}))
	this.lu.assertFalse(R.isNil({a = 1}))
	this.lu.assertFalse(R.isNil(function() end))

	this.lu.assertFalse(R.isNan(1.0))
	this.lu.assertFalse(R.isNan("a"))
	this.lu.assertFalse(R.isNan(1/0))
	this.lu.assertTrue(R.isNan(0/0))
	this.lu.assertFalse(R.isNan({}))
	this.lu.assertFalse(R.isNan({a = 1}))
	this.lu.assertFalse(R.isNan(function() end))

	this.lu.assertFalse(R.isInf(1.0))
	this.lu.assertFalse(R.isInf("a"))
	this.lu.assertTrue(R.isInf(1/0))
	this.lu.assertFalse(R.isInf(0/0))
	this.lu.assertFalse(R.isInf({}))
	this.lu.assertFalse(R.isInf({a = 1}))
	this.lu.assertFalse(R.isInf(function() end))

	this.lu.assertFalse(R.isSafeNumber(nil))
	this.lu.assertFalse(R.isSafeInteger(nil))
	this.lu.assertFalse(R.isSafeArray(nil))
	this.lu.assertFalse(R.isSafeTable(nil))
	this.lu.assertFalse(R.isSafeObject(nil))
	this.lu.assertFalse(R.isSafeString(nil))
	this.lu.assertFalse(R.isSafeFunction(nil))
	this.lu.assertFalse(R.isSafeNan(nil))
	this.lu.assertFalse(R.isSafeInf(nil))

	this.lu.assertTrue(R.isNull(nil))
	this.lu.assertTrue(R.isNull(0/0))
	this.lu.assertTrue(R.isNull(1/0))
	this.lu.assertFalse(R.isNull(1))
	this.lu.assertFalse(R.isNull(0))
	this.lu.assertFalse(R.isNull(""))
	this.lu.assertFalse(R.isNull({}))
end

function TestUtil.test_isEmpty()
	this.lu.assertFalse(R.isEmpty({1,2,3}))
	this.lu.assertFalse(R.isEmpty(100))
	this.lu.assertFalse(R.isEmpty("asdf"))
	this.lu.assertFalse(R.isEmpty(function() end))
	this.lu.assertTrue(R.isEmpty(nil))
	this.lu.assertTrue(R.isEmpty(0/0))
	this.lu.assertTrue(R.isEmpty(1/0))
	this.lu.assertTrue(R.isEmpty(""))
	this.lu.assertTrue(R.isEmpty({}))
end

function TestUtil.test_empty()
	this.lu.assertNil(R.empty(function() end))
	this.lu.assertEquals(R.empty(3), 0)
	this.lu.assertEquals(R.empty({1, 2, 3}), {})
	this.lu.assertEquals(R.empty("unicorns"), "")
	this.lu.assertEquals(R.empty({x = 1, y = 2}), {})
	this.lu.assertEquals(R.empty(true), false)		
end

function TestUtil.test_equals()
	this.lu.assertTrue(R.equals(1, 1))
	this.lu.assertFalse(R.equals(1, 'a'))
	this.lu.assertFalse(R.equals(1, {}))
	this.lu.assertTrue(R.equals('a', 'a'))
	this.lu.assertTrue(R.equals({})({}))
	this.lu.assertTrue(R.equals({a=1})({a=1}))
	this.lu.assertTrue(R.equals({1,'a',{}})({1,'a',{}}))
	this.lu.assertTrue(R.equals({1,'a',{b={c=3}}})({1,'a',{b={c=3}}}))
	this.lu.assertFalse(R.equals({1,'a',{b={c=3,d=4}}})({1,'a',{b={c=3}}}))
	local f = function() end
	local g = function() end
	this.lu.assertTrue(R.equals(f, f))
	this.lu.assertFalse(R.equals(f, g))

	this.lu.assertFalse(R.safeEquals(1, nil))
	this.lu.assertFalse(R.safeEquals('a', nil))
end

function TestUtil.test_eqBy()
	this.lu.assertTrue(R.eqBy(math.abs, 1, -1))
	this.lu.assertTrue(R.eqBy(math.abs, 1, '1'))
	this.lu.assertFalse(R.eqBy(R.identity, 1, 2))
end

function TestUtil.test_eqProps()
	local obj1 = {a=1,b=2,c=3,d=4}
	local obj2 = {a=10,b=2,c=3,d=4}
	this.lu.assertTrue(R.eqProps('c', obj1, obj2))
	this.lu.assertFalse(R.eqProps('a', obj1, obj2))
end

function TestUtil.test_order()
	this.lu.assertTrue(R.gt(5, 3))
	this.lu.assertFalse(R.gt(4, 4))
	this.lu.assertFalse(R.gt(4, 6))

	this.lu.assertTrue(R.gte(5, 3))
	this.lu.assertTrue(R.gte(4, 4))
	this.lu.assertFalse(R.gte(4, 6))

	this.lu.assertFalse(R.lt(5, 3))
	this.lu.assertFalse(R.lt(4, 4))
	this.lu.assertTrue(R.lt(4, 6))

	this.lu.assertFalse(R.lte(5, 3))
	this.lu.assertTrue(R.lte(4, 4))
	this.lu.assertTrue(R.lte(4, 6))
end

function TestUtil.test_max_min()
	this.lu.assertEquals(R.max(5, 6), 6)
	this.lu.assertEquals(R.max(-1)(100), 100)
	this.lu.assertEquals(R.maxBy(R.abs, 5, 6), 6)
	this.lu.assertEquals(R.maxBy(R.abs, -1000)(100), -1000)

	this.lu.assertEquals(R.min(5, 6), 5)
	this.lu.assertEquals(R.min(-1)(100), -1)
	this.lu.assertEquals(R.minBy(R.divide(1), 5, 6), 6)
	this.lu.assertEquals(R.minBy(R.divide(1), -10)(10), -10)

	local square = function(x) return x*x end
	this.lu.assertEquals(R.reduce(R.maxBy(square), 0, {3, -5, 4, 1, -2}), -5)
	this.lu.assertEquals(R.reduce(R.minBy(square), 100, {3, -5, 4, 1, -2}), 1)
end

function TestUtil.test_pack()
	local f = {1,2,3,4}
	this.lu.assertEquals(R.pack(1,2,3,4), {1,2,3,4})
end

function TestUtil.test_countBy()
	local numbers = {1.0, 1.1, 1.2, 2.0, 3.0, 2.2}
	this.lu.assertEquals(R.countBy(math.floor)(numbers), {3,2,1})
	local letters = {'a', 'b', 'A', 'a', 'B', 'c'}
	this.lu.assertEquals(R.countBy(R.toLower)(letters), {a=3, b=2, c=1})

	this.lu.assertEquals(R.count(1, {1,2,3,2,1,2,3,1}), 3)
	this.lu.assertEquals(R.count(5, {1,2,5,5,3,2}), 2)
	this.lu.assertEquals(R.count('a', "hello world") , 0)
end

function TestUtil.test_same()
	this.lu.assertFalse(R.same({}, {}))
	this.lu.assertTrue(R.same(1, 1))
	this.lu.assertFalse(R.same(1, "1"))
	local obj = {}
	this.lu.assertTrue(R.same(obj, obj))
end

function TestUtil.test_symmetricDifference()
	this.lu.assertEquals(R.symmetricDifference({1,2,3,4}, {7,6,5,4,3}), {1,2,7,6,5})
	this.lu.assertEquals(R.symmetricDifference({7,6,5,4,3}, {1,2,3,4}), {7,6,5,1,2})
	local eqA = R.eqBy(R.prop('a'))
	local l1 = {{a=1}, {a=2}, {a=3}, {a=4}}
	local l2 = {{a=3}, {a=4}, {a=5}, {a=6}}
	this.lu.assertEquals(R.symmetricDifferenceWith(eqA, l1, l2), {{a=1}, {a=2}, {a=5}, {a=6}})
end

return TestUtil