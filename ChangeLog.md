# version 0.2.0

## Unit Test
* add luaunit test for all exported function

## Error Msg
* format all error message like `<lamda_error> $method_name:: $error_msg`

## Modified
* array table and hash table
	* a table will be an array exactly with `#size` equals `R.size`
	* `{1,2,nil,4}` will treated as hash map
* R.size/R.length
	* return the really size (without nil value)
* R.clamp
	* will always returns the clamped value(auto swap the (min, max))
* type utils
	* add R.NAN/R.INF/R.OBJECT
	* remove R.MAP/R.NULL
	* new methods (all curried)    
		* R.isInf
		* R.isNan
		* R.isInteger
		* R.isNumber
		* R.isString
		* R.isArray
		* R.isObject
		* R.isTable
		* R.isFunction
		* R.isUserData   
		* R.isBoolean 
	* new methods (all not curried, which can check nil value)
		* R.isNil
		* R.isNull
		* R.isSafeInf
		* R.isSafeNan
		* R.isSafeInteger
		* R.isSafeNumber
		* R.isSafeString
		* R.isSafeArray
		* R.isSafeObject
		* R.isSafeTable
		* R.isSafeFunction
		* R.isSafeUserData  
		* R.isSafeBoolean  
	* R.is method do not check any class inheritance relationship. It's just a alias method to those `is*` methods
	* set `R.is` to non-curry function. now it's can detect `nil` value

* R.keys/R.values
	* accept table value and return as an array (ignore all nil values)
	* R.keys is not sorted
* R.sortedKeys added
* R.safeEqual added
	* can compare `nil` value
* R.abs added
	* string turn to nil
* R.find & R.findLast & R.findIndex & R.findLastIndex
	* now can find by value if the given `pred` is not a function
* R.forEach
	* now take object argument
	* the traverse function take `value` and `key` now
* R.sample
	* remove `shuffle` config, the result is not guarantee whether shuffled or not
* R.randrange
	* exchange `from` and `to` if `from` is bigger than `to`
* R.concat
	* remove the string check. you can connect whatever you want but to handle the error yourself.
* R.modulo
	* rename to `R.mod`
* R.propSatisfies & R.propEq
	* fix `nil` prop bug

## Bug Fixed
* curry function
	* now will taken more arguments
```lua	
	local f = R.curry2(function(a,b,c)
		return a..b..c
	end)
	f(1)(2)(3) --> error
	f(1)(2, 3) --> 123
```

* unpack bug
	* from lua5.2, the `unpack` function must be called as `table.unpack` 

* R.ascend & R.decend is transposed
* R.curry3 return `nil` when no arguments is passed in
* R.isEmpty will check `nan` and `inf` value
* R.slice
	* toIndex is exlusive now.
	* toIndex 0 means slice to the end.
* R.take 
	* return default empty value now
* R.drop & R.dropLast & R.dropLastWhile & R.dropWhile
	* will work now
	* return default empty value now
* R.invert & R.invertObj
	* fix bug if object value is passed in.
	* key now is keep the origin type(not string)
* R.map
	* add key in the map tranverse function for array type
	* object type will return an array.(the value sequence is not guaranteed)
	> notice: it's different with ramda::map function which return object value when it takes object argument
* R.nth & R.head & R.tail
	* support string value now
* R.omit
* R.path
	* fixed bug when input path is array index.
	* support string now.
	```lua
		R.path({'a', 'b', 1, 2}, {a = {b = {"hello"}}}) --> 'e'
	```
* R.reduceBy
* R.countBy

## Removed
* R.containsNoCurry
* R.dictKeys
	* use R.keys
* R.valuesObj
	* use R.values
* R.dropRepeatsWith & R.dropRepeats
* R.forEachObjIndexed
	* use R.forEach
* R.intersectionWith 
	* see [issue](https://github.com/ramda/ramda/pull/1868)
* R.joinNoCurry
* R.mapObject
	* change to private function
* R.mathMod
* R.over

## Issues
* `nil` argument
	* as the last argument, that seems like you never pass it. 
	* as other argument, we can really got it. 
	```lua
			local r = R.add(nil, 1) -- error
			local f = R.add(1, nil) -- f is a curried function.
	```

* R.differenceWith
	* pred will check the first list, check this code. It's seems got some `unique` effect to the first list.
	* you can check this [issue](https://github.com/ramda/ramda/issues/2838)
	```lua
		local cmp = function(a, b) return a%2 == b%2 end
		R.differenceWith(cmp, {1,2,3,4}, {5,7}) --> {2} instead of {2,4} ? is that right ?
	```