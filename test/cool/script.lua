function foo(i, f, s) 
    print("Called foo(), i = "..i..", f = "..f..", s = '"..s.."'\n")
end

local lol
function lol()
	print("awesome")
	return "ok"
end

print("lua file loaded")
print(duh(lol))