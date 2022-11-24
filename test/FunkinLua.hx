package;

#if LUA_ALLOWED
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end

using StringTools;

class FunkinLua {
	public static var Function_Stop:Int 	= 1;
	public static var Function_Continue:Int	= 0;
	public static var Function_StopLua:Int	= 2;

	public static var scriptFields:Map<String, FunkinLua> = [];

	#if LUA_ALLOWED
	public var lua:State = null;
	#end
	
	public var scriptName:String;

	public static function clear() {
		
	}

	public function new(script:String) {
		scriptFields[script] = this;
		scriptName = script;
		trace('loading:' + script);
		#if LUA_ALLOWED
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua_helper.init_callbacks(lua);
		//initCallbacks();

		initializeGlobal();

		Lua_helper.add_callback(lua, "duh", function(ref:Int):Any {
			trace("hello");
			Lua.rawgeti(lua, Lua.LUA_REGISTRYINDEX, ref);
			if (!Lua.isfunction(lua, -1)) return null;
			Lua.call(lua, 0, 1);
			LuaL.unref(lua, Lua.LUA_REGISTRYINDEX, ref);
			var r:Any = Convert.fromLua(lua, -1);
			Lua.pop(lua, 1);
			return r;
		});

		var status:Int = LuaL.dofile(lua, script);
		if (status != Lua.LUA_OK) {
			var error:String = getErrorMessage(status, 0);
			if (error == null) return stop();

			trace('Error on lua script! ' + error);

			//#if windows
			//lime.app.Application.current.window.alert(error, 'Error on lua script!');
			//#else
			//luaTrace('Error loading lua script: "$script"\n' + error, true, false, FlxColor.RED);
			//#end

			return stop();
		}

		trace('lua file loaded succesfully:' + script);
		call('onCreate', [1, 3, "uwu", "hewwo!!!", "nyanyanya", "what the fuck"]);
		#end
	}

	private function initializeGlobal() {
		#if LUA_ALLOWED
		// Lua shit
		set('Function_StopLua', Function_StopLua);
		set('Function_Stop', Function_Stop);
		set('Function_Continue', Function_Continue);
		set('luaDebugMode', false);
		set('luaDeprecatedWarnings', true);
		set('inChartEditor', false);
		set('scriptName', scriptName);

		#if windows
		set('buildTarget', 'windows');
		#elseif linux
		set('buildTarget', 'linux');
		#elseif mac
		set('buildTarget', 'mac');
		#elseif html5
		set('buildTarget', 'browser');
		#elseif android
		set('buildTarget', 'android');
		#else
		set('buildTarget', 'unknown');
		#end

		#end
	}

	var lastCalledFunction:String = '';
	public function call(func:String, args:Array<Any>):Dynamic {
		#if LUA_ALLOWED
		if (lua == null) return Function_Continue;
		lastCalledFunction = func;

		Lua.getglobal(lua, func);
		var type:Int = Lua.type(lua, -1);

		if (type != Lua.LUA_TFUNCTION) {
			if (type > Lua.LUA_TNIL)
				trace("ERROR ($func)): attempt to call a " + Lua.typename(lua, type) + " value as a callback");

			Lua.pop(lua, 1);
			return Function_Continue;
		}

		if (args != null) for (arg in args) Convert.toLua(lua, arg);
		var status:Int = Lua.pcall(lua, args.length, 1, 0);

		if (status != Lua.LUA_OK) {
			trace("ERROR ($func)): " + getErrorMessage(status));
			return Function_Continue;
		}

		var resultType:Int = Lua.type(lua, -1);
		if (!resultIsAllowed(resultType)) {
			trace("WARNING ($func): unsupported returned value type (\"" + Lua.typename(lua, resultType) + "\")");
			Lua.pop(lua, 1);
			return Function_Continue;
		}

		var result:Dynamic = cast Convert.fromLua(lua, -1);
		if (result == null) result = Function_Continue;

		Lua.pop(lua, 1);
		return result;
		#else
		return Function_Continue;
		#end
	}

	function getErrorMessage(status:Int, pop:Int = 1):String {
		#if LUA_ALLOWED
		var v:String = Lua.tostring(lua, -1);
		Lua.pop(lua, pop);

		if (v != null) v = v.trim();
		if (v == null || v == "") {
			return switch(status) {
				case Lua.LUA_ERRRUN: "Runtime Error";
				case Lua.LUA_ERRMEM: "Memory Allocation Error";
				case Lua.LUA_ERRERR: "Critical Error";
				default: "Unknown Error";
			}
		}

		return v;
		#else
		return null;
		#end
	}

	inline function resultIsAllowed(type:Int):Bool {
		return type >= Lua.LUA_TNIL && type <= Lua.LUA_TTABLE && type != Lua.LUA_TLIGHTUSERDATA;
	}

	public function set(variable:String, value:Dynamic) {
		#if LUA_ALLOWED
		if(lua == null) return;

		Convert.toLua(lua, value);
		Lua.setglobal(lua, variable);
		#end
	}

	public function stop() {
		#if LUA_ALLOWED
		if(lua == null) return;

		Lua_helper.terminate_callbacks(lua);
		Lua.close(lua);
		lua = null;
		#end
	}

	/*
	public function addCallback(fname:String, f:Dynamic) {
		#if LUA_ALLOWED
		callbacks[fname] = f;
		Lua.pushstring(lua, fname);
		Lua.pushstring(lua, scriptName);
		Lua.pushlightuserdata(lua, lua);
		trace("woah", lua);
		Lua.pushcclosure(lua, callbackHandler, 3);
		Lua.setglobal(lua, fname);
		#end
	}

	#if LUA_ALLOWED
	private static var _args:Array<Any>;
	private var callbacks:Map<String, Dynamic>;
	private var callbackHandler:Lua_CFunction;

	private inline function initCallbacks() {
		if (callbackHandler != null) return;
		callbackHandler = cpp.Callable.fromStaticFunction(callbackHandlerF);
		callbacks = [];
		_args = [];
	}

	private static inline function callbackHandlerF(r:StatePointer):Int {
		var l:State = Lua_helper.getstate(r);

		var fname:String = Lua.tostring(l, Lua.upvalueindex(1));
		var scriptname:String = Lua.tostring(l, Lua.upvalueindex(2));
		var pointer:StatePointer = cast Lua.topointer(l, Lua.upvalueindex(3));
		var state:State = Lua_helper.getstate(pointer);
		trace(pointer, pointer == r, state, state == l);
		if (fname == null || scriptname == null) return 0;

		var script = scriptFields.get(scriptname);
		if (script == null) return 0;

		var f = script.callbacks.get(fname);
		if (f == null) return 0;

		var nparams:Int = Lua.gettop(l);
		Lua_helper.getarguments(l, _args, nparams);
		_args.resize(nparams + 1);

		var ret = null;

		if (nparams <= 0)
			ret = f();
		else
			ret = Reflect.callMethod(null, f, _args);

		return (ret != null && Convert.toLua(l, ret)) ? 1 : 0;
	}
	#end
	*/
}