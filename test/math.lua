local R = require("../dist/lamda")

TestMath = {}
local this = TestMath

function TestMath.test_abs()
	this.lu.assertEquals(R.abs(1), 1)
	this.lu.assertEquals(R.abs(-1), 1)
	this.lu.assertError(R.abs, '1')
end

function TestMath.test_add()
	this.lu.assertAlmostEquals(R.add(2, 3), 5)
	this.lu.assertAlmostEquals(R.plus(2.2, 3.9), 6.1)
	
	local v_add_curried = R.add(1.5)
	this.lu.assertAlmostEquals(v_add_curried(2.5), 4)

	local v_add_to_curried = R.add(R.__, 1.5)
	this.lu.assertAlmostEquals(v_add_to_curried(2.5), 4)
end

function TestMath.test_subtract()
	this.lu.assertAlmostEquals(R.subtract(2, 3), -1)
	this.lu.assertAlmostEquals(R.minus(3.9, 2.2), 1.7)
	
	local v_add_curried = R.subtract(1.5)
	this.lu.assertAlmostEquals(v_add_curried(2.5), -1)

	local v_add_to_curried = R.subtract(R.__, 1.5)
	this.lu.assertAlmostEquals(v_add_to_curried(2.5), 1)
end

function TestMath.test_clamp()
	this.lu.assertEquals(R.clamp(2, 5, 3), 3)
	this.lu.assertEquals(R.clamp(2, 5, -1), 2)
	this.lu.assertEquals(R.clamp(2, 5, 10), 5)
	this.lu.assertEquals(R.clamp(0, 0)(3), 0)
end

function TestMath.test_dec()
	this.lu.assertEquals(R.dec(100), 99)
	this.lu.assertAlmostEquals(R.dec(.5), -.5)
end

function TestMath.test_divide()
	this.lu.assertAlmostEquals(R.divide(5, 2), 2.5)
	this.lu.assertAlmostEquals(R.divide(5)(2), 2.5)
	this.lu.assertAlmostEquals(R.divide(R.__, 10)(2), 0.2)
end

function TestMath.test_inc()
	this.lu.assertEquals(R.inc(100), 101)
	this.lu.assertAlmostEquals(R.inc(-.5), .5)
end

function TestMath.test_multiply()
	this.lu.assertAlmostEquals(R.multiply(3, 8), 24)
	this.lu.assertAlmostEquals(R.multiply(0.1, 0.2), 0.02)
	this.lu.assertAlmostEquals(R.multiply(-0.142857142857143, 7), -1)
end

function TestMath.test_negate()
	this.lu.assertAlmostEquals(R.negate(1), -1)
	this.lu.assertAlmostEquals(R.negate(0.1), -0.1)
	this.lu.assertAlmostEquals(R.negate(-0), 0)
end

function TestMath.test_product()
	this.lu.assertEquals(R.product({1,2,5,10}), 100)
	this.lu.assertEquals(R.product({}), 1)
end

function TestMath.test_sum()
	this.lu.assertEquals(R.sum({1,2,5,10}), 18)
	this.lu.assertEquals(R.sum({}), 0)
end

function TestMath.test_mean()
	this.lu.assertAlmostEquals(R.mean({1,2,5,10}), 4.5)
	this.lu.assertTrue(R.isNan(R.mean({})))

	this.lu.assertAlmostEquals(R.median({1,2,5,10}), 3.5)
	this.lu.assertTrue(R.isNan(R.median({})))
end

return TestMath