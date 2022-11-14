import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;

class Test {
	static function main() {
		var l1 = new FunkinLua("script.lua");
		var l2 = new FunkinLua("cool/script.lua");
	}
}