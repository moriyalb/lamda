package = "lamda"
version = "0.2.0-6"
source = {
   url = "git+https://github.com/moriyalb/lamda.git",
   branch = "master"
}
description = {
   summary = "A practical functional library for lua programmers.",
   detailed = [[
		A practical functional library for lua programmers.   
		Ported from the JavaScript version https://github.com/ramda/ramda]],
   homepage = "https://github.com/moriyalb/lamda",
   license = "MIT <http://opensource.org/licenses/MIT>"
}
dependencies = {
   "lua >= 5.1", "lua < 5.4"
}
build = {
	type = "builtin",
	modules = {
		["lamda"] = "dist/lamda.lua"
	}
}
