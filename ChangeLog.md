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


## Removed
* R.containsNoCurry
* R.dictKeys
* R.valuesObj
* R.empty
* R.dropRepeatsWith & R.dropRepeats
* R.forEachObjIndexed

## Issues
* R.differenceWith
  * pred will check the first list, check this code. It's seems got some `unique` effect to the first list.
  * you can check this [issue](https://github.com/ramda/ramda/issues/2838)
```lua
	local cmp = function(a, b) return a%2 == b%2 end
	R.differenceWith(cmp, {1,2,3,4}, {5,7}) --> {2} instead of {2,4} ? is that right ?
```