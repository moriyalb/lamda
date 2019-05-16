Lamda 
https://github.com/moriyalb/lamda
=============

A practical functional library for lua programmers. 

Ported from the JavaScript version https://github.com/ramda/ramda

Core features:

1. Immutable 
	All method is immutable function without side effect. placeholder is supported ( R.__ )
	
2. Auto curried.

3. Functional support
	we got the R.piple/R.compose/R.o methods to make new fucntions.
	
Notice:

1. `nil` is the very annoy params in lua because it not only a `none` value but also a `absent` method args. 
	we can not tell the difference, so if we curry the method, the nil args is rejected to send or the method 
 	will return a `curried` function as a invalid result.
 	
2. string type is treated as the array table.(in most function , but maybe expcetions)

3. transducer / lens / transformer is not supported now.

4. all sort method is none-stable.( we use the default lua table.sort method)

5. this lib support awesome functional usage in lua programming but may also comes with a performance price. 
	make sure the tick/update method don't use much more of this lib.
	
 
