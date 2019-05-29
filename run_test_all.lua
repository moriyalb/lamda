local lu = require('lib.luaunit')

require("test.array").lu = lu
require("test.util").lu = lu
require("test.functional").lu = lu
require("test.math").lu = lu
require("test.object").lu = lu

os.exit(lu.LuaUnit.run())
