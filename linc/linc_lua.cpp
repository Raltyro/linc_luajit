#include <hxcpp.h>
#include <hx/CFFI.h>

#include <map>
#include <cstdint>

#include "./linc_lua.h"
#include "../lib/lua/src/lua.hpp"

namespace linc {
	namespace lua {
		::String version(){
			return ::String(LUA_VERSION);
		}

		::String release(){
			return ::String(LUA_RELEASE);
		}

		int version_num(){
			return (int)LUA_VERSION_NUM;
		}

		::String copyright(){
			return ::String(LUA_COPYRIGHT);
		}

		::String authors(){
			return ::String(LUA_AUTHORS);
		}

		::String versionJIT(){
			return ::String(LUAJIT_VERSION);
		}

		int version_numJIT(){
			return (int)LUAJIT_VERSION_NUM;
		}

		::String copyrightJIT(){
			return ::String(LUAJIT_COPYRIGHT);
		}

		::String urlJIT(){
			return ::String(LUAJIT_URL);
		}

		::String signature(){
			return ::String(LUA_SIGNATURE);
		}

		::cpp::Function<int(lua_State*)> atpanic(lua_State* l, ::cpp::Function<int(lua_State*)> panicf) {
			return (::cpp::Function<int(lua_State*)>) lua_atpanic(l, (lua_CFunction)panicf);
		}

		::String tostring(lua_State *l, int v) {
			return ::String(lua_tostring(l, v));
		}

		::String tolstring(lua_State *l, int v, size_t *len) {
			return ::String(lua_tolstring(l, v, len));
		}

		::cpp::Function<int(lua_State*)> tocfunction(lua_State* l, int v) {
			return (::cpp::Function<int(lua_State*)>) lua_tocfunction(l, v);
		}

		::Dynamic* topointer(lua_State *l, int v) {
			return (::Dynamic*)lua_topointer(l, v);
		}

		::String _typename(lua_State* l, int v) {
			return ::String(lua_typename(l, v));
		}

		void pushboolean(lua_State *l, bool b) {
			lua_pushboolean(l, b ? 1 : 0);
		}

		void pushcclosure(lua_State *l, ::cpp::Function<int(lua_State*)> fn, int n) {
			lua_pushcclosure(l, (lua_CFunction)fn, n);
		}

		void pushcfunction(lua_State *l, ::cpp::Function<int(lua_State*)> fn) {
			lua_pushcfunction(l, (lua_CFunction)fn);
		}

		int cpcall(lua_State *l, ::cpp::Function<int(lua_State*)> func, ::Dynamic* ud) {
			return (int)lua_cpcall(l, (lua_CFunction)func, (void*)ud);
		}

		int getstack(lua_State *L, int level, Dynamic ar) {
			lua_Debug dbg;
			
			int ret = lua_getstack(L, level, &dbg);
			
			ar->__FieldRef(HX_CSTRING("i_ci")) = (int)dbg.i_ci;
			return ret;
		}

		int getinfo(lua_State *L, const char *what, Dynamic ar) {
			lua_Debug dbg;

			dbg.i_ci = ar->__FieldRef(HX_CSTRING("i_ci"));
			int ret = lua_getinfo(L, what, &dbg);

			if (strchr(what, 'S')) {
				if (dbg.source != NULL) {
					ar->__FieldRef(HX_CSTRING("source")) = ::String(dbg.source);
				}
				if (dbg.short_src != NULL) {
					ar->__FieldRef(HX_CSTRING("short_src")) = ::String(dbg.short_src);
				}
				if (dbg.linedefined != NULL) {
					ar->__FieldRef(HX_CSTRING("linedefined")) = (int)dbg.linedefined;
				}
				if (dbg.lastlinedefined != NULL) {
					ar->__FieldRef(HX_CSTRING("lastlinedefined")) = (int)dbg.lastlinedefined;
				}
				if (dbg.what != NULL) {
					ar->__FieldRef(HX_CSTRING("what")) = ::String(dbg.what);
				}
			}

			if (strchr(what, 'n')) {
				if (dbg.name != NULL) {
					ar->__FieldRef(HX_CSTRING("name")) = ::String(dbg.name);
				}
				if (dbg.namewhat != NULL) {
					ar->__FieldRef(HX_CSTRING("namewhat")) = ::String(dbg.namewhat);
				}
			}

			if (strchr(what, 'l')) {
				if (dbg.currentline != NULL) {
					ar->__FieldRef(HX_CSTRING("currentline")) = (int)dbg.currentline;
				}
			}

			if (strchr(what, 'u')) {
				if (dbg.nups != NULL) {
					ar->__FieldRef(HX_CSTRING("nups")) = (int)dbg.nups;
				}
			}

			return ret;
		}

		::String getlocal(lua_State *L, Dynamic ar, int n) {
			lua_Debug dbg;

			dbg.i_ci = ar->__FieldRef(HX_CSTRING("i_ci"));
			return ::String(lua_getlocal(L, &dbg, n));
		}

		::String setlocal(lua_State *L, Dynamic ar, int n) {
			lua_Debug dbg;

			dbg.i_ci = ar->__FieldRef(HX_CSTRING("i_ci"));
			return ::String(lua_setlocal(L, &dbg, n));
		}
	} //lua

	namespace lual {
		::String checklstring(lua_State *l, int numArg, size_t *len) {
			return ::String(luaL_checklstring(l, numArg, len));
		}

		::String optlstring(lua_State *l, int numArg, const char *def, size_t *len) {
			return ::String(luaL_optlstring(l, numArg, def, len));
		}

		::String prepbuffer(luaL_Buffer *B) {
			return ::String(luaL_prepbuffer(B));
		}

		::String gsub(lua_State *l, const char *s, const char *p, const char *r) {
			return ::String(luaL_gsub(l, s, p, r));
		}

		::String findtable(lua_State *L, int idx, const char *fname, int szhint) {
			return ::String(luaL_findtable(L, idx, fname, szhint));
		}

		::String checkstring(lua_State *L, int n) {
			return ::String(luaL_checkstring(L, n));
		}

		::String optstring(lua_State *L, int n, const char *d) {
			return ::String(luaL_optstring(L, n, d));
		}

		void error(lua_State *L, const char* fmt) {
			luaL_error(L,fmt,"");
		}

		::String ltypename(lua_State *L, int idx) {
			return ::String(luaL_typename(L, idx));
		}

	} //lual

	namespace helpers {
		int statetoint(lua_State* L) {
			return reinterpret_cast<std::uintptr_t>(L);
		}

		// haxe trace function

		static HxTraceFN print_fn = 0;
		static int hx_trace(lua_State* L) {

			std::stringstream buffer;
			int n = lua_gettop(L);  /* number of arguments */

			lua_getglobal(L,"tostring");

			for ( int i = 1;  i <= n;  ++i ){
				const char* s = NULL;
				size_t	  l = 0;

				lua_pushvalue(L,-1);	/* function to be called */
				lua_pushvalue(L,i); /* value to print */
				lua_call(L,1,1);

				s = lua_tolstring(L,-1, &l); /* get result */
				if ( s == NULL ){
					return luaL_error(L,LUA_QL("tostring") " must return a string to " LUA_QL("print"));
				}

				if ( i>1 ){
					buffer << "\t";
				}

				buffer << s;

				lua_pop(L,1);   /* pop result */
			}

			// std::cout << buffer.str(); // c++ out
			print_fn(::String(buffer.str().c_str())); // hx out

			return 0;

		}

		static const struct luaL_Reg printlib [] = {
			{"print", hx_trace},
			{NULL, NULL} /* end of array */
		};

		void init_hxtrace(HxTraceFN fn) {
			print_fn = fn;
		}

		void register_hxtrace(lua_State* L) {
			lua_getglobal(L, "_G");
			luaL_register(L, NULL, printlib);
			lua_pop(L, 1);
		}

		void unregister_hxtrace(lua_State* L) {
			lua_getglobal(L, "_G");
			lua_pushnil(L);
			lua_setglobal(L, NULL);
			lua_pop(L, 1);
		}
	} //helpers

	namespace callbacks {
		static luaCallbackFN handler = 0;
		static int id = 0;

		static int luaCallback(lua_State *l) {
			return handler(l, lua_tointeger(l, lua_upvalueindex(1)), lua_tothread(l, lua_upvalueindex(2)));
		}

		void init_callbacks(luaCallbackFN fn) {
			handler = fn;
		}

		int callback_id() {
			return id++;
		}

		int create_callback(lua_State* L) {
			lua_pushinteger(L, id);
			lua_pushthread(L);
			lua_pushcclosure(L, luaCallback, 2);
			return id++;
		}

		int add_callback(lua_State* L, const char *name) {
			int i = create_callback(L);
			lua_setglobal(L, name);
			return i;
		}

		int link_callback(lua_State* L, int id, const char *name) {
			lua_pushinteger(L, id);
			lua_pushthread(L);
			lua_pushcclosure(L, luaCallback, 2);
			lua_setglobal(L, name);
			return id;
		}

		void unlink_callback(lua_State* L, const char *name) {
			lua_pushnil(L);
			lua_setglobal(L, name);
		}
	}
} //linc
