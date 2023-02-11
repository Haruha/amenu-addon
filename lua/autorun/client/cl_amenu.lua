// hook.Add("OnGamemodeLoaded", "aMenuIncludeCall", function()
	if string.find(string.lower(GAMEMODE.Name), "rp") or string.find(string.lower(GAMEMODE.Name), "purge") then
		print('loading amenu')
		include("amenu.lua")
	end
// end)