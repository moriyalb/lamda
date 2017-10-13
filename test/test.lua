package.path = package.path .. ";C:\\Work\\Lib\\lamda\\?.lua"

local R = require("dist.lamda")

-- function id(v)
-- 	return "id"..v
-- end

-- local curryid = R.curry1(id)
--print(curryid("a"))
--print(curryid)
--print(curryid(R.__)(R.__)(R.__)('a'))
--print(R.add(1, 3))

-- print(R.add)
-- print(R.add(1))
-- print(R.add(R.__))
-- print(R.add(1, R.__))
-- print(R.add(R.__, 1))
-- print(R.add(1)(2))
-- print(R.add(R.__, 1)(2))
-- print(R.add(1, R.__)(2))

--print(R.T(), R.F())

-- local isQueen = R.propEq('rank', 'Q')
-- local isSpade = R.propEq('suit', '♠︎')
-- local isQueenOfSpades = R.allPass(isQueen, isSpade)
-- print(isQueenOfSpades({rank = 'Q', suit = '♣︎'})) -- => false
-- print(isQueenOfSpades({rank = 'Q', suit = '♠︎'})) -- => true

-- local lessThan0 = R.lt(R.__, 0)
-- local lessThan2 = R.lt(R.__, 2)
-- print(R.any(lessThan0)({1, 2})) -- => false
-- print(R.any(lessThan2)({1, 2})) -- => true

-- local isClub = R.propEq('suit', '♣')
-- local isSpade = R.propEq('suit', '♠')
-- local isBlackCard = R.anyPass(isClub, isSpade)
-- print(isBlackCard({rank = '10', suit ='♣'})) -- => true
-- print(isBlackCard({rank = 'Q', suit = '♠'})) -- => true
-- print(isBlackCard({rank = 'Q', suit = '♦'})) -- => false

--local cid = R._curryN(1, {}, id)
--print(cid('a')('b'))
-- local tmp = R.adjust(function(v) return v*5 end, 1, {1,2,3,4})
-- print(tmp[1], tmp[2], tmp[3], tmp[4])
-- tmp = R.adjust(function(v) return v*5 end, -1, {1,2,3,4})
-- print(tmp[1], tmp[2], tmp[3], tmp[4])
-- local addto5 = R.adjust(R.add(5), 3)
-- tmp = addto5({1,2,3,4})
-- print(tmp[1], tmp[2], tmp[3], tmp[4])

--local equals3 = R.equals({3,3,3,3})
--print( R.all(equals3)({{3, 3, 3, 3}}) )
--print( R.all(equals3)({3, 3, 4, 3}) )

--print( R.equals(3, nil) )
--print( R.equals({a=1,b=2,c=3}, {a=1,b=2,c=3}))

--print(R.always("Tee")())

-- print(R.and_(true, true)) -- //=> true
-- print(R.and_(true, false)) -- //=> false
-- print(R.and_(false, true)) -- //=> false
-- print(R.and_(false, false)) -- //=> false

-- print(R.any(function(v)
-- 	return v == 13
-- end)({1, 2}))

--print(R.toString({1,2,3}))
-- print(R.toString(R.aperture(2, {1, 2, 3, 4, 5})))
-- print(R.toString(R.aperture(3, {1, 2, 3, 4, 5})))
-- print(R.toString(R.aperture(7, {1, 2, 3, 4, 5})))

--print(R.toString(R.append('tests', {'write', 'more'})))

--print(R.clamp(1, 10, -5))

-- local C = {
-- }
-- function C:test()
-- 	print (self.testValue)
-- end
-- local bt = R.bind(C.test, {testValue = 101})
-- print(bt())

--print(R.toString(R.assoc('c', 3, {a = 1, b = 2})))
--print(R.toString(R.assocPath({'a', 'b', 'c'}, 43, {a = 5})))

-- local takesThreeArgs = function(a, b, c)
-- 	return {a, b, c}
-- end
-- print(R.toString(takesThreeArgs(1, 2, 3))) -- => {1, 2, 3}
-- local takesTwoArgs = R.binary(takesThreeArgs)
-- --Only 2 arguments are passed to the wrapped function
-- print(R.toString(takesTwoArgs(1, 2, 3))) -- => {1, 2}

-- local str = "test hello world" -- length is 16
-- local strlen = R.bind(string.len, str)
-- print(R.toString(R.map(strlen, R.split(",", "123,4,56789"))))

-- local objects = {{}, {}, {}}
-- local objectsClone = R.clone(objects)
-- print("1", objects == objectsClone) -- => false
-- print("2", objects[1] == objectsClone[1]) -- => false

-- local duplicate = function(n) return {n, n} end
-- print(R.toString(R.chain(duplicate, {1, 2, 3}))) -- => {1, 1, 2, 2, 3, 3}
-- print(R.toString(R.chain(R.append, R.head)({1, 2, 3}))) -- => {1, 2, 3, 1}

-- local fn = R.cond({
-- 	{R.equals(0),   R.always('water freezes at 0°C')},
-- 	{R.equals(100), R.always('water boils at 100°C')},
-- 	{R.T,           function(temp) return 'nothing special happens at ' .. temp .. '°C' end}
-- })
-- print(fn(0)) -- => 'water freezes at 0°C'
-- print(fn(50)) -- => 'nothing special happens at 50°C'
-- print(fn(100)) -- => 'water boils at 100°C'

-- print(R.contains(3, {1, 2, 3})) -- => true
-- print(R.contains(4, {1, 2, 3})) -- => false
-- print(R.contains({ name = 'Fred' }, {{ name = 'Fred' }})) -- => true
-- print(R.contains({42}, {{42}})) -- => true

-- local sumArgs = function(...) return R.sum({...}) end
-- local curriedAddFourNumbers = R.curryN(4, sumArgs)
-- local f = curriedAddFourNumbers(1, 2)
-- local g = f(3)
-- print(g(4)) -- => 10

--print(R.dec(42))
-- local a = {{a = 1}, {a = 2}, {a = 3}}
-- local b = {{a = 3}, {a = 4}, {a = 6}}
-- local x = R.differenceWith(function(a, b)
-- 	return a.a == b.a
-- end, a, b)
-- print(R.toString(x))

--print(R.toString(R.dissoc("b", {a = 1, b = 2})))

-- print(R.toString(R.dropWhile(function(v) 
-- 	return v <= 2
-- end, {1, 2, 3, 4, 3, 2, 1})))

-- local s = {4,5,6}
-- local f = R.findLastIndex(R.equals(4), s)
-- print(f)

--print(R.toString(R.flatten({1, 2, {3, 4}, 5, {6, {7, 8, {9, {10, 11}, 12}}}})))

--print(R.toString(R.fromPairs({{'a', 1}, {'b', 2}, {'c', 3}})))

--print(R.toString(R.groupWith(R.equals, {0, 1, 1, 2, 3, 5, 8, 13, 21})))

--print(R.inc(42))

-- local f = R.innerJoin(
--      function(record, id) return record.id == id end,
--      {{id = 824, name = 'Richie Furay'},
--       {id = 956, name = 'Dewey Martin'},
--       {id = 313, name = 'Bruce Palmer'},
--       {id = 456, name =  'Stephen Stills'},
--       {id = 177, name = 'Neil Young'}},
--      {177, 456, 999}
-- )
-- print(R.toString(f))

--print(R.toString(R.insert(2, "x", {1,2,3,4,5})))
--print(R.toString(R.insertAll(2, {"x","y","z"}, {1,2,3,4,5})))

-- print(R.toString(R.concat({1,2,3}, {2,3,4})))
-- print(R.toString(R.concat("abc","cde")))

--print(R.toString(R.intersperse('n', {'ba', 'a', 'a'})))

-- local digits = {'1', '2', '3', '4'}
-- local appender = function(a, b) return {a .. b, a .. b} end   
-- print(R.toString(R.mapAccum(appender, 0, digits)))

-- local s = R.mapAccumRight(function(a,b) return {a..b,a..b} end, 5, {"1","2","3","4"})
-- print(R.toString(s))

--local s = R.match("%a+", "Hello world from Lua")
-- local s = R.match("[a-z]a", "bananas")
--print(R.toString(R.match('a', 'b')))
-- print(R.toString(s))

-- print(R.mathMod(-17,5))
-- print(R.max('a','b'))

--print(R.toString(R.mergeAll({{a=1,b=2}, {b=1,c=2}})))
-- local isEven = function(n) return n % 2 == 0 end
-- print(R.none(isEven, {1, 232, 5, 7, 9, 11}))

-- print(R.nth(2, "abcde"))
-- print(R.nth(-1, "abcde"))

--print(R.toString(R.path({'a', 'b'}, {a = {b = 2}})))
--print(R.pathOr("haha", {'c', 'b'}, {a = {b = 2}}))
--print(R.toString(R.last('')))

-- local user1 = { address = { zipCode = 90210 } }
-- local user2 = { address = { zipCode = 55555 } }
-- local user3 = { name =  'Bob' }
-- local users = { user1, user2, user3 }
-- local isFamous = R.pathEq({'address', 'zipCode'}, 90210)
-- print(R.equals(user1, R.filter(isFamous, users)[1])) -- => true

-- print(R.toString(R.pluck('a')({{a = 1}, {a = 2}}))) -- => [1, 2]
-- print(R.toString(R.pluck(1)({{1, 2}, {3, 4}})))   -- => [1, 3]
-- print(R.toString(R.pluck('val', {a = {val = 3}, b = {val = 5}}))) -- => {'a':3, 'b':5}

-- print(R.pathSatisfies(function(y) return y > 0 end, {'x', 'y'}, {x = {y = 2}}))

-- print(R.toString(R.pick({'a', 'd'}, {a = 1, b = 2, c = 3, d = 4}))) -- => {a: 1, d: 4}
-- print(R.toString(R.pick({'a', 'e', 'f'}, {a = 1, b = 2, c = 3, d = 4}))) -- => {a: 1}

-- local isUpperCase = function(val, key) return R.toUpper(key) == key end
-- print(R.toString(R.pickBy(isUpperCase, {a = 1, b = 2, A = 3, B = 4}))) -- => {A: 3, B: 4}

-- local alice = {
-- 	name =  'ALICE',
-- 	age =  101
-- }
-- local favorite = R.prop('favoriteLibrary')
-- local favoriteWithDefault = R.propOr('Lamda', 'favoriteLibrary')
-- print(favorite(alice))  -- => nil
-- print(favoriteWithDefault(alice))  -- => 'Lamda'

-- print(R.propSatisfies(R.gt(R.__, 0), 'x', {x = 1, y = 2}))
-- print(R.toString(R.props({'x', 'y'}, {x = 1, y = 2}))) -- => [1, 2]
-- print(R.toString(R.props({'c', 'a', 'b'}, {b = 2, a = 1}))) -- => [nil, 1, 2]

-- print(R.reduce(R.subtract, 0, {1, 2, 3, 4}))
-- print(R.reduceRight(R.subtract, 0, {1, 2, 3, 4}))

local reduceToNamesBy = R.reduceBy(function(acc, student) return R.concat(acc, {student.name}) end, {})
local namesByGrade = reduceToNamesBy(function(student)
	local score = student.score
	return score < 65 and 'F' or
			score < 70 and 'D' or
			score < 80 and 'C' or
			score < 90 and 'B' or 'A'
end)
local students = {{name =  'Lucy', score = 92},
				{name =  'Drew', score = 85},
				-- ...
				{name =  'Bart', score = 62}}
print(R.toString(namesByGrade(students)))


-- local classyGreeting = function(name) return "The name's " .. name.last .. ", " .. name.first end
-- local yellGreeting = R.o(R.toUpper, classyGreeting)
-- print(yellGreeting({first = 'James', last = 'Bond'}))

-- local multiply2 = function(a, b) return a * b end
-- local double = R.partial(multiply2, 2)
-- print(double(2)) -- => 4
-- local greet = function(salutation, title, firstName, lastName) return salutation .. ', ' .. title .. ' ' .. firstName .. ' ' .. lastName .. '!' end
-- local sayHello = R.partial(greet, 'Hello')
-- local sayHelloToMs = R.partial(sayHello, 'Ms.')
-- print(sayHelloToMs('Jane', 'Jones')) -- => 'Hello, Ms. Jane Jones!'

--print(R.toString(R.pick({'a', 'd'}, {a = 1, b = 2, c = 3, d = 4})))

--print(R.toString(R.range(50,100)))

--print(R.toString(R.reduceRight(R.subtract, 0, {1, 2, 3, 4})))

--print(R.toString(R.remove(3, 3, {1,2,3,4,5,6,7,8})))

-- print(R.replace("you", "me", "fuckyou fuckyou"))
-- print(R.replaceAll("you", "me", "fuckyou fuckyou"))

--print(R.toString(R.reverse("12,34")))

--print(R.toString(R.scan(R.multiply, 1, {1,2,3,4})))

-- print(R.toString(R.sort(function(a,b) 
-- 	return a.x < b.x 
-- end, {{x = 1}, {x = 5}, {x = 3}, {x = 6}})))

--print(R.toString(R.splitEvery(2,"hello fuck you")))
--print(R.toString(R.splitWhen(R.equals(2), {1, 2, 3, 1, 2, 3})))

--print(R.toString(R.slice(-5,-2, "hello fucker")))
--print(R.toString(R.tail("hello fucker")))
--print(R.toString(R.take(5, "hello fucker")))
--print(R.toString(R.takeWhile(function(v) return v ~= 3 end, {1, 2, 3, 4})))

--print(R.toString(R.times(R.identity, 5)))

-- print(R.toString(R.transpose({{10, 11}, {20}, {}, {30, 31, 32}})))
-- print(R.trim('   xyz  '))

--print(R.toString(R.tryCatch(R.prop('x'), R.F)(100)))

-- print(R.toString(R.uniqWith(function(v,w) 
-- 	return v == w
-- end)({1, '1', 2, 1})))

-- print(R.unless(R.is(R.STRING), R.inc)(1))

--print(R.toString(R.update(1, 11, {0, 1, 2})))
--print(R.useWith(math.pow, {R.identity, R.identity})(3, 4))

-- print(R.curryN(2,function(a,b) 
-- 	return a+b
-- end)(1,2)(1)(2)(3)(4)(5))

--print(R.toString(R.values({a=1,b=2,c=5})))

-- print(R.toString(R.xprod({1, 2}, {'a', 'b'})))
-- print(R.toString(R.zip({1, 2, 3}, {'a', 'b', 'c'})))

--print(R.toString(R.assocPath({'a', 'b', 'c'}, 42, {a= {b= {c= 0}}})))
--print(R.toString(R.dissocPath({'a', 'b', 'c'}, {a= {b= {c= 42}}})))

-- local isEven = function(v)
-- 	return v % 2 == 0
-- end
-- print(R.toString(R.filter(isEven, {1,2,3,4,5})))
-- print(R.toString(R.filter(isEven, {a = 1, b = 2, c = 3, d = 4, e = 5})))

-- local xs = {{a = 1}, {a = 2}, {a = 3}}
-- print(R.toString(R.find(R.propEq('a', 2))(xs))) -- => {a = 2}
-- print(R.toString(R.find(R.propEq('a', 4))(xs))) -- => nil
-- print(R.findIndex(R.propEq('a', 2))(xs)) -- => 2
-- print(R.findIndex(R.propEq('a', 4))(xs)) -- => -1

-- local mergeThree = function(a, b, c) return a .. b .. c end
-- print(R.toString(mergeThree('1', '2', '3'))) -- => {1, 2, 3}
-- print(R.toString(R.flip(mergeThree)('1', '2', '3'))) -- => {2, 1, 3}

-- print(R.toString(R.groupWith(R.equals, {0, 1, 1, 2, 3, 5, 8, 13, 21})))
-- -- => {{0}, {1, 1}, {2}, {3}, {5}, {8}, {13}, {21}}
-- print(R.toString(R.groupWith(function(a, b) return a + 1 == b end, {0, 1, 1, 2, 3, 5, 8, 13, 21})))
-- -- => {{0, 1}, {1, 2, 3}, {5}, {8}, {13}, {21}}
-- print(R.toString(R.groupWith(function(a, b) return a % 2 == b % 2 end, {0, 1, 1, 2, 3, 5, 8, 13, 21})))
-- -- => {{0}, {1, 1}, {2}, {3, 5}, {8}, {13, 21}}
-- print(R.toString(R.groupWith(R.eqBy(R.contains(R.__, "aeiou")), 'aestiou')))
-- -- => {'ae', 'st', 'iou'}

local trans = R.o(R.map(R.unary(tonumber)), R.split("."))
local transIp = R.o(R.reduce(function(v,w) return v*256+w end, 0), trans)
print(transIp("192.168.100.111"))


-- local incCount = R.ifElse(
-- 	R.has('count'),
-- 	R.assoc('count', 'null'),
-- 	R.assoc('count', 1)
-- )
-- print(R.toString(incCount({})))           -- => { count: 1 }
-- print(R.toString(incCount({ count = 1 }))) -- => { count: 'null' }

-- print(R.toString(R.innerJoin(
--             function(data, id) return data.id == id end,
--             {{id = 824, name = 'Richie Furay'},
--              {id = 956, name = 'Dewey Martin'},
--              {id = 313, name = 'Bruce Palmer'},
--              {id = 456, name = 'Stephen Stills'},
--              {id = 177, name = 'Neil Young'}},
--             {177, 456, 999}
--           )))

-- local buffaloSpringfield = {
-- 	{id = 824, name =  'Richie Furay'},
-- 	{id = 956, name =  'Dewey Martin'},
-- 	{id = 313, name =  'Bruce Palmer'},
-- 	{id = 456, name =  'Stephen Stills'},
-- 	{id = 177, name =  'Neil Young'}
-- }
-- local csny = {
-- 	{id = 204, name =  'David Crosby'},
-- 	{id = 456, name =  'Stephen Stills'},
-- 	{id = 539, name =  'Graham Nash'},
-- 	{id = 177, name =  'Neil Young'}
-- }
-- print(R.toString(R.intersectionWith(R.eqBy(R.prop('id')), buffaloSpringfield, csny)))

local raceResultsByFirstName = {
	first = 'alice',
	second = 'jake',
	third = 'alice',
}
print(R.toString(R.invert(raceResultsByFirstName)))

--print(R.toString(R.keys({a = 1, b = 2, c = 3, d = 4, e = 5})))

--print(R.toString(R.invert({a = 'x', b = 'y', c = 'x'})))

--print(R.isEmpty(nil))

--print(R.toString(R.last({1,2,3,4})))

--print(R.toString(R.pluck('val', {a= {val= 3}, b= {val= 5}})))
--print(R.toString(R.pluck('a')({{a= 1}, {a= 2}})))

--print(R.toString(R.repeat_({}, 5)))

-- print(R.toString(R.startsWith({'a','c'}, {'a', 'b', 'c'})))
-- print(R.toString(R.startsWith("abce", "abcde")))

-- print(R.sum({2,4,6,8,100,1}))

-- print(R.toString(R.takeLast(1, {'foo', 'bar', 'baz'}))) --=> ['baz']
-- print(R.toString(R.takeLast(2, {'foo', 'bar', 'baz'}))) --=> ['bar', 'baz']
-- print(R.toString(R.takeLast(3, {'foo', 'bar', 'baz'}))) --=> ['foo', 'bar', 'baz']
-- print(R.toString(R.takeLast(4, {'foo', 'bar', 'baz'}))) --=> ['foo', 'bar', 'baz']
-- print(R.toString(R.takeLast(3, 'ramda')))               --=> 'mda'

-- local avg = R.converge(R.divide, {R.sum, R.length})
-- print(avg({1,2,3,4,5}))

-- print(R.toString(R.dropRepeatsWith(R.equals, {1,1,1,2,3,3,4,5,5,5})))

-- print(R.endsWith({'c'}, {'a', 'b', 'c'}))

-- print(R.indexOf(3, {1,2,3,4}))

-- local jt = R.juxt({math.min, math.max})
-- print(R.toString(jt(1,-2,3,4,5,-6)))

-- print(R.median({7, 2, 10, 9}))

-- print(R.toString(R.partition(R.contains('s'), {'sss', 'ttt', 'foo', 'bars'})))

-- local f = R.pipe(math.pow, R.negate, R.inc)
-- print(f(3,4))

-- local f = R.curryN(4, function(a,b,c,d)
-- 	return a+b+c+d
-- end)
-- local x = f(1)(2)(3)(4)
-- print(x)

-- print(R.toString(R.without({1, 2}, {1, 2, 1, 3, 4})))
-- -- local f = R.contains(R.__, {1,2})
-- -- print(f(1),f(2),f(3))

-- local isNotNil = R.complement(R.isNil)
-- print(isNotNil(nil), isNotNil(1))

-- print(R.toString(R.join("|", {1,2,3})))
-- local splitToInt = R.pipe(R.split("|"), R.map(tonumber))
-- print(R.toString(splitToInt("1|2|3")))

-- print(R.toString(R.symmetricDifference({7,6,5,4,3}, {1,2,3,4})))

--print(R.toString(R.uniqBy(math.abs, {-1, -5, 2, 10, 1, 2})))
--print(R.toString(R.intersection({1,2,3,4}, {7,6,5,4,3})))
--print(R.toString(R.union({1,2,3,4}, {7,6,5,4,3})))

-- print(R.toString(R.difference({1,2,3,4}, {7,6,5,4,3}))) -- => {1,2}
-- print(R.toString(R.difference({7,6,5,4,3}, {1,2,3,4}))) -- => {7,6,5}
-- print(R.toString(R.difference({{a = 1}, {b = 2}}, {{a = 1}, {c = 3}}))) -- => {{b = 2}}

print(R.take(4)("helololo"))