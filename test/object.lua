local R = require("../dist/lamda")
TestObject = {}
local this = TestObject

function TestObject.test_assoc()
	this.lu.assertEquals(R.assoc("c", 5, {a = 1}), {a = 1, c = 5})
	this.lu.assertEquals(R.assoc("c", 5, {a = 1, c = 3}), {a = 1, c = 5})
	local ref_obj = {a = 1}
	local assoc_obj = R.assoc("c", 5)({ref = ref_obj})
	this.lu.assertEquals(assoc_obj, {ref = {a = 1}, c = 5})
	ref_obj.a = 2
	this.lu.assertEquals(assoc_obj, {ref = {a = 2}, c = 5})
	this.lu.assertIs(assoc_obj.ref, ref_obj)
end

function TestObject.test_assocPath()
	this.lu.assertEquals(R.assocPath({'b', 'c'}, 5, {a = 1}), {a = 1, b = {c = 5}})
	this.lu.assertEquals(R.assocPath({'a', 'c'}, 5, {a = 1}), {a = {c = 5}})
	this.lu.assertEquals(R.assocPath({'a', 'c'}, 5, {}), {a = {c = 5}})
	this.lu.assertEquals(R.assocPath({'x', 'y', 'z'}, 11, {x={y={z={1}}}}), {x={y={z=11}}})
end

function TestObject.test_clone()
	local obj = {{},{}}
	local obj_cloned = R.clone(obj)
	this.lu.assertNotIs(obj, obj_cloned)
	this.lu.assertNotIs(obj[1], obj_cloned[1])
end

function TestObject.test_dissoc()
	local obj = {a = {b = 1}, c = 2, d = 3}
	local obj_dissoced = R.dissoc('a', obj)
	this.lu.assertEquals(obj_dissoced, {c = 2, d = 3})

	obj_dissoced = R.dissoc('m', obj)
	this.lu.assertEquals(obj_dissoced, obj)
end

function TestObject.test_dissocPath()
	local obj = {a = {b = 1, e = 4}, c = 2, d = 3}
	local obj_dissoced = R.dissocPath({'a', 'b'}, obj)
	this.lu.assertEquals(obj_dissoced, {a = {e = 4}, c = 2, d = 3})

	obj_dissoced = R.dissocPath({'m'}, obj)
	this.lu.assertEquals(obj_dissoced, obj)
end

function TestObject.test_fromPairs()
	this.lu.assertEquals(R.fromPairs({{'a',1}, {'b', 2}}), {a = 1, b = 2})
	this.lu.assertEquals(R.fromPairs({}), {})
end

function TestObject.test_has()
	this.lu.assertTrue(R.has('a', {a = 1}))
	this.lu.assertFalse(R.has('b', {a = 1}))
	local has = R.has(R.__, {a = 1})
	this.lu.assertTrue(has('a'))
	this.lu.assertFalse(has('c'))
end

function TestObject.test_invert()
	local raceResultsByFirstName = {
		first = 'alice',
		second = 'jake',
		third = 'alice',
	}
	local nbj = R.invert(raceResultsByFirstName)
	this.lu.assertEquals(nbj.jake, {"second"})
	this.lu.assertEquals(R.difference(nbj.alice, {"third", "first"}), {})

	nbj = R.invertObj(raceResultsByFirstName)
	this.lu.assertTrue(R.contains(nbj.alice, {"first", "third"}))
	this.lu.assertEquals(nbj.jake, "second")

	this.lu.assertEquals(R.invertObj({1,2,3}), {["1"]=1, ["2"]=2, ["3"]=3})
end

function TestObject.test_merge()
	this.lu.assertEquals(R.merge({a=1,b=2}, {a=2,c=3}, {a=3,d=4}), {a=3,b=2,c=3,d=4})
	this.lu.assertEquals(R.mergeAll({{a=1,b=2}, {a=2,c=3}, {a=3,d=4}}), {a=3,b=2,c=3,d=4})
end

function TestObject.test_mergeDeep()
	local concatValues = function(k, l, r)
		return k == 'values' and R.concat(l, r) or r
	end

	local v = R.mergeDeepWithKey(concatValues,
		{ a = true, c = { thing = 'foo', values = {10, 20} }},
		{ b = true, c = { thing = 'bar', values = {15, 35} }}
	)
	this.lu.assertEquals(v, {a=true, b=true, c={thing="bar", values={10, 20, 15, 35}}})

	v = R.mergeDeepLeft({ name = 'fred', age = 10, contact = { email = 'moo@example.com' }},
						{ age = 40, contact = { email = 'baa@example.com' }})
	this.lu.assertEquals(v, {age=10, contact={email="moo@example.com"}, name="fred"})	

	v = R.mergeDeepRight({ name = 'fred', age = 10, contact = { email = 'moo@example.com' }},
						{ age = 40, contact = { email = 'baa@example.com' }})
	this.lu.assertEquals(v, {age=40, contact={email="baa@example.com"}, name="fred"})	

	v = R.mergeDeepWith(R.concat,
		{ a = true, c = { values = {10, 20} }},
		{ b = true, c = { values = {15, 35} }})
	this.lu.assertEquals(v, {a=true, b=true, c={values={10, 20, 15, 35}}})

	v = R.mergeWith(R.concat,
		{ a = true, values = {10, 20} },
		{ b = true, values = {15, 35} })
	this.lu.assertEquals(v, {a=true, b=true, values = {10, 20, 15, 35}})

	v = R.mergeWithKey(concatValues,
		{ a = true, thing = 'foo', values = {10, 20} },
		{ b = true, thing = 'bar', values = {15, 35} })
	this.lu.assertEquals(v, {a=true, b=true, thing="bar", values={10, 20, 15, 35}})
end

function TestObject.test_objOf()
	local matchPhrases = R.compose(
		R.objOf('must'),
		R.map(R.objOf('match_phrase'))
	)
	this.lu.assertEquals(matchPhrases({'foo', 'bar', 'baz'}), {must={{match_phrase="foo"}, {match_phrase="bar"}, {match_phrase="baz"}}})
end

function TestObject.test_omit()
	this.lu.assertEquals(R.omit({'a','b'}, {a=1,b=2,c=3,d=4}), {c=3,d=4})
	this.lu.assertEquals(R.omit({}, {a=1,b=2,c=3,d=4}), {a=1,b=2,c=3,d=4})
end

function TestObject.test_path()
	this.lu.assertEquals(R.path({'a', 'b'}, {a = {b = 2}}), 2)
	this.lu.assertNil(R.path({'a', 'c'}, {a = {b = 2}}))
	this.lu.assertEquals(R.path({'a', 'b', 1, 2}, {a = {b = {"hello"}}}), "e")
end

function TestObject.test_pathEq()
	local user1 = { address = { zipCode = 90210 } }
	local user2 = { address = { zipCode = 55555 } }
	local user3 = { name = 'Bob' }
	local users = { user1, user2, user3 }
	local isFamous = R.pathEq({'address', 'zipCode'}, 90210)
	this.lu.assertEquals(R.filter(isFamous, users), {{address={zipCode=90210}}})
end

function TestObject.test_pathOr()
	this.lu.assertEquals(R.pathOr('N/A', {'a', 'b'}, {a = {b = 2}}), 2)
	this.lu.assertEquals(R.pathOr('N/A', {'a', 'b'}, {a = {c = 2}}), "N/A")
end

function TestObject.test_pluck()
	this.lu.assertEquals(R.pluck('a')({{a = 1}, {a = 2}}), {1, 2})
	this.lu.assertEquals(R.pluck(1)({{1, 2}, {3, 4}}), {1, 3})
	this.lu.assertEquals(R.pluck('val', {a = {val = 3}, b = {val = 5}}), {a=3, b=5})
end

function TestObject.test_pathSatisfied()
	this.lu.assertTrue(R.pathSatisfies(R.lt(0), {'x', 'y'}, {x = {y = 2}}))
	this.lu.assertTrue(R.pathSatisfies(R.isNil, {'x', 'z'}, {x = {y = 2}}))
	local pathExists = R.pathSatisfies(R.complement(R.isNull))
	this.lu.assertTrue(pathExists({'a', 'b', 2}, {a = {b = {3, 4}}}))
	this.lu.assertFalse(pathExists({'a', 'b', 2}, {a = 5, b = 6}))	
end

function TestObject.test_pick()
	this.lu.assertEquals(R.pick({'a', 'd'}, {a = 1, b = 2, c = 3, d = 4}), {a = 1, d = 4})
	this.lu.assertEquals(R.pick({'a', 'e', 'f'}, {a = 1, b = 2, c = 3, d = 4}), {a = 1})
end

function TestObject.test_pickAll()
	this.lu.assertEquals(R.pickAll({'a', 'd'}, {a = 1, b = 2, c = 3, d = 4}), {a = 1, d = 4})
	this.lu.assertEquals(R.pickAll({'a', 'e', 'f'}, {a = 1, b = 2, c = 3, d = 4}), {a = 1})
end

function TestObject.test_pickBy()
	local isUpperCase = R.compose(R.safeEquals, R.unpack, R.mirrorBy(R.toUpper), R.second)		
	this.lu.assertEquals(R.pickBy(isUpperCase, {a = 1, b = 2, A = 3, B = 4}), {A=3, B=4})
end

function TestObject.test_prop()
	this.lu.assertEquals(R.prop('a', {a = 5, b = 6}), 5)
	this.lu.assertNil(R.prop('c', {a = 5, b = 6}))

	this.lu.assertTrue(R.propIs(R.NUMBER, 'x', {x = 1, y = 2}))
	this.lu.assertFalse(R.propIs(R.NUMBER, 'x', {x = 'a', y = 2}))
	this.lu.assertFalse(R.propIs(R.NUMBER, 'x', {y = 2}))
	
end

function TestObject.test_prop2()
	local alice = {
		name = 'ALICE',
		age = 101
	}
	local favorite = R.prop('favoriteLibrary')
	local favoriteWithDefault = R.propOr('Lamda', 'favoriteLibrary')

	this.lu.assertNil(favorite(alice))
	this.lu.assertEquals(favoriteWithDefault(alice), 'Lamda')

	this.lu.assertTrue(R.propSatisfies(R.lt(0), 'x', {x = 1, y = 2}))
	this.lu.assertFalse(R.propSatisfies(R.lt(0), 'z', {x = 1, y = 2}))
	this.lu.assertTrue(R.propSatisfies(R.isNil, 'z', {x = 1, y = 2}))
end

function TestObject.test_prop3()
	this.lu.assertEquals(R.props({'x', 'y'}, {x = 1, y = 2}), {1,2})
	this.lu.assertEquals(R.props({'c', 'a', 'b'}, {b = 2, a = 1}), {[2]=1, [3]=2})
	
	local fullName = R.compose(R.join(' '), R.props({'first', 'last'}))
	this.lu.assertEquals(fullName({last = 'Bullet-Tooth', age = 33, first = 'Tony'}), "Tony Bullet-Tooth")

	local abby = {name = 'Abby', age = 7, hair = 'blond'}
	local fred = {name = 'Fred', age = 12, hair = 'brown'}
	local rusty = {name = 'Rusty', age = 10, hair = 'brown'}
	local alois = {name = 'Alois', age = 15, disposition = 'surly'}
	local kids = {abby, fred, rusty, alois}
	local hasBrownHair = R.propEq('hair', 'brown')
	this.lu.assertEquals(R.filter(hasBrownHair, kids), {{age=12, hair="brown", name="Fred"}, {age=10, hair="brown", name="Rusty"}})
end

function TestObject.test_toPairs()
	local obj = {a=1, b=2, c=3}
	this.lu.assertEquals(R.fromPairs(R.toPairs(obj)), obj)
end

function TestObject.test_project()
	local abby = {name = 'Abby', age = 7, hair = 'blond', grade = 2}
	local fred = {name = 'Fred', age = 12, hair = 'brown', grade = 7}
	local kids = {abby, fred}
	this.lu.assertEquals(R.project({'name', 'grade'}, kids), {{name = 'Abby', grade = 2}, {name = 'Fred', grade = 7}})
end

function TestObject.test_where()
	-- pred :: Object -> Boolean
	local pred = R.where({
		a = R.equals('foo'),
		b = R.complement(R.equals('bar')),
		x = R.gt(R.__, 10),
		y = R.lt(R.__, 20)
	})

	this.lu.assertTrue(pred({a = 'foo', b = 'xxx', x = 11, y = 19}))
	this.lu.assertFalse(pred({a = 'xxx', b = 'xxx', x = 11, y = 19}))
	this.lu.assertFalse(pred({a = 'foo', b = 'bar', x = 11, y = 19}))
	this.lu.assertFalse(pred({a = 'foo', b = 'xxx', x = 10, y = 19}))
	this.lu.assertFalse(pred({a = 'foo', b = 'xxx', x = 11, y = 20}))
end

function TestObject.test_whereEq()
	local pred = R.whereEq({a = 1, b = 2})

	this.lu.assertFalse(pred({a = 1}))
	this.lu.assertTrue(pred({a = 1, b = 2}))
	this.lu.assertTrue(pred({a = 1, b = 2, c = 3}))
	this.lu.assertFalse(pred({a = 1, b = 1}))
end

return TestObject