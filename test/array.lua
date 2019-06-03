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

	this.lu.assertEquals(R.append('d', 'abc'), 'abcd')
	this.lu.assertEquals(R.append('', 'abc'), 'abc')
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
	this.lu.assertEquals(R.drop(0, list), {'a', 'b', 'c'})
	this.lu.assertEquals(R.drop(1, list), {'b', 'c'})
	this.lu.assertEquals(R.drop(2, list), {'c'})
	this.lu.assertEquals(R.drop(3)(list), {})
	this.lu.assertEquals(R.drop(4, list), {})

	local str = "lamda"
	this.lu.assertEquals(R.drop(0, str), "lamda")
	this.lu.assertEquals(R.drop(1, str), "amda")
	this.lu.assertEquals(R.drop(3, str), "da")
	this.lu.assertEquals(R.drop(5, str), "")
	this.lu.assertEquals(R.drop(8)(str), "")
end

function TestArray.test_dropLast()
	local list = {'a','b','c'}
	this.lu.assertEquals(R.dropLast(0, list), {'a', 'b', 'c'})
	this.lu.assertEquals(R.dropLast(1, list), {'a', 'b'})
	this.lu.assertEquals(R.dropLast(2, list), {'a'})
	this.lu.assertEquals(R.dropLast(3)(list), {})
	this.lu.assertEquals(R.dropLast(4, list), {})

	local str = "lamda"
	this.lu.assertEquals(R.dropLast(0, str), "lamda")
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
	local isEven = R.o(R.equals(0), R.mod(R.__, 2))
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

function TestArray.test_groupWith()
	this.lu.assertEquals(R.groupWith(R.T, {}), {})
	this.lu.assertEquals(R.groupWith(R.T, "abcd"), {"abcd"})
	this.lu.assertEquals(R.groupWith(R.F, "abcd"), {"a", "b", "c", "d"})
	this.lu.assertEquals(R.groupWith(R.equals, {0, 1, 1, 2, 3, 5, 5, 1, 8, 8, 8, 5, 13, 21}), {{0}, {1, 1}, {2}, {3}, {5, 5}, {1}, {8, 8, 8}, {5}, {13}, {21}})
	this.lu.assertEquals(R.groupWith(R.eqBy(R.contains(R.__, "aeiou")), 'aestiou'),  {'ae', 'st', 'iou'})
end

function TestArray.test_indexOf()
	this.lu.assertEquals(R.indexOf(5, {1,2,3,4,5}), 5)
	this.lu.assertEquals(R.indexOf(10, {1,2,3,4,5}), -1)
	this.lu.assertEquals(R.indexOf('c', "abcdef"), 3)
	this.lu.assertEquals(R.indexOf('x', "abcdef"), -1)
end

function TestArray.test_innerJoin()
	local r = R.innerJoin(
		function(data, id) return data.id == id end,
		{
			{id = 824, name = 'Richie Furay'},
			{id = 956, name = 'Dewey Martin'},
			{id = 313, name = 'Bruce Palmer'},
			{id = 456, name = 'Stephen Stills'},
			{id = 177, name = 'Neil Young'}
		},
		{177, 456, 999}
	)
	this.lu.assertEquals(r, {{id = 456, name = 'Stephen Stills'}, {id = 177, name = 'Neil Young'}})
end

function TestArray.test_insert()
	local list = {1,2,3,4}
	this.lu.assertEquals(R.insert(3, 100, list), {1,2,3,100,4})
	this.lu.assertEquals(list, {1,2,3,4})

	this.lu.assertEquals(R.insert(3, 100)({}), {100})
	this.lu.assertEquals(R.insert(-2, 100)({1,2,3}), {1,2,3,100})

	this.lu.assertEquals(R.insertAll(2, {5,6,7})({1,2,3}), {1,2,5,6,7,3})
	this.lu.assertEquals(R.insertAll(3, {})({1,2,3}), {1,2,3})
	this.lu.assertEquals(R.insertAll(3, {5,6,7})({}), {5,6,7})
end

function TestArray.test_intersperse()
	this.lu.assertEquals(R.intersperse('n', {'ba', 'a', 'a'}),  {'ba', 'n', 'a', 'n', 'a'})
	this.lu.assertEquals(R.intersperse('n', {}),  {})	
	this.lu.assertEquals(R.intersperse({})({1,2,3}),  {1,{},2,{},3})
end

function TestArray.test_length()
	this.lu.assertEquals(R.length({1,2,3}), 3)
	this.lu.assertEquals(R.size({a = 11, b = {1,2,3}}), 2)
end

function TestArray.test_lastIndexOf()
	this.lu.assertEquals(R.lastIndexOf(5, {1,3,5,7,5,7,5,9,4,8}), 7)
	this.lu.assertEquals(R.lastIndexOf(10, {1,2,3,4,5}), -1)
	this.lu.assertEquals(R.lastIndexOf('c', "abcdccecf"), 8)
	this.lu.assertEquals(R.lastIndexOf('x', "abcdef"), -1)
end

function TestArray.test_nth()
	this.lu.assertEquals(R.nth(1, {'a','b','c'}), 'a')
	this.lu.assertEquals(R.nth(0, {'a','b','c'}), 'a')
	this.lu.assertEquals(R.nth(-1, {'a','b','c'}), 'c')
	this.lu.assertEquals(R.nth(3, {'a','b','c'}), 'c')
	this.lu.assertNil(R.nth(5, {'a','b','c'}))
	this.lu.assertNil(R.nth(-5, {'a','b','c'}))

	this.lu.assertEquals(R.nth(1, "abc"), 'a')
	this.lu.assertEquals(R.nth(0, "abc"), 'a')
	this.lu.assertEquals(R.nth(-1, "abc"), 'c')
	this.lu.assertEquals(R.nth(3, "abc"), 'c')
	this.lu.assertEquals(R.nth(5, "abc"), '')
	this.lu.assertEquals(R.nth(-5, "abc"), '')
end

function TestArray.test_head_last()
	this.lu.assertEquals(R.head({'a','b','c'}), 'a')
	this.lu.assertEquals(R.last({'a','b','c'}), 'c')
	this.lu.assertNil(R.head({}))
	this.lu.assertNil(R.last({}))

	this.lu.assertEquals(R.head("abc"), 'a')
	this.lu.assertEquals(R.last("abc"), 'c')
	this.lu.assertEquals(R.head(""), '')
	this.lu.assertEquals(R.last(""), '')
end

function TestArray.test_none()
	local tbl = {3, 3, 3, 2}
	this.lu.assertFalse(R.none(R.equals(3), tbl))
	this.lu.assertFalse(R.none(R.equals(2))(tbl))
	this.lu.assertTrue(R.none(R.equals(4))(tbl))

	tbl = {}
	this.lu.assertTrue(R.none(R.equals(0), tbl))
end

function TestArray.test_prepend()
	this.lu.assertEquals(R.prepend('a', {}), {'a'})
	this.lu.assertEquals(R.unshift('a', {'b'}), {'a', 'b'})
end

function TestArray.test_range()
	this.lu.assertEquals(R.range(1, 5), {1,2,3,4})
	this.lu.assertEquals(R.range(1, -5), {})
end

function TestArray.test_reduce()
	this.lu.assertEquals(R.reduce(R.subtract, 0, {1, 2, 3, 4}), -10)
end

function TestArray.test_reduceBy()
	local reduceToNamesBy = R.reduceBy(function(acc, student)
		return R.append(student.name, acc) 
	end, {})
	local namesByGrade = reduceToNamesBy(function(student)
		local score = student.score
		return score < 65 and 'F' or
				score < 70 and 'D' or
				score < 80 and 'C' or
				score < 90 and 'B' or 'A'
	end)
	local students = {{name = 'Lucy', score = 92},
					{name = 'Drew', score = 85},
					{name = 'Leo', score = 90},
					{name = 'Bart', score = 62}}
	this.lu.assertEquals(namesByGrade(students), {A={"Lucy", "Leo"}, B={"Drew"}, F={"Bart"}})
end

function TestArray.test_groupBy()
	local byGrade = R.groupBy(function(student) 
		local score = student.score
		return score < 65 and 'F' or
				score < 70 and 'D' or
				score < 80 and 'C' or
				score < 90 and 'B' or 'A'
	end)
	local students = {{name = 'Lucy', score = 92},
				{name = 'Drew', score = 85},
				{name = 'Leo', score = 90},
				{name = 'Bart', score = 62}}
	this.lu.assertEquals(byGrade(students), {
		A={{name="Lucy", score=92}, {name="Leo", score=90}},
		B={{name="Drew", score=85}},
		F={{name="Bart", score=62}}
	})
end

function TestArray.test_indexBy()
	local list = {{id = 'xyz', title = 'A'}, {id = 'abc', title = 'B'}}
	this.lu.assertEquals(R.indexBy(R.prop('id'), list), {abc={id="abc", title="B"}, xyz={id="xyz", title="A"}})

	list = {{id = 'xyz', title = 'A'}, {title = 'B'}}
	this.lu.assertEquals(R.indexBy(R.prop('title'), list), {A={id="xyz", title="A"}, B={title="B"}})
end

function TestArray.test_reduceRight()
	this.lu.assertEquals(R.reduceRight(R.subtract, 0, {1,2,3,4}), -2)
end

function TestArray.test_reduceWhile()
	local isOdd = function(acc, x) return x%2 == 1 end
	local xs = {1, 3, 5, 60, 777, 800}
	this.lu.assertEquals(R.reduceWhile(isOdd, R.add, 0, xs), 9)

	local ys = {2, 4, 6}
	this.lu.assertEquals(R.reduceWhile(isOdd, R.add, 111, ys), 111)
end

function TestArray.test_reject()
	local isOdd = R.o(R.equals(1), R.mod(R.__, 2))	
	this.lu.assertEquals(R.reject(isOdd, {1, 2, 3, 4}), {2, 4})
	this.lu.assertEquals(R.reject(isOdd, {a = 1, b = 2, c = 3, d = 4}), {b = 2, d = 4})
end

function TestArray.test_partition()
	this.lu.assertEquals(R.partition(R.contains('s'), {'sss', 'ttt', 'foo', 'bars'}), {{'sss', 'bars'}, {'ttt', 'foo' }})
	this.lu.assertEquals(R.partition(R.contains('s'), {a = 'sss', b = 'ttt', foo = 'bars'}), {{ a = 'sss', foo = 'bars' }, { b = 'ttt' }})
	this.lu.assertEquals(R.partition(R.T,{}), {{},{}})
	this.lu.assertEquals(R.partition(R.F,{}), {{},{}})
end

function TestArray.test_remove()
	local list = {1,2,3,4,5,6,7,8}
	this.lu.assertEquals(R.remove(2, 3, list), {1,5,6,7,8})
	this.lu.assertEquals(R.remove(0, 3, list), {4,5,6,7,8})
	this.lu.assertEquals(R.remove(0, 0, list), list)
	this.lu.assertEquals(R.remove(1, -1, list), list)
end

function TestArray.test_repeat_()
	this.lu.assertEquals(R.repeat_('hi', 5), {'hi', 'hi', 'hi', 'hi', 'hi'})
	local obj = {}
	local repeatedObjs = R.repeat_(obj, 5)
	this.lu.assertTrue(R.same(repeatedObjs[1], repeatedObjs[2]))
end

function TestArray.test_reverse()
	this.lu.assertEquals(R.reverse({1, 2, 3}), {3, 2, 1})
	this.lu.assertEquals(R.reverse({1, 2}), {2, 1})
	this.lu.assertEquals(R.reverse({1}), {1})
	this.lu.assertEquals(R.reverse({}), {})

	this.lu.assertEquals(R.reverse('abc'), 'cba')
	this.lu.assertEquals(R.reverse('ab'), 'ba')
	this.lu.assertEquals(R.reverse('a'), 'a')
	this.lu.assertEquals(R.reverse(''), '')
end

function TestArray.test_scan()
	local numbers = {1, 2, 3, 4}
	this.lu.assertEquals(R.scan(R.multiply, 1, numbers), {1, 1, 2, 6, 24})
end

function TestArray.test_init_tail()
	this.lu.assertEquals(R.init({1, 2, 3}), {1,2})
	this.lu.assertEquals(R.init({1, 2}), {1})
	this.lu.assertEquals(R.init({1}), {})
	this.lu.assertEquals(R.init({}), {})

	this.lu.assertEquals(R.init('abc'), 'ab')
	this.lu.assertEquals(R.init('ab'), 'a')
	this.lu.assertEquals(R.init('a'), '')
	this.lu.assertEquals(R.init(''), '')

	this.lu.assertEquals(R.tail({1, 2, 3}), {2,3})
	this.lu.assertEquals(R.tail({1, 2}), {2})
	this.lu.assertEquals(R.tail({1}), {})
	this.lu.assertEquals(R.tail({}), {})

	this.lu.assertEquals(R.tail('abc'), 'bc')
	this.lu.assertEquals(R.tail('ab'), 'b')
	this.lu.assertEquals(R.tail('a'), '')
	this.lu.assertEquals(R.tail(''), '')
end

function TestArray.test_sort()
	this.lu.assertEquals(R.sort(R.lt, {4,2,7,5}), {2,4,5,7})
	this.lu.assertEquals(R.sort(R.gt, {4,2,7,5}), {7,5,4,2})

	local alice = {
		name = 'alice',
		age = 40
	}
	local bob = {
		name = 'bob',
		age = 30
	}
	local clara = {
		name = 'clara',
		age = 40
	}

	local people = {clara, bob, alice}
	local sortByNameUpper = R.sort(R.ascend(R.compose(R.toLower, R.prop('name'))))
	local sortByNameUpperDescend = R.sort(R.descend(R.compose(R.toLower, R.prop('name'))))

	this.lu.assertEquals(sortByNameUpper(people), {{age=40, name="alice"}, {age=30, name="bob"}, {age=40, name="clara"}})
	this.lu.assertEquals(sortByNameUpperDescend(people), {{age=40, name="clara"}, {age=30, name="bob"}, {age=40, name="alice"}})

	local ageNameSort = R.sortWith({
		R.descend(R.prop('age')),
		R.ascend(R.prop('name'))
	})
	this.lu.assertEquals(ageNameSort(people), {{age=40, name="alice"}, {age=40, name="clara"}, {age=30, name="bob"}})
end

function TestArray.test_splitAt()
	this.lu.assertEquals(R.splitAt(2, {1, 2, 3}), {{1}, {2, 3}})
	this.lu.assertEquals(R.splitAt(6, 'hello world'), {'hello', ' world'})
	this.lu.assertEquals(R.splitAt(-1, 'foobar'), {'fooba', 'r'})
end

function TestArray.test_splitEvery()
	this.lu.assertEquals(R.splitEvery(3, {1, 2, 3, 4, 5, 6, 7}), {{1, 2, 3}, {4, 5, 6}, {7}})
	this.lu.assertEquals(R.splitEvery(3, 'foobarbaz'), {'foo', 'bar', 'baz'})
end

function TestArray.test_splitWhen()
	this.lu.assertEquals(R.splitWhen(R.equals(2), {1, 2, 3, 1, 2, 3}), {{1}, {2, 3, 1, 2, 3}})
	local isLower = function(c) return R.same(c, R.toLower(c)) end
	this.lu.assertEquals(R.splitWhen(isLower, 'HELllo World'), {"HEL", "llo World"})
end

function TestArray.test_takeLast()
	this.lu.assertEquals(R.takeLast(0, {'foo', 'bar', 'baz'}), {})
	this.lu.assertEquals(R.takeLast(1, {'foo', 'bar', 'baz'}), {'baz'})
	this.lu.assertEquals(R.takeLast(2, {'foo', 'bar', 'baz'}), {'bar', 'baz'})
	this.lu.assertEquals(R.takeLast(3, {'foo', 'bar', 'baz'}), {'foo', 'bar', 'baz'})
	this.lu.assertEquals(R.takeLast(4, {'foo', 'bar', 'baz'}), {'foo', 'bar', 'baz'})
	this.lu.assertEquals(R.takeLast(3, 'lamda') , 'mda')
	this.lu.assertEquals(R.takeLast(0, 'lamda') , '')
end

function TestArray.test_takeLastWhile()
	local isNotOne = R.complement(R.equals(1))	
	this.lu.assertEquals(R.takeLastWhile(isNotOne, {1, 2, 3, 4}), {2, 3, 4})
	this.lu.assertEquals(R.takeLastWhile(R.T, {1, 2, 3, 4}), {1, 2, 3, 4})
	this.lu.assertEquals(R.takeLastWhile(R.F, {1, 2, 3, 4}), {})

	local isNotA = R.complement(R.equals('a'))	
	this.lu.assertEquals(R.takeLastWhile(isNotA, "abcd"), "bcd")
	this.lu.assertEquals(R.takeLastWhile(R.T, "abcd"), "abcd")
	this.lu.assertEquals(R.takeLastWhile(R.F, "abcd"), "")
end

function TestArray.test_takeWhile()
	local isNotFour = R.complement(R.equals(4))	
	this.lu.assertEquals(R.takeWhile(isNotFour, {1, 2, 3, 4}), {1,2,3})
	this.lu.assertEquals(R.takeWhile(R.T, {1, 2, 3, 4}), {1,2,3,4})
	this.lu.assertEquals(R.takeWhile(R.F, {1, 2, 3, 4}), {})

	local isNotD = R.complement(R.equals('d'))	
	this.lu.assertEquals(R.takeWhile(isNotD, "abcd"), "abc")
	this.lu.assertEquals(R.takeWhile(R.T, "abcd"), "abcd")
	this.lu.assertEquals(R.takeWhile(R.F, "abcd"), "")
end

function TestArray.test_times()
	this.lu.assertEquals(R.times(R.identity, 5), {1,2,3,4,5})
	this.lu.assertEquals(R.times(R.identity, 0), {})
end

function TestArray.test_transpose()
	this.lu.assertEquals(R.transpose({{1, 'a'}, {2, 'b'}, {3, 'c'}}), {{1, 2, 3}, {"a", "b", "c"}})
	this.lu.assertEquals(R.transpose({{1, 2, 3}, {'a', 'b', 'c'}}), {{1, "a"}, {2, "b"}, {3, "c"}})
	this.lu.assertEquals(R.transpose({{10, 11}, {20}, {}, {30, 31, 32}}), {{10, 20, 30}, {11, 31}, {32}})
end

function TestArray.test_unfold()
	local f = function(n)
		if n > 50 then return false end
		return {-n, n + 10}
	end
	this.lu.assertEquals(R.unfold(f, 10), {-10,-20,-30,-40,-50})

	this.lu.assertEquals(R.unfold(R.F, 0), {})
	this.lu.assertEquals(R.unfold(R.T, 0), {})
end

function TestArray.test_uniqBy()
	this.lu.assertEquals(R.uniqBy(R.always(0), {1,-2,3,-4}), {1})
	this.lu.assertEquals(R.uniqBy(math.abs, {-1, -5, 2, 10, 1, 2}), {-1, -5, 2, 10})
end

function TestArray.test_uniq()
	this.lu.assertEquals(R.uniq({1, 1, 2, 1}), {1, 2})
	this.lu.assertEquals(R.uniq({1, '1'}), {1, '1'})
	this.lu.assertEquals(R.uniq({{42}, {42}}), {{42}})
end

function TestArray.test_uniqWith()
	this.lu.assertEquals(R.uniqWith(R.equals, {1, -1, 1, 2, 1}), {1, -1, 2})
end

function TestArray.test_union()
	this.lu.assertEquals(R.union({1, 2, 3}, {2, 3, 4}), {1, 2, 3, 4})
	local l1 = {{a = 1}, {a = 2}}
	local l2 = {{a = 1}, {a = 4}}
	this.lu.assertEquals(R.unionWith(R.eqBy(R.prop('a')), l1, l2), {{a = 1}, {a = 2}, {a = 4}})
end

function TestArray.test_intersection()
	this.lu.assertEquals(R.intersection({1,2,3,4}, {7,6,5,4,3}), {3, 4})
	this.lu.assertEquals(R.intersection({}, {7,6,5,4,3}), {})
	this.lu.assertEquals(R.intersection({1,2,3}, {3,2,1}), {1, 2, 3})
end

function TestArray.test_update()
	this.lu.assertEquals(R.update(1, 11, {1,2,3}), {11,2,3})
	this.lu.assertEquals(R.update(0, 11, {1,2,3}), {1,2,3})
	this.lu.assertEquals(R.update(10, 11, {1,2,3}), {1,2,3})
	this.lu.assertEquals(R.update(3, 11, {1,2,3}), {1,2,11})
	this.lu.assertEquals(R.update(-1, 11, {1,2,3}), {1,2,11})
end

function TestArray.test_unset()
	this.lu.assertEquals(R.unnest({1, {2}, {{3}}}), {1, 2, {3}})
	this.lu.assertEquals(R.unnest({{1, 2}, {3, 4}, {5, 6}}), {1, 2, 3, 4, 5, 6})
end

function TestArray.test_without()
	this.lu.assertEquals(R.without({1, 2}, {1, 2, 1, 3, 4}), {3,4})
end

function TestArray.test_xprod()
	this.lu.assertEquals(R.xprod({1, 2}, {'a', 'b'}), {{1, 'a'}, {1, 'b'}, {2, 'a'}, {2, 'b'}})
	this.lu.assertEquals(R.xprod({}, {}), {})
end

function TestArray.test_zip()
	this.lu.assertEquals(R.zip({1,2,3}, {'a','b','c'}), {{1,'a'}, {2,'b'}, {3,'c'}})
	this.lu.assertEquals(R.zipObj({'a','b','c'}, {1,2,3}), {a=1, b=2, c=3})
	this.lu.assertEquals(R.zipWith(function(a, b) return {a+b, a-b} end, {1,2,3}, {4,5,6}), {{5,-3}, {7,-3}, {9,-3}})
end

return TestArray