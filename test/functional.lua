local R = require("../dist/lamda")

TestFunc = {}
local this = TestFunc

function TestFunc.test_always()
	local v_zero = R.always(0)
	this.lu.assertEquals(v_zero(), 0)
	this.lu.assertEquals(v_zero(), v_zero())

	local always_curried = R.always()
	local v_two = always_curried(2)
	this.lu.assertEquals(v_two(), 2)
	this.lu.assertEquals(v_two(), v_two())
end

function TestFunc.test_tf()
	this.lu.assertFalse(R.F())
	this.lu.assertTrue(R.T())
end

function TestFunc.test_allPass()
	local pred = R.allPass(R.gt(5), R.lt(3))
	this.lu.assertTrue(pred(4))
	this.lu.assertFalse(pred(2))
	this.lu.assertFalse(pred(8))

	pred = R.allPass()
	this.lu.assertTrue(pred())

	pred = R.allPass(R.o(R.equals(3), R.size), R.all(R.equals(3)))
	this.lu.assertTrue(pred({3, 3, 3}))
	this.lu.assertFalse(pred({3, 3}))
	this.lu.assertFalse(pred({}))
	this.lu.assertFalse(pred({2, 3, 3}))
end

function TestFunc.test_and_()
	this.lu.assertTrue(R.and_(true, true))
	this.lu.assertFalse(R.and_(true, false))
	this.lu.assertFalse(R.and_(false, true))
	this.lu.assertFalse(R.and_(false, false))
end

function TestFunc.test_anyPass()
	local pred = R.anyPass(R.gt(3), R.lt(5))
	this.lu.assertTrue(pred(2))
	this.lu.assertTrue(pred(8))
	this.lu.assertFalse(pred(4))

	pred = R.anyPass()
	this.lu.assertFalse(pred())

	pred = R.anyPass(R.o(R.equals(3), R.size), R.all(R.equals(3)))
	this.lu.assertTrue(pred({3, 3, 3, 3, 3, 3}))
	this.lu.assertFalse(pred({2, 3}))
	this.lu.assertTrue(pred({}))
	this.lu.assertTrue(pred({2, 3, 3}))
end

function TestFunc.test_apply()
	local f = function (a, b, c)
		return a + b + c
	end
	this.lu.assertEquals(R.apply(f, {1,2,3}), 6)

	local max = R.apply(math.max)
	this.lu.assertEquals(max({1,2,3,4}), 4)
end

function TestFunc.test_ascend()
	local byAge = R.ascend(R.prop('age'))
	local people = {
		{ name = 'Emma', age = 70 },
		{ name = 'Peter', age = 78 },
		{ name = 'Mikhail', age = 62 },
	}
	local peopleByYoungestFirst = R.sort(byAge, people)
	this.lu.assertEquals(peopleByYoungestFirst, {{name = "Mikhail", age = 62}, {name = "Emma", age = 70}, {name = "Peter", age = 78}})
end

function TestFunc.test_descend()
	local byAge = R.descend(R.prop('age'))
	local people = {
		{ name = 'Emma', age = 70 },
		{ name = 'Peter', age = 78 },
		{ name = 'Mikhail', age = 62 },
	}
	local peopleByYoungestFirst = R.sort(byAge, people)
	this.lu.assertEquals(peopleByYoungestFirst, {{name = "Peter", age = 78}, {name = "Emma", age = 70}, {name = "Mikhail", age = 62}})
end

function TestFunc.test_ary()
	local f = function(a, b, c, d, e, f, g)
		return {a, b, c, d, e, f, g}
	end

	local uf = R.unary(f)
	this.lu.assertEquals(uf(1,2,3,4,5,6,7), {1})
	this.lu.assertEquals(uf(), {})

	local bf = R.binary(f)
	this.lu.assertEquals(bf(1,2,3,4,5,6,7), {1,2})
	this.lu.assertEquals(bf(1), {1})
	this.lu.assertEquals(bf(), {})

	local ff = R.nAry(4, f)
	this.lu.assertEquals(ff(1,2,3,4,5,6,7), {1,2,3,4})
	this.lu.assertEquals(ff(1), {1})
	this.lu.assertEquals(ff(), {})
end

function TestFunc.test_bind()
	local obj = {a = 1}	
	function obj:modify()
		self.a = 2
	end
	local modify_a = R.bind(obj.modify, obj)
	modify_a()
	this.lu.assertEquals(obj.a, 2)
end

function TestFunc.test_both()
	local gt = R.gt(100)
	local lt = R.lt(50)
	this.lu.assertTrue(R.both(gt, lt)(75))
	this.lu.assertFalse(R.both(gt, lt)(25))

	local len3_and_all_gt_5 = R.both(R.o(R.equals(3), R.size))(R.all(R.lt(5)))
	this.lu.assertTrue(len3_and_all_gt_5({6,7,8}))
	this.lu.assertFalse(len3_and_all_gt_5({3,7,8}))
end

function TestFunc.test_cond()
	local cond = R.cond({
		{R.equals(5), 		R.T},
		{R.equals(8), 		R.F},
		{R.lt(100), 		function(v) return v*2 end}
	})
	this.lu.assertTrue(cond(5))
	this.lu.assertFalse(cond(8))
	this.lu.assertEquals(cond(150), 300)
	this.lu.assertNil(cond(50))
end

function TestFunc.test_comparator()
	local byAge = R.comparator(function(a, b)
		return a.age < b.age
	end)
	local people = {
		{ name = 'Emma', age = 70 },
		{ name = 'Peter', age = 78 },
		{ name = 'Mikhail', age = 62 },
	}
	local peopleByYoungestFirst = R.sort(byAge, people)
	this.lu.assertEquals(peopleByYoungestFirst, {{name = "Mikhail", age = 62}, {name = "Emma", age = 70}, {name = "Peter", age = 78}})
end

function TestFunc.test_complement()
	local isNotNil = R.complement(R.isNil)
	this.lu.assertTrue(R.isNil(nil))
	this.lu.assertFalse(isNotNil(nil))
	this.lu.assertFalse(R.isNil(7))
	this.lu.assertTrue(isNotNil(7))
end

function TestFunc.test_converge()
	local average = R.converge(R.divide, {R.sum, R.length})
	this.lu.assertEquals(average({1,2,3,10}), 4)
	local strangeConcat = R.converge(R.concat, {R.toUpper, R.toLower})
	this.lu.assertEquals(strangeConcat("Hello"), "HELLOhello")
end

function TestFunc.test_curry()
	local f1 = R.curry1(function(a) return a + 1 end)
	this.lu.assertEquals(f1()()(5), 6)

	local f2 = R.curry2(function(a, b) return a + b end)
	this.lu.assertEquals(f2()(5)()(6), 11)

	f2 = R.curry2(function(a, b, c) return a + b + c end)
	this.lu.assertEquals(f2()(5)()(6, 1), 12)

	local f3 = R.curry3(function(a, b, c) return a + b + c end)
	this.lu.assertEquals(f3()(1)()(2,3), 6)

	f3 = R.curry3(function(a, b, c, d) return a + b + c + d end)
	this.lu.assertError(f3()(1)(), 2, 3)
	this.lu.assertEquals(f3()(1)()(2,3,4), 10)

	local f5 = R.curryN(5, function(a, b, c, d, e) return a + b + c + d + e end)
	this.lu.assertEquals(f5()(1)()(2,3)()()(4)(-10), 0)
end

function TestFunc.test_either()
	this.lu.assertFalse(R.either(R.gte(3), R.lte(5))(4))
	this.lu.assertTrue(R.either(R.gte(3), R.lte(5))(2))
	this.lu.assertTrue(R.either(R.gte(3), R.lte(5))(6))
end

function TestFunc.test_flip()
	local f = function(a,b,c,d)
		return a..b..c..d
	end
	this.lu.assertEquals(R.flip(f)(1,2,3,4), "2134")
	this.lu.assertIsFunction(R.flip(f)(1))
	local strangelt = R.flip(R.gt)
	this.lu.assertEquals(R.sort(strangelt, {5,1,3,2,4}), {1,2,3,4,5})
end

function TestFunc.test_identity()
	local obj = {}
	this.lu.assertIs(R.identity(obj), obj)
	local f = function() end
	this.lu.assertIs(R.identity(f), f)
end

function TestFunc.test_ifelse()
	local whaterve = R.ifElse(
		R.has('count'),
		R.dissoc('count'),
		R.assoc('count', 1)
	)
	this.lu.assertEquals(whaterve({}), {count = 1})
	this.lu.assertEquals(whaterve({count = 1}), {})
end

function TestFunc.test_juxt()
	local getRange = R.juxt({math.min, math.max})
	this.lu.assertEquals(getRange(1,-2,3,-4), {-4,3})
	local judgeValue = R.juxt({R.all(R.equals(1)), R.any(R.gt(3))})
	this.lu.assertEquals(judgeValue({1,2,3,4}), {false, true})
end

function TestFunc.test_map()
	this.lu.assertEquals(R.map(R.add(3), {1,2,3}), {4,5,6})
	this.lu.assertEquals(R.sort(R.lt, R.map(R.add(3), {a=1,b=2,c=3})), {4,5,6}) --map could not assume the key sequences
	local revert_map = R.o(R.fromPairs, R.map(R.flip(R.pair))) 
	this.lu.assertEquals({a=1,b=2,c=3}, revert_map({a=1,b=2,c=3}))
end

function TestFunc.test_mapAccum()
	local digits = {'1', '2', '3', '4'}
	local appender = R.juxt({R.concat, R.concat})
	this.lu.assertEquals(R.mapAccum(appender, 0, digits), {"01234", {"01", "012", "0123", "01234"}})
end

function TestFunc.test_mapAccumRight()
	local digits = {'1', '2', '3', '4'}
	local appender = R.juxt({R.concat, R.concat})
	this.lu.assertEquals(R.mapAccumRight(appender, 5, digits), {{'12345', '2345', '345', '45'}, '12345'})	
end

function TestFunc.test_memoizeWith()
	local count = 0
	local factorial = R.memoizeWith(R.identity, function(n)
		count = count + 1
		return R.product(R.range(1, n + 1))
	end)
	this.lu.assertEquals(factorial(5), 120)
	this.lu.assertEquals(factorial(5), 120)
	this.lu.assertEquals(factorial(5), 120)
	this.lu.assertEquals(count, 1)

	this.lu.assertEquals(factorial(6), 720)
	this.lu.assertEquals(count, 2)
end

function TestFunc.test_memoize()
	local count = 0
	local factorial = R.memoize(function(n)
		count = count + 1
		return R.product(R.range(1, n + 1))
	end)
	this.lu.assertEquals(factorial(5), 120)
	this.lu.assertEquals(factorial(5), 120)
	this.lu.assertEquals(factorial(5), 120)
	this.lu.assertEquals(count, 1)

	this.lu.assertEquals(factorial(6), 720)
	this.lu.assertEquals(count, 2)
end

function TestFunc.test_not_()
	this.lu.assertFalse(R.not_(true))
	this.lu.assertTrue(R.not_(false))
	this.lu.assertFalse(R.not_(1))
	this.lu.assertFalse(R.not_(0))
end

function TestFunc.test_or_()
	this.lu.assertTrue(R.or_(true, true))
	this.lu.assertTrue(R.or_(true, false))
	this.lu.assertTrue(R.or_(false, true))
	this.lu.assertFalse(R.or_(false, false))
end

function TestFunc.test_pipe()
	local f = R.pipe(R.add(1), R.add(2), R.minus(R.__, 3), R.multiply(4), R.add(5))
	this.lu.assertEquals(f(10), 45)
end

function TestFunc.test_compose()
	local f = R.compose(R.add(1), R.add(2), R.minus(R.__, 3), R.multiply(4), R.add(5))
	this.lu.assertEquals(f(10), 60)
end

function TestFunc.test_of()
	this.lu.assertEquals(R.of(42), {42})
	this.lu.assertEquals(R.of({42}), {{42}})
end

function TestFunc.test_once()
	local addOnce = R.once(R.add(1))
	this.lu.assertEquals(addOnce(10), 11)
	this.lu.assertEquals(addOnce(11), 11)
	this.lu.assertEquals(addOnce(function()
		this.lu.assertFalse(true) --never be called
	end), 11)
end

function TestFunc.test_partial()
	local double = R.partial(R.multiply, 2)
	this.lu.assertEquals(double(2), 4)
	local greet = function (salutation, title, firstName, lastName) 
		return salutation .. ', ' .. title .. ' ' .. firstName .. ' ' .. lastName .. '!'
	end
	local sayHello = R.partial(greet, 'Hello')
	local sayHelloToMs = R.partial(sayHello, 'Ms.')
	this.lu.assertEquals(sayHelloToMs('Jane', 'Jones'), 'Hello, Ms. Jane Jones!')

	local greetMsJaneJones = R.partialRight(greet, 'Ms.', 'Jane', 'Jones')	
	this.lu.assertEquals(greetMsJaneJones('Hello'), 'Hello, Ms. Jane Jones!')
end

function TestFunc.test_mirror()
	local obj = {a=1, b=2}
	this.lu.assertEquals(R.mirror(obj), {{a=1, b=2}, {a=1, b=2}})

	this.lu.assertEquals(R.mirrorBy(R.size, {1,2,3}), {{1,2,3}, 3})
	this.lu.assertEquals(R.mirrorBy(R.clone)({1,2,3}), {{1,2,3}, {1,2,3}})
end

return TestFunc