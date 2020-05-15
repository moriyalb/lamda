# Lamda 

A practical functional library for lua programmers.   
Ported from the JavaScript version https://github.com/ramda/ramda

[![Build Status](https://travis-ci.org/moriyalb/lamda.svg?branch=master)](https://travis-ci.org/moriyalb/lamda)
[![unstable](http://badges.github.io/stability-badges/dist/stable.svg)](http://github.com/badges/stability-badges)

[![Badge](https://img.shields.io/badge/link-996.icu-%23FF4D5B.svg?style=flat-square)](https://996.icu/#/en_US)
[![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg?style=flat-square)](https://github.com/996icu/996.ICU/blob/master/LICENSE)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)

# Install

### From Github
```
    git clone https://github.com/moriyalb/lamda.git
```

### From Luarocks
```
    sudo luarocks install --server=http://luarocks.org/manifests/moriyalb lamda
```

# Usage

```lua
    local R = require("lamda")
    local sayHello = R.compose(R.join(" "), R.map(R.pipe(R.toUpper, R.trim, R.take(3))), R.split(","))
    R.call(print, sayHello("Hello, Lamda!"))
```

# API

see https://moriyalb.github.io/lamda/

# Test

I use luaunit to test all functions.  
you can test the lamda function simple like
```
    lua run_test_all.lua -v
```

# Features

1. Immutable  
    * All functions is immutable without side effect. 
2. Functional  
    * You can write lua code in functional style. 	
3. Auto curried  
    * Most function is auto curried. Placeholder is also supported.

# Ramda Version

* Based on ramda@0.24.1
	
# Notice

1. `nil` is the very annoy params in lua because it not only `none` value but also `absent` argument. 
	we can not tell the difference, so if we curry the method, the nil args is rejected to send or the method 
 	will return a `curried` function as a invalid result.
 	
2. string type is treated as the array table.(in most function , but maybe expcetions)

3. transducer / lens / transformer is not supported now.

4. all sort method is none-stable.( we use the default lua table.sort method)

5. this lib support awesome functional usage in lua programming but may also comes with a performance price. 
	make sure the tick/update method don't use much more of this lib.
