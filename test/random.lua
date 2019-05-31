local R = require("../dist/lamda")
TestRandom = {}
local this = TestRandom

function TestRandom.test_sample()
	local list = {}
	for i = 1, 100 do
		list = R.append(i, list)
	end
	for i = 1, 10 do
		local s = R.sample(3, list)
		this.lu.assertEquals(R.size(s), 3)
		this.lu.assertEquals(R.difference(s, list), {})

		local s = R.sample(30, list)
		this.lu.assertEquals(R.size(s), 30)
		this.lu.assertEquals(R.difference(s, list), {})
	end
end

function TestRandom.test_choice()
	local list = {}
	for i = 1, 100 do
		list = R.append(i, list)
	end
	for i = 1, 10 do
		local s = R.choice(list)
		this.lu.assertTrue(R.contains(s, list))
	end
end

local average = R.converge(R.divide, {R.sum, R.length})

function deviation(list)
	local len = R.size(list)
	local avg = R.sum(list) / len
	return R.sum(R.map(function(v) return (v-avg)*(v-avg) end, list)) / len
end

function TestRandom.test_boxMullerSampling()
	local all = {}
	for i = 1, 1000 do
		local s = R.boxMullerSampling(1, 1)
		all = R.append(s, all)
	end
	local margin = 0.1
	this.lu.assertAlmostEquals(average(all), 1, margin)
	this.lu.assertAlmostEquals(deviation(all), 1, margin)
end

function TestRandom.test_randrange()
	for i = 1, 100 do
		local s = R.randrange(0, 10)
		this.lu.assertTrue(R.isSafeInteger(s))
		this.lu.assertTrue(R.both(R.gte(10), R.lte(0))(s))

		local s = R.randrange(20, 10)
		this.lu.assertTrue(R.isSafeInteger(s))
		this.lu.assertTrue(R.both(R.gte(20), R.lte(10))(s))
	end

	this.lu.assertEquals(R.randrange(20, 20), 20)
	
end


return TestRandom