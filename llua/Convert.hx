package llua;

import llua.State;
import haxe.DynamicAccess;

class Convert {
	public static var traceUnsupported:Bool = true;

	public static function toLua(l:State, val:Any):Bool {
		var vtype = Type.typeof(val);

		switch (vtype) {
			case Type.ValueType.TNull:
				Lua.pushnil(l);
			case Type.ValueType.TBool:
				Lua.pushboolean(l, val);
			case Type.ValueType.TInt:
				Lua.pushinteger(l, cast(val, Int));
			case Type.ValueType.TFloat:
				Lua.pushnumber(l, val);
			case Type.ValueType.TClass(String):
				Lua.pushstring(l, cast(val, String));
			case Type.ValueType.TClass(Array):
				arrayToLua(l, val);
			case Type.ValueType.TObject:
				objectToLua(l, val);
			default:
				if (traceUnsupported) trace("haxe value not supported\n" + val + " - " + vtype);
				return false;
		}

		return true;
	}

	public static function fromLua(l:State, v:Int):Any {
		var vtype = Lua.type(l, v);
		var ret:Any;

		switch(vtype) {
			case Lua.LUA_TNIL:
				ret = null;
			case Lua.LUA_TBOOLEAN:
				ret = Lua.toboolean(l, v);
			case Lua.LUA_TNUMBER:
				ret = Lua.tonumber(l, v);
			case Lua.LUA_TSTRING:
				ret = Lua.tostring(l, v);
			case Lua.LUA_TTABLE:
				ret = toHaxeObj(l, v);
			case Lua.LUA_TFUNCTION:
				ret = LuaL.ref(l, Lua.LUA_REGISTRYINDEX);
			/*
			case Lua.LUA_TUSERDATA:
				ret = LuaL.ref(l, Lua.LUA_REGISTRYINDEX);
				trace("userdata\n");
			case Lua.LUA_TLIGHTUSERDATA:
				ret = LuaL.ref(l, Lua.LUA_REGISTRYINDEX);
				trace("lightuserdata\n");
			case Lua.LUA_TTHREAD:
				ret = null;
				trace("thread\n");
			*/
			default:
				ret = null;
				if (traceUnsupported) trace("return value not supported\n" + vtype);
		}

		return ret;
	}

	public static inline function arrayToLua(l:State, arr:Array<Any>) {
		var size:Int = arr.length;
		Lua.createtable(l, size, 0);

		for (i in 0...size) {
			Lua.pushnumber(l, i + 1);
			toLua(l, arr[i]);
			Lua.settable(l, -3);
		}
	}

	static inline function objectToLua(l:State, res:Any) {
		var tLen = 0;

		for (n in Reflect.fields(res)) tLen++;

		Lua.createtable(l, tLen, 0);
		for (n in Reflect.fields(res)) {
			Lua.pushstring(l, n);
			toLua(l, Reflect.field(res, n));
			Lua.settable(l, -3);
		}
	}

	static function toHaxeObj(l, i:Int):Any {
		var count = 0;
		var array = true;

		Macro.loopTable(l, i, {
			if(array) {
				if(Lua.type(l, -2) != Lua.LUA_TNUMBER) array = false;
				else {
					var index = Lua.tonumber(l, -2);
					if(index < 0 || Std.int(index) != index) array = false;
				}
			}
			count++;
		});

		return
		if(count == 0) {
			{};
		} else if(array) {
			var v = [];
			Macro.loopTable(l, i, {
				var index = Std.int(Lua.tonumber(l, -2)) - 1;
				v[index] = fromLua(l, -1);
			});
			cast v;
		} else {
			var v:DynamicAccess<Any> = {};
			Macro.loopTable(l, i, {
				switch Lua.type(l, -2) {
					case t if(t == Lua.LUA_TSTRING): v.set(Lua.tostring(l, -2), fromLua(l, -1));
					case t if(t == Lua.LUA_TNUMBER):v.set(Std.string(Lua.tonumber(l, -2)), fromLua(l, -1));
				}
			});
			cast v;
		}
	}
}
