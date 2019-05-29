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

return TestArray