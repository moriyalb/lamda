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
	this.lu.assertEquals(R.toString({'a', nil, true, 4}), '{1:"a",3:true,4:4}') --nil treats like absent, so this is like an object
	this.lu.assertEquals(R.toString({{{{a = 1}}}}), '{{{{"a":1}}}}')
end


return TestUtil