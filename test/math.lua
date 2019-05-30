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
	this.lu.assertEquals(R.clamp(5, 2, 10), 5)
	this.lu.assertEquals(R.clamp(5, 2, -1), 2)
	this.lu.assertEquals(R.clamp(5, 2)(3), 3)
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

return TestMath