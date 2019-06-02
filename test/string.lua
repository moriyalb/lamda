local R = require("../dist/lamda")
TestString = {}
local this = TestString

function TestString.test_join()
	this.lu.assertEquals(R.join(" ", {1,2,3}), "1 2 3")
	this.lu.assertEquals(R.join(".")({192,168,1,1}), "192.168.1.1")
	this.lu.assertEquals(R.join("")({"hello", "world"}), "helloworld")
end

function TestString.test_match()
	this.lu.assertEquals(R.match("[a-z]a", 'bananas'), {"ba", "na", "na"})
	this.lu.assertEquals(R.match("a", 'b'), {})
end

function TestString.test_toLower()
	this.lu.assertEquals(R.toLower("hELlo"), "hello")
	this.lu.assertEquals(R.toLower(""), "")
end

function TestString.test_toUpper()
	this.lu.assertEquals(R.toUpper("hELlo"), "HELLO")
	this.lu.assertEquals(R.toUpper(""), "")
end

function TestString.test_replace()
	this.lu.assertEquals(R.replace('foo', 'bar', 1, 'foo foo foo'), 'bar foo foo')
	this.lu.assertEquals(R.replace('foo', 'bar', 0, 'foo foo foo'), 'bar bar bar')
end

function TestString.test_split()
	this.lu.assertEquals(R.split('hh', 'hhvvhhhvhvhhhhhhvvvhh'), {"", "vv", "hvhv", "", "", "vvv", ""})
	local pathComponents = R.split('/')
	this.lu.assertEquals(R.tail(pathComponents('/usr/local/bin')), {'usr', 'local', 'bin'})
	this.lu.assertEquals(R.split('.', 'a.b.c.xyz.d'), {'a', 'b', 'c', 'xyz', 'd'})
	this.lu.assertEquals(R.split('.......', ""), {""})
end

function TestString.test_startsWith()
	this.lu.assertTrue(R.startsWith('a', 'abc'))
	this.lu.assertFalse(R.startsWith('b', 'abc'))
	this.lu.assertTrue(R.startsWith({'a'}, {'a', 'b', 'c'}))
	this.lu.assertFalse(R.startsWith({'b'}, {'a', 'b', 'c'}))
end

function TestString.test_endsWith()
	this.lu.assertFalse(R.endsWith('a', 'abc'))
	this.lu.assertTrue(R.endsWith('c', 'abc'))
	this.lu.assertFalse(R.endsWith({'a'}, {'a', 'b', 'c'}))
	this.lu.assertTrue(R.endsWith({'c'}, {'a', 'b', 'c'}))
end

function TestString.test_test()
	this.lu.assertTrue(R.test("^x", 'xyz'))
	this.lu.assertFalse(R.test("^y", 'xyz'))
end

function TestString.test_trim()
	this.lu.assertEquals(R.trim('   xyz  '), "xyz")
	this.lu.assertEquals(R.map(R.strip, R.split(',', 'x, y, z')), {'x', 'y', 'z'})
end

return TestString