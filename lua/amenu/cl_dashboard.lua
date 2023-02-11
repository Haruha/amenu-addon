------------------ Dashboard showing info
local PANEL = {}
local wide, height = ScrW()*0.8 - 220, ScrH()*0.8 - 55

function PANEL:Init()

	self.Col = aMenu.Color

	self:Dock(FILL)
	self.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62, 255))
	end

	self.Admins = {}

	self.Commands = vgui.Create("DPanel", self)
	self.Commands:Dock(BOTTOM)
	self.Commands:DockMargin(5, 0, 5, 5)
	self.Commands:SetTall(height*0.55)
	self.Commands.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(31, 31, 31, 255))
	end

	self.GeneralCommands 	= {
		{name = "Drop Money", 			command = "say /dropmoney {}"},
		{name = "Drop Weapon", 			command = "say /dropweapon"},
		{name = "Give Money", 			command = "say /give {}"},
		{name = "Sell All Doors", 		command = "say /unownalldoors"},
	}
	self.RoleplayCommands 	= {
		{name = "Change Roleplay Name", command = "say /rpname {}"},
		{name = "Change Job Title", 	command = "say /job {}"},
		{name = "Request Gun License", 	command = "say /requestlicense"},
	}
	self.CivilCommands 		= {
		{name = "Search Warrant", 		command = "say /warrant {}"},
		{name = "Make Wanted", 			command = "say /wanted {}"},
		{name = "Remove Wanted", 		command = "say /unwanted {}"},
	}
	self.MayorCommands 		= {
		{name = "Start Lockdown", 		command = "say /lockdown"},
		{name = "Stop Lockdown", 		command = "say /unlockdown"},
		{name = "Add Law", 				command = "say /addlaw {}"},
		{name = "Place Lawboard", 		command = "say /placelaws"},
		{name = "Broadcast Message", 	command = "say /broadcast {}"},
	}


	self:AddClassCommands("General", 			Color(92, 184, 92), 	self.GeneralCommands)
	self:AddClassCommands("Roleplay", 			Color(91, 192, 222), 	self.RoleplayCommands)
	self:AddClassCommands("Civil Protection", 	Color(66, 139, 202), 	self.CivilCommands)
	self:AddClassCommands("Mayor", 				Color(217, 83, 79), 	self.MayorCommands)

	self.StaffList = vgui.Create("DPanel", self)
	self.StaffList:SetSize(wide/2 - 5, height/2 - 50)
	self.StaffList:Dock(LEFT)
	self.StaffList:DockMargin(5, 5, 5, 5)
	self.StaffList.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(31, 31, 31, 255))

		draw.SimpleText("Staff Online", "aMenuTitle", 12, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.RoundedBox(2, 10, 37, w-20, 2, self.Col)
	end
	self.StaffList:DockPadding(0, 0, 0, 5)	

	self.StaffList.List = vgui.Create("DScrollPanel", self.StaffList)
	self.StaffList.List:Dock(FILL)
	self.StaffList.List:DockMargin(10, 45, 10, 10)
	aMenu.PaintScroll(self.StaffList.List)

	self:UpdateStaff()

	timer.Create("aMenuStaffUpdate", 5, 0, function()
		if self:IsValid() then
			self:UpdateStaff()
		end
	end)

	self.JobsGraph = vgui.Create("DPanel", self)
	self.JobsGraph:SetSize(wide/2 - 10, height/2 - 50)
	self.JobsGraph:Dock(RIGHT)
	self.JobsGraph:DockMargin(5, 5, 5, 5)
	self.JobsGraph.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(31, 31, 31, 255))
		draw.SimpleText("Job Distribution", "aMenuTitle", 12, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.RoundedBox(2, 10, 37, w-20, 2, self.Col)
	end

	local totalJobs = {}
	local toDraw 	= {}
	local curstart 	= 0

	for k, v in pairs(player.GetAll()) do
		if team.NumPlayers(v:Team()) != 0 and not totalJobs[v:Team()] then
			totalJobs[v:Team()] = team.NumPlayers(v:Team())
		end
	end
	
	local count = 255
	for k, v in pairs(totalJobs) do
		local numsections = 360 / #player.GetAll()
		local en = (curstart + (v * numsections))
		local col = team.GetColor(k)
		table.insert(toDraw, {name = team.GetName(k), col = Color(col.r, col.g, col.b, 200), startang = curstart, endang = en})
		curstart = en
	end

	self.JobsGraph.Graph = vgui.Create("DPanel", self.JobsGraph)
	self.JobsGraph.Graph:Dock(LEFT)
	self.JobsGraph.Graph:DockMargin(10, 45, 5, 10)
	self.JobsGraph.Graph:SetWide((self.JobsGraph:GetTall()*0.3)*2 + 70)
	self.JobsGraph.Graph.Paint = function(this, w, h)

		local radius = math.min(h*0.4, w*0.4)
		local thickness = radius/2
		local roughness = 0
		local clockwise = true

		draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62))				
		draw.NoTexture() --fuck you, you elusive bastard

		draw.Arc(w/2, h/2, radius+15, thickness+radius+15, 0, 360, roughness, Color(41, 41, 41), clockwise)

		--draw.Arc(w/2, h/2, radius, thickness+radius, 0, 360, roughness, Color(240, 240, 240, 100), clockwise)

		for k, v in pairs(toDraw) do
			draw.Arc(w/2, h/2, radius, thickness*2, v.startang, v.endang, roughness, v.col, clockwise)
		end
		draw.Arc(w/2, h/2, radius-10, thickness*2-10, 0, 360, roughness, Color(100, 100, 100, 20), clockwise)
	end

	self.JobsGraph.Info = vgui.Create("DScrollPanel", self.JobsGraph)
	self.JobsGraph.Info:Dock(FILL)
	self.JobsGraph.Info:DockMargin(5, 45, 10, 10)
	self.JobsGraph.Info.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(62, 62, 62))
	end
	aMenu.PaintScroll(self.JobsGraph.Info)

	for k, v in pairs(totalJobs) do
		local base = vgui.Create("DPanel", self.JobsGraph.Info)
		base:Dock(TOP)
		base:DockMargin(5, 3, 5, 3)
		base.Paint = function(this, w, h)
			if aMenu.ChartFullColour then
				draw.RoundedBox(4, 0, 0, w, h, team.GetColor(k))
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 40))
			else
				draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
				draw.RoundedBox(4, 5, 5, 14, 14, team.GetColor(k))				
			end
		end

		base.lbl = vgui.Create("DLabel", base)

		base.lbl.PerformLayout = function()
			base.lbl:SetAutoStretchVertical(true)
			base.lbl:SetText(team.GetName(k) .. " \nPlayers: " .. v)
			base.lbl:SizeToContentsY()
			base:SizeToChildren(false, true)
			base:SetTall(base:GetTall() + 3)
		end

		base.lbl:Dock(FILL)
		if aMenu.ChartFullColour then
			base.lbl:DockMargin(3, 2, 2, 2)
		else
			base.lbl:DockMargin(23, 2, 2, 2)
		end		
		
		base.lbl:SetFont("aMenu19")
		base.lbl.Paint = function(this, w, h)
			--draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
		end
	end

end

function PANEL:UpdateStaff()

	for k, v in pairs(self.Admins) do
		v:Remove() --Get rid of the old panels
	end

	table.Empty(self.Admins) --Get rid of those nulls

	for k, v in pairs(player.GetAll()) do --Start over
		if v:IsValid() and aMenu.StaffGroups[v:GetUserGroup()] then
			v.Base = vgui.Create("DPanel", self.StaffList.List)
			v.Base:Dock(TOP)
			v.Base:DockMargin(0, 0, 5, 5)
			v.Base:SetTall(54)

			surface.SetFont("aMenuJob")
			local pw, ph = surface.GetTextSize(v:Nick())
			local str = aMenu.StaffGroups[v:GetUserGroup()]

			v.Base.Paint = function(this, w, h)
				draw.RoundedBox(4, 0, 0, w, h, Color(65, 65, 65, 255))
				draw.SimpleText(v:Nick(), "aMenuJob", 60, 1, self.Col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 

				draw.RoundedBox(2, 60, 28, pw + 10, 2, self.Col)

				draw.SimpleText(str, "aMenu20", 60, 30, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
			end

			v.Base.Avatar = vgui.Create("AvatarCircleMask", v.Base)
			v.Base.Avatar:SetPlayer(v, 64)
			v.Base.Avatar:SetPos(4, 4)
			v.Base.Avatar:SetSize(46, 46)
			v.Base.Avatar:SetMaskSize(46 / 2)

			v.Base.Button = vgui.Create("DButton", v.Base)
			v.Base.Button:Dock(FILL)
			v.Base.Button:SetText("")
			v.Base.Button.Paint = function() end
			v.Base.Button.DoClick = function()
				local menu = DermaMenu(v.Base.Button)
				menu.HelpButton = menu:AddOption("Request Assistance", function() RunConsoleCommand("say", "/// Admin assistance required please.") end)
				menu:AddOption("Steam Profile", function() v:ShowProfile()  end)
				menu:Open()

				menu.Paint = function() end
				menu.PaintOver = function(this, w, h)
					draw.RoundedBox(2, 0, 0, w, h, Color(41, 41, 41, 255))
					for k, v in pairs(this:GetCanvas():GetChildren()) do
						local x, y = v:GetPos()
						if v.Hovered then
							draw.RoundedBox(2, x+2, y+2, w-4, 18, aMenu.Color)
						end
						draw.SimpleText(v:GetText(), "aMenu19", x+21, y+1, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						if v:GetText() == "Steam Profile" then
							surface.SetMaterial(aMenu.ProfileButton)
						else
							surface.SetMaterial(aMenu.MessageButton)
						end
						
						surface.SetDrawColor(210, 210, 210)
						surface.DrawTexturedRect(3, y+3, 16, 16)
					end
				end
			end
			table.insert(self.Admins, v.Base)
		end
	end
end

function PANEL:AddClassCommands(name, colour, content)

	local base = vgui.Create("DPanel", self.Commands)
	base:SetWide(wide/4 - 9)	
	base:Dock(LEFT)
	base:DockMargin(5, 5, 0, 5)
	base:DockPadding(5, 40, 5, 5)
	base.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
		draw.SimpleText(name, "aMenuTitle", 12, 4, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.RoundedBox(2, 10, 37, w-20, 2, colour)
	end

	for k, v in pairs(content) do
		local b = vgui.Create("aMenuButton", base)
		b:Dock(TOP)
		b:SetTall(math.min(self.Commands:GetTall()/#content, 40))
		b:DockMargin(5, 5, 5, 5)
		b.Text = v.name
		b.Col = colour
		b.DoClick = function()
			local cmd = v.command
			if string.EndsWith(cmd, "{}") then
				Derma_StringRequest(
					"aMenu string request",
					"Input",
					"",
					function(text) LocalPlayer():ConCommand(string.Replace(cmd, "{}", text)) end,
					function(text) print("Cancelled input") end)
				
			else
				LocalPlayer():ConCommand(cmd)
			end			
		end
	end
end

vgui.Register("aMenuDashboard", PANEL, "DPanel")