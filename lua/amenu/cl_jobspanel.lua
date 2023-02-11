------------------ Jobs panel
local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)

	self.Num = 1

	self.Contents = {}
	self.Categories = {}
end

function PANEL:SetContents(contents)
	self.Contents = contents
	self:Populate()
end

function PANEL:Populate()
	local wide, height = ScrW()*0.8 - 220, ScrH()*0.8 - 55
	if self.Contents[1].name == team.GetName(LocalPlayer():Team()) then
		self.Selected = self.Contents[2]
	else
		self.Selected = self.Contents[1]
	end

	self.Preview = vgui.Create("DPanel", self)
	self.Preview:Dock(RIGHT)
	self.Preview:SetWide((wide*0.33) - 15) --thank mr scrollbar
	self.Preview.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 41, 41, 255))
		draw.RoundedBox(4, 5, 5, w-10, height*0.4, Color(65, 65, 65 , 255))
	end

	self.Preview.Model = vgui.Create("DModelPanel", self.Preview)
	self.Preview.Model:Dock(TOP)
	self.Preview.Model:SetSize(self.Preview:GetWide(), height*0.4)
	self.Preview.Model:SetCamPos(Vector(55, 45, 55))
	self.Preview.Model:SetFOV(70)
	self.Preview.Model.OnCursorEntered 	= function() return end
	self.Preview.Model.OnCursorExited 	= function() return end	
	self.Preview.Model.DoClick 			= function() return end
	self.Preview.Model.LayoutEntity 	= function(ent)	ent:RunAnimation() end

	self.Preview.Title = vgui.Create("DLabel", self.Preview)
	self.Preview.Title:Dock(TOP)
	self.Preview.Title:DockMargin(5, 12, 5, 5)
	self.Preview.Title:SetTall(32)
	self.Preview.Title:SetFont("aMenuJob")
	self.Preview.Title:SetContentAlignment(8)
	self.Preview.Title.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(65, 65, 65, 255))
		draw.RoundedBox(2, 4, h-4, w-8, 2, aMenu.Color)
	end
	self.Preview.Title.PerformLayout = function()
		self.Preview.Title:SetText(self.Selected.name)
	end

	self.Preview.Description = vgui.Create("DScrollPanel", self.Preview)
	self.Preview.Description:Dock(TOP)
	self.Preview.Description:DockMargin(5, 0, 5, 5)
	self.Preview.Description:SetTall(height*0.4)
	self.Preview.Description.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(65, 65, 65, 255))
	end

	self.Preview.Description.Text = vgui.Create("DLabel", self.Preview.Description)
	self.Preview.Description.Text:Dock(TOP)
	self.Preview.Description.Text:DockMargin(5, 5, 5, 5)
	self.Preview.Description.Text:SetTall(height*0.4)
	self.Preview.Description.Text:SetFont("aMenu18")
	self.Preview.Description.Text:SetWrap(true)
	self.Preview.Description.Text:SetContentAlignment(8)
	self.Preview.Description.Text.PerformLayout = function()
		local text = ""

		if self.Selected.weapons and self.Selected.weapons[1] and aMenu.DisplayWeapons then
			--functions for getting the weapon names from the job table from the original DarkRP F4 menu
			local getWepName = fn.FOr{fn.FAnd{weapons.Get, fn.Compose{fn.Curry(fn.GetValue, 2)("PrintName"), weapons.Get}}, fn.Id}
			local getWeaponNames = fn.Curry(fn.Map, 2)(getWepName)
			local weaponString = fn.Compose{fn.Curry(fn.Flip(table.concat), 2)("\n"), fn.Curry(fn.Seq, 2)(table.sort), getWeaponNames, table.Copy}

			self.Preview.Description.Text:SetText(self.Selected.description .. "\n\n Additional Equipment: \n" .. weaponString(self.Selected.weapons))
		else
			self.Preview.Description.Text:SetText(self.Selected.description)
		end

		self.Preview.Description:SizeToContents()
	end

	self.Preview.Control = vgui.Create("DPanel", self.Preview)
	self.Preview.Control:Dock(FILL)
	self.Preview.Control:DockMargin(5, 0, 5, 5)
	self.Preview.Control.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(65, 65, 65, 255))
	end

	self.Preview.Control.Left = vgui.Create("aMenuButton", self.Preview.Control)
	self.Preview.Control.Left:Dock(LEFT)
	self.Preview.Control.Left.Text = "<"
	self.Preview.Control.Left:DockMargin(5, 5, 5, 5)
	self.Preview.Control.Left:SetWide(self.Preview:GetWide()*0.15 - 10)
	self.Preview.Control.Left.DoClick = function()
		self.Num = self.Num - 1
		if self.Num < 1 then self.Num = 1 end
		if self.Num == #self.Selected.model then return end
		self.Preview.Model:SetModel(self.Selected.model[self.Num])
		self.Preview.Model:InvalidateLayout()
	end

	self.Preview.Control.Click = vgui.Create("aMenuButton", self.Preview.Control)
	self.Preview.Control.Click:Dock(LEFT)
	self.Preview.Control.Click:DockMargin(0, 5, 0, 5)
	self.Preview.Control.Click:SetWide(self.Preview:GetWide()*0.7 - 10)
	self.Preview.Control.Click.DoClick = function()
		DarkRP.setPreferredJobModel(self.Selected.team, self.Preview.Model:GetModel())
		print(self.Selected.RequiresVote)
		if self.Selected.vote or self.Selected.RequiresVote(LocalPlayer()) then
			RunConsoleCommand("darkrp", "vote"..self.Selected.command)
		else
			RunConsoleCommand("darkrp", self.Selected.command)
		end
		
		DarkRP.closeF4Menu()
	end

	self.Preview.Control.Right = vgui.Create("aMenuButton", self.Preview.Control)
	self.Preview.Control.Right:Dock(LEFT)
	self.Preview.Control.Right.Text = ">"
	self.Preview.Control.Right:DockMargin(5, 5, 5, 5)
	self.Preview.Control.Right:SetWide(self.Preview:GetWide()*0.15 - 10)
	self.Preview.Control.Right.DoClick = function()
		if self.Num == #self.Selected.model then return end
		self.Num = self.Num + 1
		self.Preview.Model:SetModel(self.Selected.model[self.Num])
		self.Preview.Model:InvalidateLayout()
	end

	self.Preview.Model.PerformLayout = function() --Putting this shit down here because I hate docking
		if istable(self.Selected.model) then
			self.Preview.Model:SetModel(self.Selected.model[self.Num])
		else
			self.Preview.Model:SetModel(self.Selected.model)
		end	

		if aMenu.PreviewThemeColour then
			self.Preview.Model.Entity.GetPlayerColor = function() --and putting this in here to stop shit breaking
				return Vector(aMenu.Color.r/255, aMenu.Color.g/255, aMenu.Color.b/255) 
			end
		end

		if self.Selected.vote == true or (self.Selected.RequiresVote and self.Selected.RequiresVote(LocalPlayer())) then
			self.Preview.Control.Click.Text = "Create vote"
			self.Preview.Control.Click.DoClick = function()
				DarkRP.setPreferredJobModel(self.Selected.team, self.Preview.Model:GetModel())
				RunConsoleCommand("darkrp", "vote"..self.Selected.command)
				DarkRP.closeF4Menu()
			end
		else
			self.Preview.Control.Click.Text = "Become job"
			self.Preview.Control.Click.DoClick = function()
				DarkRP.setPreferredJobModel(self.Selected.team, self.Preview.Model:GetModel())
				RunConsoleCommand("darkrp", self.Selected.command)
				DarkRP.closeF4Menu()
			end
		end

		self.Preview.Control.Right.Disabled = true
		self.Preview.Control.Left.Disabled 	= true
		if istable(self.Selected.model) then
			if #self.Selected.model != 1 then
				self.Preview.Control.Right.Disabled = false
				self.Preview.Control.Left.Disabled 	= false
			end
		end
	end

	self.List = vgui.Create("DScrollPanel", self)
	self.List:Dock(FILL)
	self.List:SetWide(self:GetWide()*0.66)
	self.List.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(62, 62, 62, 255))
	end
	aMenu.PaintScroll(self.List)

	for k, v in pairs(self.Contents) do

		if v.name == team.GetName(LocalPlayer():Team()) then continue end

		if v.NeedToChangeFrom then
			if type(v.NeedToChangeFrom) == "number" then
				if v.NeedToChangeFrom != LocalPlayer():Team() then continue end
			elseif type(v.NeedToChangeFrom) == "table" then
				local found = false
				for _, e in pairs(v.NeedToChangeFrom) do
					if e == LocalPlayer():Team() then 
						found = true 
					end
				end

				if not found then 
					continue 
				end
			end
		end

		if not aMenu.ShowVIP then
			if v.customCheck and not v.customCheck(LocalPlayer()) then
				continue
			end
		end
		--if v.customCheck then if not v.customCheck(LocalPlayer()) then continue end end


		local category
		if v.category then
			category = self:CreateNewCategory(v.category, self.List)
		else
			category = self:CreateNewCategory("Unassigned", self.List)
		end

		v.Bar = vgui.Create("DPanel", category)
		v.Bar.Max = v.max
		v.Bar.Cur = #team.GetPlayers(v.team)
		v.Bar.BackAlpha = 0

		if v.Bar.Max == 0 then v.Bar.Max = "∞" end
		local todraw = math.Min(v.Bar.Cur / v.max, 1)

		v.Bar.Paint = function(this, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41, 255))
			draw.RoundedBox(4, 0, 0, w, h, Color(aMenu.Color.r,aMenu.Color.g, aMenu.Color.b, v.Bar.BackAlpha))

			surface.SetFont("aMenuSubTitle")

			local sw, sh = surface.GetTextSize(string.upper(v.name))

			draw.SimpleText(v.name, "aMenuSubTitle", 70, 1, Color(210, 210, 210), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
			draw.RoundedBox(2, 70, 25, sw + 10, 2, aMenu.Color)
		
			draw.RoundedBox(4, w-65, h/2-30, 60, 60, aMenu.Color)
			draw.SimpleText(DarkRP.formatMoney(v.salary), "aMenuSubTitle", w-35, h/2, Color(210, 210, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
			draw.RoundedBox(4, 5, 5, 60, 60, Color(62, 62, 62, 255))

			draw.RoundedBox(4, 70, h-27, w-140, 22, Color(62, 62, 62, 255))
			if v.Bar.Cur != 0 then
				draw.RoundedBox(4, 72, h-25, (w-144) * todraw, 18, aMenu.Color)
			end
			draw.SimpleText(v.Bar.Cur .. "/" .. v.Bar.Max, "aMenu19", w/2, h-17, Color(210, 210, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


		end

		v.Bar.Model = vgui.Create("DModelPanel", v.Bar)
		v.Bar.Model.LayoutEntity = function() return end
		if istable(v.model) then 
			v.Bar.Model:SetModel(v.model[1])
		else
			v.Bar.Model:SetModel(v.model)
		end
		v.Bar.Model:SetPos(5, 5)
		v.Bar.Model:SetSize(60, 60)
		v.Bar.Model:SetFOV(37)
		v.Bar.Model:SetCamPos(Vector(25, -7, 65))
		v.Bar.Model:SetLookAt(Vector(0, 0, 65))
		v.Bar.Model.PaintOver = function(this, w, h)
			if LevelSystemConfiguration and v.level then 
				if v.level > LocalPlayer():getDarkRPVar("level") then
					draw.RoundedBox(2, 0, h-10, w, 10, aMenu.LevelDenyColor)
				else	
					draw.RoundedBox(2, 0, h-10, w, 10, aMenu.LevelAcceptColor)
				end				
				draw.SimpleText(v.level, "aMenu14", w/2, h-6, Color(210, 210, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		if IsValid(v.Bar.Model.Entity) then
			v.Bar.Model.Entity.GetPlayerColor = function()
				return Vector(aMenu.Color.r/255, aMenu.Color.g/255, aMenu.Color.b/255) 
			end
		end

		v.Bar.Button = vgui.Create("DButton", v.Bar)
		v.Bar.Button:Dock(FILL)
		v.Bar.Button:SetText("")
		v.Bar.Button.Paint = function() end
		v.Bar.Button.DoClick = function()
			self.Selected = v
			self.Num = 1
			self.Preview.Model:InvalidateLayout()
		end
		v.Bar.Button.DoDoubleClick = function()
			self.Preview.Control.Click.DoClick()
		end

		category:AddChild(v.Bar)
	end
end

function PANEL:CreateNewCategory(Name, parent)

	for k, v in pairs(self.Categories) do
		if v:GetName() == Name then
			return v
		end
	end

	category = vgui.Create("aMenuCategory", parent)
	category:SetName(Name)

	table.insert(self.Categories, category)

	if aMenu.SortOrder then 
		for k, v in pairs(self.Categories) do
			for i, _ in pairs (DarkRP.getCategories().jobs) do
				if v.Name == _.name then
					v.sortOrder = _.sortOrder
				end		
			end
		end

		--table.SortByMember(self.Categories, "sortOrder", true)
		table.sort(self.Categories, function(a, b)
			if a and a.sortOrder then
				if b and b.sortOrder then
					return a.sortOrder < b.sortOrder 
				end
			end
			return false
		end)

		local n = vgui.Create("DPanel", self)
		for k, v in ipairs(self.Categories) do
			v:SetParent(n)
		end

		for k, v in ipairs(self.Categories) do
			v:SetParent(self.List)
			v:Dock(TOP)
		end

		n:Remove()
	end

	return category
end

vgui.Register("aMenuContainer", PANEL, "DPanel")