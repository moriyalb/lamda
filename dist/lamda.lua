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
R.curry1 = _curry1

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

    -- /**
    --  * Optimized internal three-arity curry function.
    --  *
    --  * @private
    --  * @category Function
    --  * @param {Function} fn The function to curry.
    --  * @return {Function} The curried function.
    --  */
    -- var _curry3 = function _curry3(fn) {
    --     return function f3(a, b, c) {
    --         switch (arguments.length) {
    --         case 0:
    --             return f3;
    --         case 1:
    --             return _isPlaceholder(a) ? f3 : _curry2(function (_b, _c) {
    --                 return fn(a, _b, _c);
    --             });
    --         case 2:
    --             return _isPlaceholder(a) && _isPlaceholder(b) ? f3 : _isPlaceholder(a) ? _curry2(function (_a, _c) {
    --                 return fn(_a, b, _c);
    --             }) : _isPlaceholder(b) ? _curry2(function (_b, _c) {
    --                 return fn(a, _b, _c);
    --             }) : _curry1(function (_c) {
    --                 return fn(a, b, _c);
    --             });
    --         default:
    --             return _isPlaceholder(a) && _isPlaceholder(b) && _isPlaceholder(c) ? f3 : _isPlaceholder(a) && _isPlaceholder(b) ? _curry2(function (_a, _b) {
    --                 return fn(_a, _b, c);
    --             }) : _isPlaceholder(a) && _isPlaceholder(c) ? _curry2(function (_a, _c) {
    --                 return fn(_a, b, _c);
    --             }) : _isPlaceholder(b) && _isPlaceholder(c) ? _curry2(function (_b, _c) {
    --                 return fn(a, _b, _c);
    --             }) : _isPlaceholder(a) ? _curry1(function (_a) {
    --                 return fn(_a, b, c);
    --             }) : _isPlaceholder(b) ? _curry1(function (_b) {
    --                 return fn(a, _b, c);
    --             }) : _isPlaceholder(c) ? _curry1(function (_c) {
    --                 return fn(a, b, _c);
    --             }) : fn(a, b, c);
    --         }
    --     };
    -- };

    -- /**
    --  * Internal curryN function.
    --  *
    --  * @private
    --  * @category Function
    --  * @param {Number} length The arity of the curried function.
    --  * @param {Array} received An array of arguments received thus far.
    --  * @param {Function} fn The function to curry.
    --  * @return {Function} The curried function.
    --  */
    -- var _curryN = function _curryN(length, received, fn) {
    --     return function () {
    --         var combined = [];
    --         var argsIdx = 0;
    --         var left = length;
    --         var combinedIdx = 0;
    --         while (combinedIdx < received.length || argsIdx < arguments.length) {
    --             var result;
    --             if (combinedIdx < received.length && (!_isPlaceholder(received[combinedIdx]) || argsIdx >= arguments.length)) {
    --                 result = received[combinedIdx];
    --             } else {
    --                 result = arguments[argsIdx];
    --                 argsIdx += 1;
    --             }
    --             combined[combinedIdx] = result;
    --             if (!_isPlaceholder(result)) {
    --                 left -= 1;
    --             }
    --             combinedIdx += 1;
    --         }
    --         return left <= 0 ? fn.apply(this, combined) : _arity(left, _curryN(length, combined, fn));
    --     };
    -- };

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
	*      R.add(2, 3);       //=>  5
	*      R.add(7)(10);      //=> 17
]]
R.add = _curry2(function (a, b)
	return a + b
end)

return R