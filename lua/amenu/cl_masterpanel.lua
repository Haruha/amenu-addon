------------------- Base panel
local PANEL = {}

function PANEL:Init()
	self:SetSize(ScrW()*0.8, ScrH()*0.8)
	self:Center()
	self:MakePopup()
	self.visible = true
	self.Col = aMenu.Color
	self.Tabs = {}
	self.StartTime = SysTime()

	self.Banner = vgui.Create("DPanel", self)
	self.Banner:SetSize(self:GetParent():GetWide(), 55)
	self.Banner:Dock(TOP)
	self.Banner.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, self.Col)
		draw.SimpleText(GetHostName(), "aMenuTitle", 5, 0, Color(237, 237, 237), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.SimpleText(aMenu.SubTitle, "aMenuSubTitle", 5, 27, Color(230, 230, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
	end

	self.Close = vgui.Create("aMenuButton", self.Banner)
	self.Close:SetSize(80, 35)
	self.Close:Dock(RIGHT)
	self.Close:DockMargin(8, 8, 8, 8)
	--self.Close:SetPos(self:GetWide() - (self.Close:GetWide()+10), 10)
	self.Close.Text = "Close"
	self.Close.Col = Color(62, 62, 62, 255)
	self.Close.DoClick = function()
		DarkRP.closeF4Menu()
	end

	self.MenuBar = vgui.Create("DPanel", self)
	self.MenuBar:Dock(LEFT)
	self.MenuBar:SetWide(220)
	self.MenuBar.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 41, 41, 255))
	end

	self.MenuBar.Info = vgui.Create("DPanel", self.MenuBar)
	self.MenuBar.Info:Dock(TOP)
	self.MenuBar.Info:DockMargin(5, 5, 5, 0)
	self.MenuBar.Info:SetTall(77)
	self.MenuBar.Info.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, 72, Color(62, 62, 62))

		--draw.RoundedBox(4, 0, 77, w, 36, self.Col)
		draw.SimpleText(LocalPlayer():Nick(), "aMenuSubTitle", 80, 1, self.Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 

		draw.RoundedBox(2, 80, 28, 120, 2, self.Col)

		draw.SimpleText(LocalPlayer():getDarkRPVar("job"), "aMenu20", 80, 30, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.SimpleText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")), "aMenu20", 80, 48, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 

		--draw.SimpleText("DASHBOARD", "aMenu18", 54, 94, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) 
		--surface.SetMaterial(aMenu.HomeButton)
		--surface.SetDrawColor(220, 220, 220)
		--surface.DrawTexturedRect(20, 86, 16, 16)
	end

	self.MenuBar.Info.Avatar = vgui.Create("AvatarCircleMask", self.MenuBar.Info)
	self.MenuBar.Info.Avatar:SetPlayer(LocalPlayer(), 64)
	self.MenuBar.Info.Avatar:SetPos(4, 4)
	self.MenuBar.Info.Avatar:SetSize(64, 64)
	self.MenuBar.Info.Avatar:SetMaskSize(64 / 2)

	self.MenuBar.List = vgui.Create("DPanel", self.MenuBar)
	self.MenuBar.List:Dock(FILL)
	self.MenuBar.List:DockMargin(5, 0, 5, 5)
	self.MenuBar.List.Paint = function(this, w, h) end

	self.Dashboard = vgui.Create("aMenuDashboard", self)
	self.Tab = 1

	self.Jobs = vgui.Create("aMenuContainer", self)
	self.Jobs:SetContents(RPExtraTeams)

	self.Ents = vgui.Create("aMenuEntBase", self)
	self.Ents:SetContents(DarkRPEntities, 1)

	self.Weapons = vgui.Create("aMenuEntBase", self)
	self.Weapons:SetContents(CustomShipments, 2)

	self.Shipments = vgui.Create("aMenuEntBase", self)
	self.Shipments:SetContents(CustomShipments, 3)

	self.Ammo = vgui.Create("aMenuEntBase", self)
	self.Ammo:SetContents(GAMEMODE.AmmoTypes, 4)



	self.Rules = vgui.Create("aMenuRules", self)

	self:AddCat("Dashboard", aMenu.HomeButton, self.Dashboard)
	self:AddCat("Jobs", aMenu.JobsButton, self.Jobs)
	self:AddCat("Entities", aMenu.EntitiesButton, self.Ents)
	self:AddCat("Weapons", aMenu.WeaponsButton, self.Weapons)
	self:AddCat("Shipments", aMenu.ShipmentsButton, self.Shipments)
	self:AddCat("Ammo", aMenu.AmmoButton, self.Ammo)

	if not DarkRP.disabledDefaults["modules"]["hungermod"] then
		self.Food = vgui.Create("aMenuEntBase", self)
		self.Food:SetContents(FoodItems, 5)	
		self:AddCat("Food", aMenu.FoodButton, self.Food)
	end
		
	self:AddCat("Rules", aMenu.RulesButton, self.Rules)

	if aMenu.WebsiteLink != "" then 
		self.Website = vgui.Create("aMenuWebBase", self)
		self.Website:SetLink(aMenu.WebsiteLink)
		self:AddCat("Website", aMenu.WebButton, self.Website)	
	end

	if aMenu.DonationLink != "" then 
		self.Donate = vgui.Create("aMenuWebBase", self)
		self.Donate:SetLink(aMenu.DonationLink)		
		self:AddCat("Donate", aMenu.DonateButton, self.Donate)	
	end

	if aMenu.WorkshopLink != "" then 
		self.Workshop = vgui.Create("aMenuWebBase", self)
		self.Workshop:SetLink(aMenu.WorkshopLink)		
		self:AddCat("Workshop", aMenu.WorkshopButton, self.Workshop)	
	end
	 
	for k, v in pairs(self.Tabs) do
		if v:IsValid() then
			v:SetVisible(false)
		end
	end
	if self.Jobs:IsValid() then
		self.Jobs:SetVisible(true)
		self.Tab = table.KeyFromValue(self.Tabs, self.Jobs)
	else
		self.Tabs[1]:SetVisible(true)
		self.Tab = 1
	end
end

function PANEL:AddCat(name, icon, panel)
	if not aMenu.AllowedTabs[name] or aMenu.AllowedTabs[name] == false then
		panel:Remove()
		self.Tab = 1
		return
	end

	panel.Name = name

	table.insert(self.Tabs, panel)

	local cat = vgui.Create("DButton", self.MenuBar.List)
	cat:SetSize(self:GetParent():GetWide(), 36)
	cat:DockMargin(0, 0, 0, 5)
	cat:Dock(TOP)

	cat.DoClick = function()

		if panel.IsSitePage then
			panel:OpenPage()
			return
		end

		self.Tab = table.KeyFromValue(self.Tabs, panel) 
		for k, v in pairs(self.Tabs) do
			if v:IsValid() then
				v:SetVisible(false)
			end
		end
		if panel:IsValid() then
			panel:SetVisible(true)
		end
	end
	cat:SetText("")

	cat.Paint = function(this, w, h)
		if self.Tab == table.KeyFromValue(self.Tabs, panel) then
			cat.Col = self.Col
		else
			cat.Col = Color(210, 210, 210)
		end

		if name == "Dashboard" then
			draw.RoundedBox(4, 0, 0, w, h, self.Col) 
			draw.SimpleText(string.upper(name), "aMenu18", 54, 18, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) 
			draw.SimpleText(">", "aMenu18", w-20, 18, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetMaterial(icon)
			surface.SetDrawColor(210, 210, 210)
			surface.DrawTexturedRect(20, 10, 16, 16)
		else
			draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62)) 
			draw.SimpleText(string.upper(name), "aMenu18", 54, 18, cat.Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) 
			draw.SimpleText(">", "aMenu18", w-20, 18, cat.Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
			surface.SetMaterial(icon)
			surface.SetDrawColor(cat.Col.r, cat.Col.g, cat.Col.b)
			surface.DrawTexturedRect(20, 10, 16, 16)		 
		end
	end
end

function PANEL:OnKeyCodePressed(k)
	if k == KEY_F4 then
		DarkRP.toggleF4Menu()
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62, 255))
	if aMenu.BlurBackground then
		Derma_DrawBackgroundBlur(self, self.StartTime)
	end	
end

function PANEL:isVisible() 
	return self.visible
end

vgui.Register("aMenuBase", PANEL, "EditablePanel")