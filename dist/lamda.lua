local R = {}

R.__ = { ['@@functional/placeholder'] = true }

local _isPlaceholder = function(a)
    return a ~= nil and type(a) == 'table' and a['@@functional/placeholder']
end

--[[
	* Optimized internal one-arity curry function.
	*
	* @private
	* @category Function
	* @param {Function} fn The function to curry.
	* @return {Function} The curried function.
]]
local _curry1 = function(fn)
	function f1(...)
		local args = {...}
		if #args == 0 or _isPlaceholder(args[1]) then
			return f1
		else
			return fn(unpack(args))
		end
	end
	return f1
end
R._curry1 = _curry1

--[[
	* Optimized internal two-arity curry function.
	*
	* @private
	* @category Function
	* @param {Function} fn The function to curry.
	* @return {Function} The curried function.
]]
local _curry2 = function(fn)
	function f2(...)
		local args = {...}
		if #args == 0 then
			return f2
		elseif #args == 1 then
			return _isPlaceholder(args[1]) and f2 or _curry1(function(_b)
				return fn(args[1], _b)
			end)
		else
			return (_isPlaceholder(args[1]) and _isPlaceholder(args[2])) and f2 or (_isPlaceholder(args[1]) and _curry1(function (_a)
			 		return fn(_a, args[2])
			end) or (_isPlaceholder(args[2]) and _curry1(function (_b)
					return fn(args[1], _b)
			end) or fn(args[1], args[2])))
		end
	end
	return f2
end

--[[
	* Optimized internal three-arity curry function.
	*
	* @private
	* @category Function
	* @param {Function} fn The function to curry.
	* @return {Function} The curried function.
]]
local _curry3 = function(fn)
	local f3 = function(...)
		local args = {...}
		local a, b, c = unpack(args)
		if #args == 0 then
			return f3
		elseif #args == 1 then
			return _isPlaceholder(a) and f3 or _curry2(function (_b, _c)
				return fn(a, _b, _c)
			end)
		elseif #args == 2 then
			return (_isPlaceholder(a) and _isPlaceholder(b)) and f3 or (_isPlaceholder(a) and _curry2(function (_a, _c)
				return fn(_a, b, _c)
			end) or (_isPlaceholder(b) and _curry2(function (_b, _c)
				return fn(a, _b, _c)
			end) or _curry1(function (_c)
				return fn(a, b, _c)
			end)))
		else
			if _isPlaceholder(a) and _isPlaceholder(b) and _isPlaceholder(c) then
				return f3
			elseif _isPlaceholder(a) and _isPlaceholder(b) then
				return _curry2(function (_a, _b)
					return fn(_a, _b, c)
				end)
			elseif _isPlaceholder(a) and _isPlaceholder(c) then
				return  _curry2(function (_a, _c)
					return fn(_a, b, _c);
				end)
			elseif _isPlaceholder(b) and _isPlaceholder(c) then
				return  _curry2(function (_b, _c)
					return fn(a, _b, _c)
				end)
			elseif _isPlaceholder(a)  then
				return _curry1(function (_a)
					return fn(_a, b, c)
				end)
			elseif _isPlaceholder(b) then
				return _curry1(function (_b)
					return fn(a, _b, c)
				end)
			elseif _isPlaceholder(c) then
				return _curry1(function (_c)				
					return fn(a, b, _c)
				end)
			else
				return fn(a, b, c)
			end
		end
	end
	return f3
end

local _arity = function(n, fn)
	if n == 0 then
		return function (...)
			return fn(...)
		end
	elseif n == 1 then
		return function (a0, ...)
			return fn(...)
		end
	elseif n == 2 then
		return function (a0, a1, ...)
			return fn(...)
		end
	elseif n == 3 then
		return function (a0, a1, a2, ...)
			return fn(...)
		end
	elseif n == 4 then
		return function (a0, a1, a2, a3, ...)
			return fn(...)
		end
	elseif n == 5 then
		return function (a0, a1, a2, a3, a4, ...)
			return fn(...)
		end
	elseif n == 6 then
		return function (a0, a1, a2, a3, a4, a5, ...)
			return fn(...)
		end
	elseif n == 7 then
		return function (a0, a1, a2, a3, a4, a5, a6, ...)
			return fn(...)
		end
	elseif n == 8 then
		return function (a0, a1, a2, a3, a4, a5, a6, a7, ...)
			return fn(...)
		end
	elseif n == 9 then
		return function (a0, a1, a2, a3, a4, a5, a6, a7, a8, ...)
			return fn(...)
		end
	elseif n == 10 then
		return function (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, ...)
			return fn(...)
		end
	else
		error('First argument to _arity must be a non-negative integer no greater than ten')
	end
end

--[[
	* Internal curryN function.
	*
	* @private
	* @category Function
	* @param {Number} length The arity of the curried function.
	* @param {Array} received An array of arguments received thus far.
	* @param {Function} fn The function to curry.
	* @return {Function} The curried function.
]]
local _curryN
_curryN = function(length, received, fn)
	return function(...)
		local combined = {}
		local argsIdx = 1
		local left = length
		local combinedIdx = 1
		local args = {...}
		while combinedIdx <= #received or argsIdx < #args do
			local result
			if (combinedIdx <= #received and (not _isPlaceholder(received[combinedIdx]) or argsIdx >= #args)) then
				result = received[combinedIdx]
			else
				result = args[argsIdx]
				argsIdx = argsIdx + 1
			end
			combined[combinedIdx] = result
			if not _isPlaceholder(result) then
				left = left - 1
			end
			combinedIdx = combinedIdx + 1
		end
		return left <= 0 and fn(unpack(combined)) or _arity(left, _curryN(length, combined, fn))
	end
end
R._curryN = _curryN

--[[
     * Private `concat` function to merge two array-like objects.
     *
     * @private
     * @param {Array} {set1={}} An array-like object.
     * @param {Array} {set2={}} An array-like object.
     * @return {Array} A new, merged array.
     * @example
     *
     *      _concat({4, 5, 6}, {1, 2, 3}) -- => {4, 5, 6, 1, 2, 3}
]]
local _concat = function(set1, set2)
	set1 = set1 or {}
	set2 = set2 or {}
	local len1 = #set1
	local len2 = #set2
	local result = {}
	local idx = 1
	while idx <= len1 do
		result[#result + 1] = set1[idx]
		idx = idx + 1
	end
	idx = 1
	while idx < len2 do
		result[#result + 1] = set2[idx]
		idx = idx + 1
	end
	return result
end

--[[
     * Returns a function that dispatches with different strategies based on the
     * object in list position (last argument). If it is an array, executes [fn].
     * Otherwise, if it has a function with one of the given method names, it will
     * execute that function (functor case). Otherwise, if it is a transformer,
     * uses transducer [xf] to return a new transformer (transducer case).
     * Otherwise, it will default to executing [fn].
     *
     * @private
     * @param {Array} methodNames properties to check for a custom implementation
     * @param {Function} xf transducer to initialize if object is transformer
     * @param {Function} fn default ramda implementation
     * @return {Function} A function that dispatches on object in list position
]]
local _dispatchable = function(methodNames, xf, fn)
	return function (...)
		local args = {...}
		if (#args == 0) then
			return fn()
		end
		var obj = args.pop();
		if (!_isArray(obj)) {
			var idx = 0;
			while (idx < methodNames.length) {
				if (typeof obj[methodNames[idx]] === 'function') {
					return obj[methodNames[idx]].apply(obj, args);
				}
				idx += 1;
			}
			if (_isTransformer(obj)) {
				var transducer = xf.apply(null, args);
				return transducer(obj);
			}
		}
		return fn.apply(this, arguments);
	end
end

--[[
     * Returns a function that always returns the given value. Note that for
     * non-primitives the value returned is a reference to the original value.
     *
     * This function is known as `const`, `constant`, or `K` (for K combinator) in
     * other languages and libraries.
     *
     * @func
     * @memberOf R
     * @category Function
     * @sig a -> (* -> a)
     * @param {*} val The value to wrap in a function
     * @return {Function} A Function :: * -> val.
     * @example
     *
     *      local t = R.always('Tee')
     *      t() -- => 'Tee'
]]
R.always = _curry1(function(val)
	return function()
		return val
	end
end)


--[[
     * A function that always returns `false`. Any passed in parameters are ignored.
     *
     * @func
     * @memberOf R
     * @category Function
     * @sig * -> Boolean
     * @param {*}
     * @return {Boolean}
     * @see R.always, R.T
     * @example
     *
     *      R.F()  -- => false
]]
R.F = R.always(false)

--[[
     * A function that always returns `true`. Any passed in parameters are ignored.
     *
     * @func
     * @memberOf R
     * @since v0.9.0
     * @category Function
     * @sig * -> Boolean
     * @param {*}
     * @return {Boolean}
     * @see R.always, R.F
     * @example
     *
     *      R.T()  -- => true
]]
R.T = R.always(true)

--[[
	* Adds two values.
	*
	* @func
	* @memberOf R
	* @sig number -> number -> number
	* @param {number} a
	* @param {number} b
	* @return {number}
	* @see R.subtract
	* @example
	*
	*      R.add(2, 3)       -- =>  5
	*      R.add(7)(10)      -- => 17
]]
R.add = _curry2(function (a, b)
	return a + b
end)

--[[
     * Creates a new list iteration function from an existing one by adding two new
     * parameters to its callback function: the current index, and the entire list.
     *
     * This would turn, for instance, [`R.map`](#map) function into one that
     * more closely resembles `Array.prototype.map`. Note that this will only work
     * for functions in which the iteration callback function is the first
     * parameter, and where the list is the last parameter. (This latter might be
     * unimportant if the list parameter is not used.)
     *
     * @func
     * @memberOf R
     * @category Function
     * @category List
     * @sig ((a ... -> b) ... -> [a] -> *) -> (a ..., Int, [a] -> b) ... -> [a] -> *)
     * @param {Function} fn A list iteration function that does not pass index or list to its callback
     * @return {Function} An altered list iteration function that passes (item, index, list) to its callback
     * @example
     *
     *      var mapIndexed = R.addIndex(R.map);
     *      mapIndexed((val, idx) => idx + '-' + val, ['f', 'o', 'o', 'b', 'a', 'r']);
     *      //=> ['0-f', '1-o', '2-o', '3-b', '4-a', '5-r']
]]
-- R.addIndex = _curry1(function addIndex(fn) {
--         return curryN(fn.length, function () {
--             var idx = 0;
--             var origFn = arguments[0];
--             var list = arguments[arguments.length - 1];
--             var args = Array.prototype.slice.call(arguments, 0);
--             args[0] = function () {
--                 var result = origFn.apply(this, _concat(arguments, [
--                     idx,
--                     list
--                 ]));
--                 idx += 1;
--                 return result;
--             };
--             return fn.apply(this, args);
--         });
--     });


--[[
     * Applies a function to the value at the given index of an array, returning a
     * new copy of the array with the element at the given index replaced with the
     * result of the function application.
     *
     * @func
     * @memberOf R
     * @since v0.14.0
     * @category List
     * @sig (a -> a) -> Number -> [a] -> [a]
     * @param {Function} fn The function to apply.
     * @param {Number} idx The index.
     * @param {Array|Arguments} list An array-like object whose value
     *        at the supplied index will be replaced.
     * @return {Array} A copy of the supplied array-like object with
     *         the element at index `idx` replaced with the value
     *         returned by applying `fn` to the existing element.
     * @see R.update
     * @example
     *
     *      R.adjust(R.add(10), 2, {1, 2, 3})     //=> {1, 12, 3}
     *      R.adjust(R.add(10))(2)({1, 2, 3})     //=> {1, 12, 3}
     * @symb R.adjust(f, -1, {a, b}) = {a, f(b)}
     * @symb R.adjust(f, 0, {a, b}) = {a, b}
	 * @symb R.adjust(f, 1, {a, b}) = {f(a), b}
]]
R.adjust = _curry3(function (fn, idx, list)
	if (idx == 0 or idx > #list or idx < -#list) then
		return list
	end
	local start = idx < 0 and #list + 1 or 0
	local _idx = start + idx
	local _list = _concat(list)
	_list[_idx] = fn(list[_idx])
	return _list
end)

--[[
     * Returns `true` if all elements of the list match the predicate, `false` if
     * there are any that don't.
     *
     * Dispatches to the `all` method of the second argument, if present.
     *
     * Acts as a transducer if a transformer is given in list position.
     *
     * @func
     * @memberOf R
     * @since v0.1.0
     * @category List
     * @sig (a -> Boolean) -> [a] -> Boolean
     * @param {Function} fn The predicate function.
     * @param {Array} list The array to consider.
     * @return {Boolean} `true` if the predicate is satisfied by every element, `false`
     *         otherwise.
     * @see R.any, R.none, R.transduce
     * @example
     *
     *      local equals3 = R.equals(3)
     *      R.all(equals3)({3, 3, 3, 3}) -- => true
     *      R.all(equals3)({3, 3, 1, 3}) -- => false
]]
R.all = _curry2(_dispatchable(['all'], _xall, function(fn, list)
        var idx = 0;
        while (idx < list.length) {
            if (!fn(list[idx])) {
                return false;
            }
            idx += 1;
        }
        return true;
end))

return R