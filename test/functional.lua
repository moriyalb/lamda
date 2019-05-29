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

return TestFunc