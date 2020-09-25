
# version 0.4.0

## Notable Changes
* APIs will match to the new ramda version(0.27.0).
* remove random seed settings.

## Modifies
  * R.adjust
    * exchange `fn` and `idx` param sequence.
  * R.allPass
    * change preds to list.
    * curried now.(but also, the result function is not curried.)
  * R.map
    * when the input list is `object` type table, the returns will be an object now.
  * R.append
    * remove `string` param support. use R.concat instead.
    * now this function act the same behavior as `prepend` function.
  * R.clamp
    * throw error now when min > max (matching the ramda behavior)
  * R.comparator
    * fix returns
  * R.mod & R.mathMod
    * change mod algorithm (now just like math.fmod)
    * add mathMod function
    * notice those difference please:
      * -17 % 3 --> 1
      * math.fmod(-17, 3) or R.mod(-17, 3) --> -2
      * R.mathMod(-17, 3) --> 1
      * -17 % -3 --> -2
      * math.fmod(-17, -3) or R.mod(-17, -3) --> -2
      * R.mathMod(-17, -3) --> nan
  * R.insert & R.insertAll
    * adjust the insert element index
  * R.isEmpty
    * `nil`, `inf`, `nan` will return false now
  * R.prop & R.propEq
    * take negate number for array path value now
    * notice that ramda version is different from lamda version
    * return nil instead of throw an error when input obj is not a real table
  * R.replace
    * remove count param
    * if you want replace all the replacement str, use `R.replaceAll` instead

## New Function Added
  * R.applySpec
  * R.applyTo
  * R.isOdd & R.isEven
    * lua treats `0` as truthy value, so that the simple trick for blow is now work (in any judgment conditions)
      * local isOdd = R.mod(R.__, 2)
  * R.N
    * a function always return nil
    * R.always can not do this because R.always(nil) will just return R.always as a function
  * R.evolve
  * R.hasPath
  * R.identical
  * R.invoker
  * R.move
  * R.nthArg
  * R.paths
  * R.isLowerCase & R.isUpperCase
  * R.replaceAll

## Bug Fixed


# version 0.2.1

## ## Bug Fixed
* R.assocPath
  * fix bug with passing an emtpy table
* R.size
  * fix bug by checking table size by iterating it

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
* R.same added
* R.replace
	* add replace count
	* notice this method is not like the js version because lua doesn't include really regex expression.
* R.tryCatch
	* result is a function now.
	* pass the arguments to tryer and catcher now.
* R.pickAll added
	* R.project is also work now.

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

* R.ascend & R.decend
	* fix transposed bug
	* return 0, -1 and 1 now
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
* R.groupBy
* R.reduceWhile
	* we don't really implement the `reduced` method to end a reduce action. 
	* we use a closure value to solve this problem.
	* [more info](https://ramdajs.com/docs/#reduced)

* R.split
	* remove string:gsub algorthim, it's donen't work for <code>R.split("xx")</code>
* R.splitEvery	
* R.splitWhen
	* support string now.
* R.takeLast & R.endsWith
* R.takeLastWhile & R.takeWhile
	* now support string.
* R.times
	* fix description
* R.toPairs
* R.unfold
* R.useWith
	* handle the addtional arguments as `R.identity` now
* R.append
	* support string now.
* R.where & R.whereEq

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
* R.replaceAll
* R.set
* R.sortBy
	* use R.sort(R.ascend(fn)) or R.sort(R.descend(fn)) instead now.
* R.view

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
	* ramda has fix this problem in 0.26. (I think I should keep the same behavior with current ramda version)
