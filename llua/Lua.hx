package llua;

import llua.State;
import cpp.Callable;
import cpp.RawPointer;
import cpp.vm.Gc;

@:keep
@:include('linc_lua.h')
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('lua'))
#end
extern class Lua {
	@:native('linc::lua::version')
	static function version():String;

	@:native('linc::lua::release')
	static function release():String;

	@:native('linc::lua::version_num')
	static function version_num():Int;

	@:native('linc::lua::copyright')
	static function copyright():String;

	@:native('linc::lua::authors')
	static function authors():String;

	@:native('linc::lua::versionJIT')
	static function versionJIT():String;

	@:native('linc::lua::version_numJIT')
	static function version_numJIT():Int;

	@:native('linc::lua::copyrightJIT')
	static function copyrightJIT():String;

	@:native('linc::lua::urlJIT')
	static function urlJIT():String;


	/* mark for precompiled code (`<esc>Lua') */

	@:native('linc::lua::signature')
	static function signature():String;


	/* option for multiple returns in `lua_pcall' and `lua_call' */

	public static inline var LUA_MULTRET:Int = -1;


	/* pseudo-indices */

	public static inline var LUA_REGISTRYINDEX:Int = -10000;
	public static inline var LUA_ENVIRONINDEX:Int  = -10001;
	public static inline var LUA_GLOBALSINDEX:Int  = -10002;

	@:native('lua_upvalueindex')
	static function upvalueindex(i:Int):Int;


	/* thread status */

	public static inline var LUA_OK:Int        = 0;
	public static inline var LUA_YIELD:Int     = 1;
	public static inline var LUA_ERRRUN:Int    = 2;
	public static inline var LUA_ERRSYNTAX:Int = 3;
	public static inline var LUA_ERRMEM:Int    = 4;
	public static inline var LUA_ERRERR:Int    = 5;


	/* basic types */

	public static inline var LUA_TNONE:Int          = -1;

	public static inline var LUA_TNIL:Int           = 0;
	public static inline var LUA_TBOOLEAN:Int       = 1;
	public static inline var LUA_TLIGHTUSERDATA:Int = 2;
	public static inline var LUA_TNUMBER:Int        = 3;
	public static inline var LUA_TSTRING:Int        = 4;
	public static inline var LUA_TTABLE:Int         = 5;
	public static inline var LUA_TFUNCTION:Int      = 6;
	public static inline var LUA_TUSERDATA:Int      = 7;
	public static inline var LUA_TTHREAD:Int        = 8;


	/* minimum Lua stack available to a C function */

	public static inline var LUA_MINSTACK:Int = 20;


	/* state manipulation */

	// ALREADY EXISTS IN LuaL CLASS
	// @:native('lua_newstate')
	// static function newstate(f:lua_Alloc, ud:Void):State;

	@:native('lua_close')
	static function close(l:State):Void;

	@:native('lua_newthread')
	static function newthread(l:State):State;

	@:native('linc::lua::atpanic')
	static function atpanic(l:State, panicf:Lua_CFunction):Lua_CFunction;


	/* basic stack manipulation */

	@:native('lua_gettop')
	static function gettop(l:State):Int;

	@:native('lua_settop')
	static function settop(l:State, idx:Int):Void;

	@:native('lua_pushvalue')
	static function pushvalue(l:State, idx:Int):Void;

	@:native('lua_remove')
	static function remove(l:State, idx:Int):Void;

	@:native('lua_insert')
	static function insert(l:State, idx:Int):Void;

	@:native('lua_replace')
	static function replace(l:State, idx:Int):Void;

	@:native('lua_checkstack')
	static function checkstack(l:State, sz:Int):Int;

	@:native('lua_xmove')
	static function xmove(from:State, to:State, n:Int):Void;


	/* access functions (stack -> C) */

	@:noCompletion
	@:native('lua_isnumber')
	static function _isnumber(l:State, idx:Int):Int;

	static inline function isnumber(l:State, idx:Int):Bool
		return _isnumber(l, idx) != 0;

	@:noCompletion
	@:native('lua_isfunction')
	static function _isfunction(l:State, idx:Int):Int;

	static inline function isfunction(l:State, idx:Int):Bool
		return _isfunction(l, idx) != 0;

	@:noCompletion
	@:native('lua_isstring')
	static function _isstring(l:State, idx:Int):Int;

	static inline function isstring(l:State, idx:Int):Bool
		return _isstring(l, idx) != 0;

	@:noCompletion
	@:native('lua_iscfunction')
	static function _iscfunction(l:State, idx:Int):Int;

	static inline function iscfunction(l:State, idx:Int):Bool
		return _iscfunction(l, idx) != 0;

	@:noCompletion
	@:native('lua_isuserdata')
	static function _isuserdata(l:State, idx:Int):Int;

	static inline function isuserdata(l:State, idx:Int):Bool
		return _isuserdata(l, idx) != 0;

	@:noCompletion
	@:native('lua_isboolean')
	static function _isboolean(l:State, idx:Int):Int;

	static inline function isboolean(l:State, idx:Int):Bool
		return _isboolean(l, idx) != 0;

	@:noCompletion
	@:native('lua_istable')
	static function _istable(l:State, idx:Int):Int;

	static inline function istable(l:State, idx:Int):Bool
		return _istable(l, idx) != 0;

	@:noCompletion
	@:native('lua_islightuserdata')
	static function _islightuserdata(l:State, idx:Int):Int;

	static inline function islightuserdata(l:State, idx:Int):Bool
		return _islightuserdata(l, idx) != 0;

	@:noCompletion
	@:native('lua_isnil')
	static function _isnil(l:State, idx:Int):Int;

	static inline function isnil(l:State, idx:Int):Bool
		return _isnil(l, idx) != 0;

	@:noCompletion
	@:native('lua_isthread')
	static function _isthread(l:State, idx:Int):Int;

	static inline function isthread(l:State, idx:Int):Bool
		return _isthread(l, idx) != 0;

	@:noCompletion
	@:native('lua_isnone')
	static function _isnone(l:State, idx:Int):Int;

	static inline function isnone(l:State, idx:Int):Bool
		return _isnone(l, idx) != 0;

	@:noCompletion
	@:native('lua_isnoneornil')
	static function _isnoneornil(l:State, idx:Int):Int;

	static inline function isnoneornil(l:State, idx:Int):Bool
		return _isnoneornil(l, idx) != 0;

	@:native('lua_type')
	static function type(l:State, idx:Int):Int;

	@:native('linc::lua::_typename') // PLEASE USE LuaL.typename INSTEAD!!
	static function typename(l:State, tp:Int):String;

	@:native('lua_equal')
	static function equal(l:State, idx1:Int, idx2:Int):Int;

	@:native('lua_rawequal')
	static function rawequal(l:State, idx1:Int, idx2:Int):Int;

	@:native('lua_lessthan')
	static function lessthan(l:State, idx1:Int, idx2:Int):Int;

	@:native('lua_tonumber')
	static function tonumber(l:State, idx:Int):Float;

	@:native('lua_tointeger')
	static function tointeger(l:State, idx:Int):Int;

	@:noCompletion
	@:native('lua_toboolean')
	static function _toboolean(l:State, idx:Int):Int;

	static inline function toboolean(l:State, idx:Int):Bool
		return _toboolean(l, idx) != 0;

	@:native('linc::lua::tostring')
	static function tostring(l:State, idx:Int):String;

	@:native('linc::lua::tolstring')
	static function tolstring(l:State, idx:Int, len:UInt):String;

	@:native('lua_objlen')
	static function objlen(l:State, idx:Int):Int;

	@:native('linc::lua::tocfunction')
	static function tocfunction(l:State, idx:Int):Lua_CFunction;

	@:native('lua_touserdata')
	static function touserdata(l:State, idx:Int):Any;

	@:native('lua_tothread')
	static function tothread(l:State, idx:Int):State;

	@:native('linc::lua::topointer')
	static function topointer(l:State, idx:Int):Lua_Pointer;


	/* push functions (C -> stack) */

	@:native('lua_pushnil')
	static function pushnil(l:State):Void;

	@:native('lua_pushnumber')
	static function pushnumber(l:State, n:Float):Void;

	@:native('lua_pushinteger')
	static function pushinteger(l:State, n:Int):Void;

	@:native('lua_pushlstring')
	static function pushlstring(l:State, s:String, len:Int):Void;

	@:native('lua_pushstring')
	static function pushstring(l:State, s:String):Void;

	// @:native('lua_pushvfstring') //?
	// static function pushvfstring(l:State, fmt:String, argp:va_list):Void;

	// @:native('lua_pushfstring') //?
	// static function pushfstring(l:State, fmt:String, ...):Void;

	@:native('linc::lua::pushcclosure')
	static function pushcclosure(l:State, fn:Lua_CFunction, n:Int):Void;

	@:native('linc::lua::pushcfunction')
	static function pushcfunction(l:State, fn:Lua_CFunction):Void;

	@:native('linc::lua::pushboolean')
	static function pushboolean(l:State, b:Bool):Void;

	@:native('lua_pushlightuserdata')
	static function pushlightuserdata(l:State, p:Any):Void;

	@:native('lua_pushthread')
	static function pushthread(l:State):Int;


	/* get functions (Lua -> stack) */

	@:native('lua_gettable')
	static function gettable(l:State, idx:Int):Void;

	@:native('lua_getfield')
	static function getfield(l:State, idx:Int, k:String):Void;

	@:native('lua_rawget')
	static function rawget(l:State, idx:Int):Void;

	@:native('lua_rawgeti')
	static function rawgeti(l:State, idx:Int, n:Int):Void;

	@:native('lua_createtable')
	static function createtable(l:State, narr:Int, nrec:Int):Void;

	@:native('lua_newuserdata')
	static function newuserdata(l:State, size:Int):Void;

	@:native('lua_getmetatable')
	static function getmetatable(l:State, objindex:Int):Int;

	@:native('lua_getfenv')
	static function getfenv(l:State, int:Int):Void;


	/* set functions (stack -> Lua) */

	@:native('lua_settable')
	static function settable(l:State, idx:Int):Void;

	@:native('lua_setfield')
	static function setfield(l:State, idx:Int, s:String):Void;

	@:native('lua_rawset')
	static function rawset(l:State, idx:Int):Void;

	@:native('lua_rawseti')
	static function rawseti(l:State, idx:Int, n:Int):Void;

	@:native('lua_setmetatable')
	static function setmetatable(l:State, objindex:Int):Int;

	@:native('lua_setfenv')
	static function lua_setfenv(l:State, idx:Int):Int;


	/* `load' and `call' functions (load and run Lua code) */

	@:native('lua_call')
	static function call(l:State, nargs:Int, nresults:Int):Void;

	@:native('lua_pcall')
	static function pcall(l:State, nargs:Int, nresults:Int, errfunc:Int):Int;

	@:native('linc::lua::cpcall') // works?
	static function cpcall(l:State, func:Lua_CFunction, ud:Lua_Pointer):Int;

	// @:native('lua_load') //?
	// static function load(l:State, reader:lua_Reader, data:Void, chunkname:String):Int;

	// @:native('lua_dump') //?
	// static function dump(l:State, writer:lua_Writer, data:Void):Int;


	/* coroutine functions */

	@:native('lua_yield')
	static function yield(l:State, n:Int):Int;

	@:native('lua_resume')
	static function resume(l:State, narg:Int):Int;

	@:native('lua_status')
	static function status(l:State):Int;


	/* garbage-collection function and options */

	public static inline var LUA_GCSTOP:Int       = 0;
	public static inline var LUA_GCRESTART:Int    = 1;
	public static inline var LUA_GCCOLLECT:Int    = 2;
	public static inline var LUA_GCCOUNT:Int      = 3;
	public static inline var LUA_GCCOUNTB:Int     = 4;
	public static inline var LUA_GCSTEP:Int       = 5;
	public static inline var LUA_GCSETPAUSE:Int   = 6;
	public static inline var LUA_GCSETSTEPMUL:Int = 7;

	@:native('lua_gc')
	static function gc(l:State, what:Int, data:Int):Int;


	/* miscellaneous functions */

	@:native('lua_error')
	static function error(l:State):Int;

	@:native('lua_next')
	static function next(l:State, idx:Int):Int;

	@:native('lua_concat')
	static function concat(l:State, n:Int):Void;

	// @:native('lua_getallocf') //?
	// static function getallocf(l:State, ud:Void):lua_Alloc;

	// @:native('lua_setallocf') //?
	// static function setallocf(l:State, f:lua_Alloc, ud:Void):Void;


	/* some useful macros */

	@:native('lua_pop')
	static function pop(l:State, n:Int):Void;

	@:native('lua_newtable')
	static function newtable(l:State):Void;

	@:native('lua_strlen')
	static function strlen(l:State, idx:Int):Int;

	@:native('lua_pushliteral')
	static function pushliteral(l:State, s:String):Void;

	@:native('lua_setglobal')
	static function setglobal(l:State, name:String):Void;

	@:native('lua_getglobal')
	static function getglobal(l:State, name:String):Void;


	/* hack */
	@:native('lua_setlevel')
	static function setlevel(from:State, to:State):Void;


	/*
	** {======================================================================
	** Debug API
	** =======================================================================
	*/

	/* Event codes */

	public static inline var LUA_HOOKCALL:Int    = 0;
	public static inline var LUA_HOOKRET:Int     = 1;
	public static inline var LUA_HOOKLINE:Int    = 2;
	public static inline var LUA_HOOKCOUNT:Int   = 3;
	public static inline var LUA_HOOKTAILRET:Int = 4;


	/* Event masks */

	public static inline var LUA_MASKCALL:Int  = (1 << LUA_HOOKCALL);
	public static inline var LUA_MASKRET:Int   = (1 << LUA_HOOKRET);
	public static inline var LUA_MASKLINE:Int  = (1 << LUA_HOOKLINE);
	public static inline var LUA_MASKCOUNT:Int = (1 << LUA_HOOKCOUNT);


	/* Functions to be called by the debuger in specific events */

	@:native('linc::lua::getstack') // works?
	static function getstack(l:State, level:Int, ar:Lua_Debug):Int;

	@:native('linc::lua::getinfo') // works?
	static function getinfo(l:State, what:String, ar:Lua_Debug):Int;

	@:native('linc::lua::getlocal') // works?
	static function getlocal(l:State, ar:Lua_Debug, n:Int):String;

	@:native('linc::lua::setlocal') // works?
	static function setlocal(l:State, ar:Lua_Debug, n:Int):String;

	@:native('lua_getupvalue')
	static function getupvalue(l:State, funcindex:Int, n:Int):String;

	@:native('lua_setupvalue')
	static function setupvalue(l:State, funcindex:Int, n:Int):String;

	// @:native('lua_sethook') //?
	// static function sethook(l:State, f:lua_Hook, mask:Int, count:Int):Int;

	// @:native('lua_gethook') //?
	// static function gethook(l:State):lua_Hook;

	@:native('lua_gethookmask')
	static function gethookmask(l:State):Int;

	@:native('lua_gethookcount')
	static function gethookcount(l:State):Int;


	/* From Lua 5.2. */

	@:native('lua_upvalueid')
	static function upvalueid(l:State, idx:Int, n:Int):Void;

	@:native('lua_upvaluejoin')
	static function upvaluejoin(l:State, idx1:Int, n1:Int, idx2:Int, n2:Int):Void;

	// @:native('lua_loadx') //?
	// static function loadx(l:State, reader:lua_Reader, dt:Void, chunkname:String, mode:String):Int;


	/* compatibility with ref system */

	@:native('lua_ref')
	static function ref(l:State, lock:Bool):Int;

	@:native('lua_unref')
	static function unref(l:State, ref:Int):Void;

	@:native('lua_getref')
	static function getref(l:State, ref:Int):Void;


	/* unofficial API helpers */

	@:native('linc::helpers::statetoint')
	static function statetoint(l:State):Int;

	@:native('linc::helpers::init_hxtrace') // works?
	static function init_hxtrace(f:Callable<String->Int>):Void;

	@:native('linc::helpers::register_hxtrace') // works?
	static function register_hxtrace(l:State):Void;

	@:native('linc::helpers::unregister_hxtrace') // works?
	static function unregister_hxtrace(l:State):Void;

	@:native('linc::callbacks::init_callbacks')
	static function init_callbacks(fn:Callable<State->Int->Int>):Void;

	@:native('linc::callbacks::callback_id')
	static function callback_id():Int;

	@:native('linc::callbacks::create_callback')
	static function create_callback(l:State):Int;

	@:native('linc::callbacks::add_callback')
	static function add_callback(l:State, name:String):Int;

	@:native('linc::callbacks::link_callback')
	static function link_callback(l:State, i:Int, name:String):Int;

	@:native('linc::callbacks::unlink_callback')
	static function unlink_callback(l:State, name:String):Void;
}

@:include('Std')
class Lua_helper {
	/* custom traces */

	public static var trace:(s:String, ?inf:haxe.PosInfos) -> Void = function(s:String, ?_):Void {
		trace(s);
	};

	public static function init_hxtrace():Void // works?
		Lua.init_hxtrace(Callable.fromStaticFunction(print_function));

	public static function register_hxtrace(l:State):Void // works?
		Lua.register_hxtrace(l);

	public static function unregister_hxtrace(l:State):Void // works?
		Lua.unregister_hxtrace(l);

	static inline function print_function(s:String):Int {
		if (Lua_helper.trace != null) Lua_helper.trace(s);
		return 0;
	}


	/* callbacks */

	public static var statics:Map<String, Int> = new Map<String, Int>();

	private static var __inited:Bool = false;
	private static var _luas:Map<Int, Map<String, Int>> = new Map<Int, Map<String, Int>>();
	private static var _luaUnks:Map<Int, Array<Int>> = new Map<Int, Array<Int>>();
	private static var _callbacks:Map<Int, Lua_Callback> = new Map<Int, Lua_Callback>();
	private static var _extras:Map<Int, Array<Any>> = new Map<Int, Array<Any>>();
	private static var _advs:Map<Int, Bool> = new Map<Int, Bool>();
	private static var _args:Array<Any>;

	public static function init_callbacks(l:State):Void {
		var p:Int = Lua.statetoint(l);
		if (!_luas.exists(p)) {
			_luas.set(p, new Map<String, Int>());
			_luaUnks.set(p, []);
		}
		if (__inited) return;
		__inited = true;
		_args = [];
		Lua.init_callbacks(Callable.fromStaticFunction(callback_handler));
	}

	inline public static function link_extra_arguments(l:State, extra:Array<Any>)
		_extras.set(Lua.statetoint(l), extra);

	inline public static function unlink_extra_arguments(l:State)
		_extras.remove(Lua.statetoint(l));

	inline public static function link_callback(i:Int, fn:Lua_Callback, adv:Bool) {
		_callbacks.set(i, fn);
		_advs.set(i, adv);
	}

	inline public static function unlink_callback(i:Int) {
		_callbacks.remove(i);
		_advs.remove(i);
	}

	public static function link_static_callbacks(l:State):Void {
		for (fname in statics.keys()) link_static_callback(l, fname);
		Gc.compact();
	}

	public static function link_static_callback(l:State, fname:String):Int {
		if (!statics.exists(fname)) return -1;
		return Lua.link_callback(l, statics.get(fname), fname);
	}

	public static function create_callback(l:State, ?adv:Bool = false, fn:Lua_Callback):Int {
		var i:Int = Lua.create_callback(l);
		link_callback(i, fn, adv);
		_luaUnks.get(Lua.statetoint(l)).push(i);
		return i;
	}

	public static function set_static_callback(fname:String, ?adv:Bool = false, fn:Lua_Callback):Int {
		var i:Int = Lua.callback_id();
		link_callback(i, fn, adv);
		statics.set(fname, i);
		return i;
	}

	public static function remove_static_callback(fname:String):Void {
		if (!statics.exists(fname)) return;
		unlink_callback(statics.get(fname));
		statics.remove(fname);
	}

	inline public static function remove_static_callbacks():Void
		for (fname in statics.keys()) remove_static_callback(fname);

	public static function add_callback(l:State, fname:String, ?adv:Bool = false, fn:Lua_Callback):Int {
		var i:Int = Lua.add_callback(l, fname);
		link_callback(i, fn, adv);
		_luas.get(Lua.statetoint(l)).set(fname, i);
		return i;
	}

	static function _remove_callback(l:State, i:Int, fname:String):Int {
		unlink_callback(i);
		Lua.unlink_callback(l, fname);
		return i;
	}

	public static function remove_callback(l:State, fname:String):Int
		return _remove_callback(l, _luas.get(Lua.statetoint(l)).get(fname), fname);

	public static function clear_callbacks(l:State):Void {
		var callbacks = _luas.get(Lua.statetoint(l));
		for (key in callbacks.keys()) _remove_callback(l, callbacks.get(key), key);
		Gc.compact();
	}

	public static function terminate_callbacks(l:State):Void {
		clear_callbacks(l);
		for (i in _luaUnks.get(Lua.statetoint(l))) unlink_callback(i);
		unlink_extra_arguments(l);
		Gc.compact();
	}

	private static function callback_handler(l:State, i:Int):Int {
		var fn:Lua_Callback = _callbacks.get(i);
		if (fn == null) return 0;
		var extra:Array<Any> = _extras.get(Lua.statetoint(l));
		var en:Int = extra != null ? extra.length : 0;
		if (_advs.get(i)) {
			if (en <= 0) return fn(l);
			var i:Int = en + 1;
			if (_args.length > i) _args.resize(i);
			for (d in 1...i) _args[d] = extra[d - 1];
			_args[0] = l;
			return Reflect.callMethod(null, fn, _args);
		}

		var n:Int = Lua.gettop(l);
		var ret:Any = null;
		if (n > 0) {
			var i:Int = n + en;
			if (_args.length > i) _args.resize(i);
			if (en > 0) for (d in 0...en) _args[d] = extra[d];
			_getarguments(l, _args, n, en);
			ret = Reflect.callMethod(null, fn, _args);
		}
		else if (en > 0) ret = Reflect.callMethod(null, fn, extra);
		else ret = fn();

		return (ret != null && Convert.toLua(l, ret)) ? 1 : 0;
	}


	/* useful macros */

	inline private static function _getarguments(l:State, args:Array<Any>, nparams:Int, offset:Int):Void
		for (i in 0...nparams) args[i + offset] = Convert.fromLua(l, i + 1);

	public static function getarguments(l:State, ?args:Array<Any>, ?nparams:Int, ?offset:Int = 0):Array<Any> {
		if (args == null) args = [];
		if (nparams == null) nparams = Lua.gettop(l);
		if (nparams == 0) return args;

		_getarguments(l, args, nparams, offset);
		return args;
	}

	public static function callref(l:State, ref:Int, nargs:Int, nresults:Int):Void {
		Lua.rawgeti(l, Lua.LUA_REGISTRYINDEX, ref);
		Lua.call(l, nargs, nresults);
		LuaL.unref(l, Lua.LUA_REGISTRYINDEX, ref);
	}

	public static function pcallref(l:State, ref:Int, nargs:Int, nresults:Int, errfunc:Int):Int {
		Lua.rawgeti(l, Lua.LUA_REGISTRYINDEX, ref);
		var status:Int = Lua.pcall(l, nargs, nresults, errfunc);
		LuaL.unref(l, Lua.LUA_REGISTRYINDEX, ref);

		return status;
	}

	@:noCompletion
	public static function getstate(v:StatePointer):State return untyped __cpp__("v");

	@:noCompletion
	public static function getstatepointer(v:State):StatePointer return untyped __cpp__("v");

	@:noCompletion
	public static function getcallback(v:Lua_CallbackPointer):Lua_Callback return untyped __cpp__("*v");

	@:noCompletion
	public static function getcallbackpointer(v:Lua_Callback):Lua_CallbackPointer return untyped __cpp__("&v");
}

typedef Lua_Debug = {
	@:optional var event:Int;
	@:optional var name:String;				// (n)
	@:optional var namewhat:String;			// (n) `global', `local', `field', `method'
	@:optional var what:String;				// (S) `Lua', `C', `main', `tail'
	@:optional var source:String;			// (S)
	@:optional var currentline:Int;			// (l)
	@:optional var nups:Int;				// (u) number of upvalues
	@:optional var linedefined:Int;			// (S)
	@:optional var lastlinedefined:Int;		// (S)
	@:optional var short_src:Array<String>;	// (S)

	@:optional var i_ci:Int;				// private
}

typedef Lua_CFunction = Callable<StatePointer->Int>;
typedef Lua_Pointer = RawPointer<Any>;
typedef Lua_Callback = Dynamic;
typedef Lua_CallbackPointer = RawPointer<Lua_Callback>;
