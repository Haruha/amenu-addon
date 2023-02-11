--Main Table - best if you don't touch this ever
aMenu 			= {}

--The overall colour of aMenu (uncomment to enable, make sure only one is active at a time though!)
--aMenu.Color 				= Color(66, 139, 202) 	--Blue
--aMenu.Color 				= Color(215, 85, 80) 	--Red
--aMenu.Color 				= Color(26, 188, 156)	--Turquoise
--aMenu.Color 				= Color(92, 184, 92)	--Green
--aMenu.Color 				= Color(91, 192, 222)	--Light blue
aMenu.Color 				= Color(228, 100, 75)	--Orange

--The text underneath the title at the top of the menu
aMenu.SubTitle 				= "aMenu by arie"

--Do we show VIP jobs in the jobs tab?
aMenu.ShowVIP 				= true

--Do we show all weapons in the entity-based tabs (entities, weapons, shipments etc.) even if we can't afford them?
aMenu.ShowAllEntities		= true

--Sort categories in jobs and entity tabs according to their default sortOrder value?
aMenu.SortOrder 			= true


-----Disabling main tabs stuff
--In order to disable a tab, change its value from true to false and change map

aMenu.AllowedTabs = {}

aMenu.AllowedTabs["Dashboard"] 	= true
aMenu.AllowedTabs["Jobs"] 		= true
aMenu.AllowedTabs["Entities"] 	= true
aMenu.AllowedTabs["Weapons"] 	= true
aMenu.AllowedTabs["Shipments"] 	= true
aMenu.AllowedTabs["Ammo"] 		= true
aMenu.AllowedTabs["Rules"] 		= true
aMenu.AllowedTabs["Food"] 		= true
aMenu.AllowedTabs["Website"] 	= true
aMenu.AllowedTabs["Donate"] 	= true
aMenu.AllowedTabs["Workshop"] 	= true


-----Dashboard stuff
--Put the names of the user ranks that you wish to appear inside the online staff list here, alongside their display names.

--For example, listing "superadmin" here will not only make users with that rank show up in the staff 
--list, but also show their rank as "Super Admin" rather than "superadmin"

aMenu.StaffGroups = {}

aMenu.StaffGroups["superadmin"]		= "Super Admin"
aMenu.StaffGroups["admin"]			= "Admin"
aMenu.StaffGroups["moderator"]		= "Moderator"
					

-----Extra tabs stuff
--All web addresses have to start with either http:// or https://
--Leave variable blank as "" if you don't want a certain button

--Website link
aMenu.WebsiteLink 			= ""

--Donation link
aMenu.DonationLink 			= ""

--Workshop collection link
aMenu.WorkshopLink 			= ""


-----Descriptions stuff
aMenu.Descriptions = {}

--If you wish a certain item to have a description when selected, you can set it here.
--Works for entities, weapons, shipments and ammo.

--Usage: aMenu.Descriptions["entitynamehere"] = [[description here]] 
aMenu.Descriptions["Overclocked Printer"] = [[This is a printer that has been overclocked to be more efficient.
											It will produce much greater sums of money at a faster rate - but at an increase to the original price.]]

aMenu.Descriptions["P228"] = [[A low-recoil firearm with a high rate of fire, the P228 is a relatively inexpensive choice against armored opponents.]]


-----Rules stuff
--So unless you want to go ahead and use your own rules for the rules page feel free to leave this as it is.
--However, if you DO want to use your own rules, set the variable below to false and enter your rules in the rules variable.
aMenu.UseLink 				= true

--Link to a rules.txt file
aMenu.RulesLink = "https://raw.githubusercontent.com/Haruha/aMenu/master/rules.txt"

aMenu.Rules 	= [[
--General Rules
	1. Don't RDM other players
	2. Don't annoy the admins
	3. Use common sense
]]


-----Misc stuff
--Do we display a list of weapons in each job's description box?
aMenu.DisplayWeapons 		= true

--Do we show the theme colour in the preview box on the right when we click on a job?
aMenu.PreviewThemeColour 	= true

--Do we preview the job's full colour in the pie chart's key?
aMenu.ChartFullColour		= false
	
--Blur behind the F4 menu?
aMenu.BlurBackground		= true


-----Levels stuff
--What colour do we want the job's level bar in the jobs list to be if we can't be the job?
aMenu.LevelAcceptColor		= aMenu.Color

--What colour do we want the job's level bar in the jobs list to be if we can be the job?
aMenu.LevelDenyColor		= Color(31, 31, 31)


-----Fonts 
--Feel free to edit if you need to
surface.CreateFont("aMenuTitle", 	{font = "Open Sans", 	size = 32, 	weight = 500})
surface.CreateFont("aMenuSubTitle", {font = "Open Sans", 	size = 24, 	weight = 500})
surface.CreateFont("aMenuJob", 		{font = "Open Sans", 	size = 28, 	weight = 500})
surface.CreateFont("aMenu22", 		{font = "Open Sans", 	size = 22, 	weight = 500})
surface.CreateFont("aMenu20", 		{font = "Open Sans", 	size = 20, 	weight = 500})
surface.CreateFont("aMenu19", 		{font = "Open Sans", 	size = 19, 	weight = 500})
surface.CreateFont("aMenu18", 		{font = "Open Sans", 	size = 18, 	weight = 500})
surface.CreateFont("aMenu14", 		{font = "Open Sans", 	size = 15, 	weight = 500})


-----Materials 
--if somehow you can't download them automatically when joining a server then the collection can be found at...
--http://steamcommunity.com/sharedfiles/filedetails/?id=728328781

--Oh yeah and don't touch anything below this line unless you know what you're doing
aMenu.HomeButton 			= Material("amenu/home.png")
aMenu.CommandsButton 		= Material("amenu/commands.png")
aMenu.JobsButton 			= Material("amenu/jobs.png")
aMenu.EntitiesButton 		= Material("amenu/entities.png")
aMenu.WeaponsButton 		= Material("amenu/weapons.png")
aMenu.ShipmentsButton 		= Material("amenu/shipments.png")
aMenu.RulesButton 			= Material("amenu/rules.png")
aMenu.AmmoButton 			= Material("amenu/ammo.png")
aMenu.FoodButton 			= Material("amenu/food.png")
aMenu.WebButton 			= Material("amenu/website.png")
aMenu.DonateButton 			= Material("amenu/donate.png")
aMenu.WorkshopButton 		= Material("amenu/workshop.png")

aMenu.ProfileButton 		= Material("amenu/profile.png")
aMenu.MessageButton 		= Material("amenu/message.png")

aMenu.PaintScroll = function(panel)
	local scr 				= panel:GetVBar()
	scr.Paint 				= function() draw.RoundedBox(4, 0, 0, scr:GetWide(), scr:GetTall(), Color(62, 62, 62)) end
	scr.btnUp.Paint 		= function() end
	scr.btnDown.Paint 		= function() end
	scr.btnGrip.Paint 		= function() draw.RoundedBox(6, 2, 0, scr.btnGrip:GetWide()-4, scr.btnGrip:GetTall()-2, aMenu.Color) end
end

--Includes
include("amenu/vgui/cl_circleavatar.lua")
include("amenu/vgui/cl_circles.lua")
include("amenu/vgui/cl_acategory.lua")
include("amenu/vgui/cl_amenubutton.lua")

include("amenu/cl_masterpanel.lua")
include("amenu/cl_dashboard.lua")
include("amenu/cl_entspanel.lua")
include("amenu/cl_jobspanel.lua")
include("amenu/cl_websites.lua")
include("amenu/cl_rules.lua")

hook.Add("InitPostEntity", "aMenuInit", function()

	aMenu.Base = nil

	function DarkRP.openF4Menu()
		aMenu.Base:Show()
		aMenu.Base.visible = true
	end

	function DarkRP.closeF4Menu()
		if aMenu.Base then
			aMenu.Base:Hide()
			aMenu.Base.visible = false
		end
	end

	function DarkRP.toggleF4Menu()
		if not aMenu.Base then
			aMenu.Base = vgui.Create("aMenuBase")
		end

		if (aMenu.Base:isVisible()) then
			DarkRP.closeF4Menu()
		else
			DarkRP.openF4Menu()
		end
	end

	GAMEMODE.ShowSpare2 = DarkRP.toggleF4Menu

	MsgC( Color(240, 173, 78), "[aMenu] ", Color(210, 210, 210), "Loaded aMenu by ", Color(240, 173, 78) ,"arie ", Color(210, 210, 210),"(STEAM_0:0:22593800)\n" )
end)