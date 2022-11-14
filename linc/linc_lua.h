#pragma once

#include <hxcpp.h>
#include <hx/CFFI.h>

#include <sstream>
#include <iostream>

#include "../lib/lua/src/lua.hpp"

namespace linc {
	typedef ::cpp::Function < int(String) > HxTraceFN;

	namespace lua {
		extern ::String version();
		extern ::String release();
		extern int version_num();
		extern ::String copyright();
		extern ::String authors();
		extern ::String versionJIT();
		extern int version_numJIT();
		extern ::String copyrightJIT();
		extern ::String urlJIT();

		extern ::String signature();

		extern ::cpp::Function<int(lua_State*)> atpanic(lua_State* l, ::cpp::Function<int(lua_State*)> panicf);

		extern ::String tostring(lua_State *l, int v);
		extern ::String tolstring(lua_State *l, int v, size_t *len);
		extern ::cpp::Function<int(lua_State*)> tocfunction(lua_State* l, int v);
		extern ::Dynamic* topointer(lua_State *l, int v);

		extern ::String _typename(lua_State *l, int tp);

		extern void pushcclosure(lua_State *l, ::cpp::Function<int(lua_State*)> fn, int n);
		extern void pushcfunction(lua_State *l, ::cpp::Function<int(lua_State*)> fn);

		extern int cpcall(lua_State *l, ::cpp::Function<int(lua_State*)> func, ::Dynamic* ud);

		extern int getstack(lua_State *L, int level, Dynamic ar);
		extern int getinfo(lua_State *L, const char *what, Dynamic ar);
		extern ::String getlocal(lua_State *L, Dynamic ar, int n);
		extern ::String setlocal(lua_State *L, Dynamic ar, int n);
	}

	namespace lual {
		extern ::String checklstring(lua_State *l, int numArg, size_t *len);
		extern ::String optlstring(lua_State *L, int numArg, const char *def, size_t *l);
		extern ::String prepbuffer(luaL_Buffer *B);
		extern ::String gsub(lua_State *l, const char *s, const char *p, const char *r);
		extern ::String findtable(lua_State *L, int idx, const char *fname, int szhint);
		extern ::String checkstring(lua_State *L, int n);
		extern ::String optstring(lua_State *L, int n, const char *d);
		extern ::String ltypename(lua_State *L, int idx);
		extern void error(lua_State *L, const char* fmt);
	}

	namespace helpers {
		extern void init_hxtrace(HxTraceFN fn);
		extern void register_hxtrace(lua_State* L);
		extern void unregister_hxtrace(lua_State* L);
	}
}
