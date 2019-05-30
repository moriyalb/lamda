local R = require("../dist/lamda")

TestArray = {}
local this = TestArray

function TestArray.test_adjust()
	local tbl = {1, 2, 3}
	this.lu.assertEquals(R.adjust(R.add(10), 1, tbl), {11, 2, 3})
	this.lu.assertEquals(R.adjust(R.add(10), 2, tbl), {1, 12, 3})
	this.lu.assertEquals(R.adjust(R.add(10), -1, tbl), {1, 2, 13})
	this.lu.assertEquals(R.adjust(R.add(10), -3, tbl), {11, 2, 3})
	this.lu.assertEquals(R.adjust(R.add(10), 0, tbl), tbl)
	this.lu.assertEquals(R.adjust(R.add(10), 100, tbl), tbl)

	tbl = {}
	this.lu.assertEquals(R.adjust(R.add(10), 1, tbl), tbl)
	this.lu.assertEquals(R.adjust(R.add(10), -1, tbl), tbl)
end

function TestArray.test_all()
	local tbl = {3, 3, 3, 3}
	this.lu.assertTrue(R.all(R.equals(3), tbl))
	this.lu.assertFalse(R.all(R.equals(2))(tbl))

	tbl = {}
	this.lu.assertTrue(R.all(R.equals(0), tbl))
end

function TestArray.test_any()
	local tbl = {3, 3, 3, 2}
	this.lu.assertTrue(R.any(R.equals(3), tbl))
	this.lu.assertTrue(R.any(R.equals(2))(tbl))
	this.lu.assertFalse(R.any(R.equals(4))(tbl))

	tbl = {}
	this.lu.assertFalse(R.any(R.equals(0), tbl))
end

function TestArray.test_aperture()
	local tbl = {1,2,3,4,5}
	local tbl_apertured = R.aperture(2, tbl)
	this.lu.assertEquals(tbl_apertured, {{1,2}, {2,3}, {3,4}, {4,5}})

	tbl_apertured = R.aperture(4, tbl)
	this.lu.assertEquals(tbl_apertured, {{1,2,3,4}, {2,3,4,5}})

	tbl_apertured = R.aperture(0, tbl)
	this.lu.assertEquals(tbl_apertured, {{},{},{},{},{},{}})

	tbl_apertured = R.aperture(10, tbl)
	this.lu.assertEquals(tbl_apertured, {})

	tbl_apertured = R.aperture(-2, tbl)
	this.lu.assertEquals(tbl_apertured, {})

	local tbl_apertured_curried = R.aperture(2)
	this.lu.assertEquals(tbl_apertured_curried({1,2,3}), {{1,2}, {2,3}})
	this.lu.assertEquals(tbl_apertured_curried({1,2,3,4}), {{1,2}, {2,3}, {3,4}})
end

function TestArray.test_append()
	local tbl = {1,2,3,4,5}
	local tbl_appended = R.append(6, tbl)
	this.lu.assertEquals(tbl_appended, {1,2,3,4,5,6})

	tbl_appended = R.push({6}, tbl)
	this.lu.assertEquals(tbl_appended, {1,2,3,4,5,{6}})

	local tbl_appended_curried = R.append('a')
	this.lu.assertEquals(tbl_appended_curried({1,2}), {1,2,'a'})
	this.lu.assertEquals(tbl_appended_curried({}), {'a'})
end

function TestArray.test_chain()
	local dump = function(x) return {x, x} end
	this.lu.assertEquals(R.chain(dump, {1,2}), {1,1,2,2})
	this.lu.assertEquals(R.chain(R.append, R.head)({1,2}), {1,2,1})
end

function TestArray.test_concat()
	this.lu.assertEquals(R.concat("abc", "def"), "abcdef")
	this.lu.assertEquals(R.concat({1,2,3})({2,1}), {1,2,3,2,1})
	this.lu.assertEquals(R.concat({}, {}), {})	
end

function TestArray.test_contains()
	local tbl = {1,2,3,4}
	this.lu.assertTrue(R.contains(1, tbl))
	this.lu.assertFalse(R.contains(5)(tbl))
	this.lu.assertFalse(R.includes('a')({}))
end

function TestArray.test_difference()
	this.lu.assertEquals(R.difference({1,2,3}, {2,3,4}), {1})
	this.lu.assertEquals(R.difference({1,2,3}, {1,2,3}), {})
	this.lu.assertEquals(R.difference({}, {}), {})
	this.lu.assertEquals(R.difference({1,2,3}, {}), {1,2,3})
	this.lu.assertEquals(R.difference({{a = 1}, {b = 2}}, {{a = 1}, {c = 3}}), {{b = 2}})
end

function TestArray.test_differenceWith()
	local cmp = function(a, b) return a%2 == b%2 end
	this.lu.assertEquals(R.differenceWith(cmp, {1,2,3,4}, {5,7}), {2}) -- 4 is same as 2 right ?
end

function TestArray.test_drop()
	local list = {'a','b','c'}
	this.lu.assertEquals(R.drop(1, list), {'b', 'c'})
	this.lu.assertEquals(R.drop(2, list), {'c'})
	this.lu.assertEquals(R.drop(3)(list), {})
	this.lu.assertEquals(R.drop(4, list), {})

	local str = "lamda"
	this.lu.assertEquals(R.drop(1, str), "amda")
	this.lu.assertEquals(R.drop(3, str), "da")
	this.lu.assertEquals(R.drop(5, str), "")
	this.lu.assertEquals(R.drop(8)(str), "")
end

function TestArray.test_dropLast()
	local list = {'a','b','c'}
	this.lu.assertEquals(R.dropLast(1, list), {'a', 'b'})
	this.lu.assertEquals(R.dropLast(2, list), {'a'})
	this.lu.assertEquals(R.dropLast(3)(list), {})
	this.lu.assertEquals(R.dropLast(4, list), {})

	local str = "lamda"
	this.lu.assertEquals(R.dropLast(1, str), "lamd")
	this.lu.assertEquals(R.dropLast(3, str), "la")
	this.lu.assertEquals(R.dropLast(5, str), "")
	this.lu.assertEquals(R.dropLast(8)(str), "")
end

function TestArray.test_dropLastWhile()
	local list = {1,2,3,4,3,2,1}
	this.lu.assertEquals(R.dropLastWhile(R.gte(3), list), {1,2,3,4})
	this.lu.assertEquals(R.dropLastWhile(R.gte(2), list), {1,2,3,4,3})
	this.lu.assertEquals(R.dropLastWhile(R.equals(1))(list), {1,2,3,4,3,2})
	
	local str = "lamda"
	this.lu.assertEquals(R.dropLastWhile(R.equals('a'), str), "lamd")
	this.lu.assertEquals(R.dropLastWhile(R.T, str), "")
	this.lu.assertEquals(R.dropLastWhile(R.F, str), "lamda")
end 

function TestArray.test_dropWhile()
	local list = {1,2,3,4,3,2,1}
	this.lu.assertEquals(R.dropWhile(R.gte(3), list), {4,3,2,1})
	this.lu.assertEquals(R.dropWhile(R.gte(2), list), {3,4,3,2,1})
	this.lu.assertEquals(R.dropWhile(R.equals(1))(list), {2,3,4,3,2,1})
	
	local str = "lamda"
	this.lu.assertEquals(R.dropWhile(R.equals('a'), str), "lamda")
	this.lu.assertEquals(R.dropWhile(R.T, str), "")
	this.lu.assertEquals(R.dropWhile(R.F, str), "lamda")
end 

function TestArray.test_slice()
	local list = {'a', 'b', 'c', 'd'}
	this.lu.assertEquals(R.slice(0,0, list), list)
	this.lu.assertEquals(R.slice(1,0, list), list)
	this.lu.assertEquals(R.slice(1,1, list), {})
	this.lu.assertEquals(R.slice(1,2, list), {'a'})
	this.lu.assertEquals(R.slice(1,3, list), {'a', 'b'})
	this.lu.assertEquals(R.slice(1,4, list), {'a', 'b', 'c'})
	this.lu.assertEquals(R.slice(1,5, list), {'a', 'b', 'c', 'd'})

	this.lu.assertEquals(R.slice(-1,-1, list), {})
	this.lu.assertEquals(R.slice(-2,-1, list), {'c'})
	this.lu.assertEquals(R.slice(-1,0, list), {'d'})
	this.lu.assertEquals(R.slice(1,-3, list), {'a'})
	this.lu.assertEquals(R.slice(1,-1, list), {'a', 'b', 'c'})

	local str = 'lamda'
	this.lu.assertEquals(R.slice(0,0, str), str)
	this.lu.assertEquals(R.slice(1,0, str), str)
	this.lu.assertEquals(R.slice(1,1, str), "")
	this.lu.assertEquals(R.slice(1,2, str), "l")
	this.lu.assertEquals(R.slice(1,3, str), "la")
	this.lu.assertEquals(R.slice(1,4, str), "lam")
	this.lu.assertEquals(R.slice(1,5, str), "lamd")

	this.lu.assertEquals(R.slice(-1,-1, str), "")
	this.lu.assertEquals(R.slice(-2,-1, str), "d")
	this.lu.assertEquals(R.slice(-1,0, str), "a")
	this.lu.assertEquals(R.slice(1,-3, str), "la")
	this.lu.assertEquals(R.slice(1,-1, str), "lamd")
end

function TestArray.test_take()
	local list = {'a', 'b', 'c', 'd'}
	this.lu.assertEquals(R.take(-1, list), {})
	this.lu.assertEquals(R.take(0, list), {})
	this.lu.assertEquals(R.take(1, list), {'a'})
	this.lu.assertEquals(R.take(2, list), {'a','b'})
	this.lu.assertEquals(R.take(3, list), {'a','b','c'})
	this.lu.assertEquals(R.take(4, list), {'a','b','c','d'})
	this.lu.assertEquals(R.take(5, list), {'a','b','c','d'})
	
	local str = 'lamda'
	this.lu.assertEquals(R.take(-1, str), "")
	this.lu.assertEquals(R.take(0, str), "")
	this.lu.assertEquals(R.take(1, str), "l")
	this.lu.assertEquals(R.take(2, str), "la")
	this.lu.assertEquals(R.take(3, str), "lam")
	this.lu.assertEquals(R.take(5, str), "lamda")
	this.lu.assertEquals(R.take(8, str), "lamda")
end

function TestArray.test_filter()
	this.lu.assertEquals(R.filter(R.gte(2), {1,2,3,4}), {1,2})
	local isEven = R.o(R.equals(0), R.mathMod(R.__, 2))
	local filterEven = R.filter(isEven)
	this.lu.assertEquals(filterEven({1,2,3,4}), {2,4})
	this.lu.assertEquals(filterEven({a=1,b=2,c=3,d=4}), {b=2,d=4})
end

function TestArray.test_find()
	this.lu.assertEquals(R.find(1, {1,2,3}), 1)
	this.lu.assertNil(R.find(10, {1,2,3}))
	this.lu.assertEquals(R.find(R.lt(2), {1,2,3,3,4,5}), 3)

	this.lu.assertEquals(R.findIndex(1, {1,2,3}), 1)
	this.lu.assertEquals(R.findIndex(10, {1,2,3}), -1)
	this.lu.assertEquals(R.findIndex(R.lt(2), {1,2,30,30,4,5}), 3)

	this.lu.assertEquals(R.findLast(1, {1,2,3}), 1)
	this.lu.assertNil(R.findLast(10, {1,2,3}))
	this.lu.assertEquals(R.findLast(R.lt(2), {1,2,3,3,4,5}), 5)

	this.lu.assertEquals(R.findLastIndex(1, {1,2,3}), 1)
	this.lu.assertEquals(R.findLastIndex(10, {1,2,3}), -1)
	this.lu.assertEquals(R.findLastIndex(R.lt(2), {1,2,30,30,4,5}), 6)
end

function TestArray.test_flatten()
	this.lu.assertEquals(R.flatten({{{{}}}}), {})
	this.lu.assertEquals(R.flatten({1,2,{3,4,{5,{6}}}}), {1,2,3,4,5,6})
end

function TestArray.test_forEach()
	local count = 0
	R.forEach(function(v, k)
		count = count + v
	end, {1,2,3})
	this.lu.assertEquals(count, 6)

	count = 0
	R.forEach(function(v, k)
		count = count + v + k
	end, {1,2,3})
	this.lu.assertEquals(count, 12)

	count = 0
	R.forEach(function(v, k)
		count = count + v + k
	end, {[5] = 1, [6] = 2, [7] = 3})
	this.lu.assertEquals(count, 24)
end

return TestArray