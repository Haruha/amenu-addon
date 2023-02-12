hook.Add("OnGamemodeLoaded", "aMenuIncludeCall", function()
	if string.find(string.lower(GAMEMODE.Name), "rp") or string.find(string.lower(GAMEMODE.Name), "purge") then
		include("amenu.lua")
	end
end)