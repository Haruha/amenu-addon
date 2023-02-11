------------------ Categories
local PANEL = {}

function PANEL:Init()
	self.Name 		= ""
	self.Children 	= {}
	self.Col 		= aMenu.Color

	self:Dock(TOP)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 5, 5, self:GetParent():GetWide()-7, h-5, Color(31, 31, 31, 255))
	draw.SimpleText(self.Name, "aMenuTitle", 10, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	draw.RoundedBox(2, 10, 37, self:GetParent():GetWide()-20, 2, self.Col)
end

function PANEL:GetName()
	return self.Name
end

function PANEL:SetName(str)
	self.Name = str
end

function PANEL:AddChild(child)
	if not ValidPanel(child) then return end
	child:SetParent(self)
	table.insert(self.Children, child)
end

function PANEL:PerformLayout()
	local wide = (self:GetParent():GetWide()-15)

	local BarW, BarH = (wide/2)-6, 70
	local countx, county = 10, 45

	for k, v in pairs(self.Children) do --I guess it's kinda like text-wrapping but with vgui right?
		if countx >= wide then 
			countx = 10
			county = county + BarH + 5
		end

		v:SetPos(countx, county)
		v:SetSize(BarW, BarH)

		countx = countx + BarW + 5
	end
	self:SizeToChildren(false, true)
	self:SetTall(self:GetTall() + 5)
end

vgui.Register("aMenuCategory", PANEL, "DPanel")

--bork'd collapsible categories
--[[
------------------ Categories
local PANEL = {}

function PANEL:Init()
	self.Name 		= ""
	self.Children 	= {}
	self.Col 		= aMenu.Color

	self.First = false

	self:Dock(TOP)
	

	self.Button = vgui.Create("DButton", self)
	self.Button:Dock(TOP)
	self.Button:SetTall(40)
	self.Button.DoClick = function() self:Toggle() end
	self.Button:SetText("")
	self.Button.Paint = function(this, w, h) end

	self.Open = true
	self.Tall = 40
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 5, 5, self:GetParent():GetWide()-7, h-5, Color(31, 31, 31, 255))
	draw.SimpleText(self.Name, "aMenuTitle", 10, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	draw.RoundedBox(2, 10, 37, self:GetParent():GetWide()-20, 2, self.Col)
end

function PANEL:GetName()
	return self.Name
end

function PANEL:SetName(str)
	self.Name = str
end

function PANEL:AddChild(child)
	if not ValidPanel(child) then return end
	child:SetParent(self)
	table.insert(self.Children, child)
end

function PANEL:PerformLayout()
	if self.First then 
		self:SizeToChildren(false, true)
		self.First = false 
	end
	local wide = ((ScrW()*0.8 - 220)*0.66)

	local BarW, BarH = (wide/2) - 5, 70
	local countx, county = 10, 45

	for k, v in pairs(self.Children) do --I guess it's kinda like text-wrapping but with vgui right?
		if countx >= wide then 
			countx = 10
			county = county + BarH + 5
		end

		v:SetPos(countx, county)
		v:SetSize(BarW, BarH)

		countx = countx + BarW + 5
		self.Tall = county
	end
	self:SizeToChildren(false, true)

end


function PANEL:Toggle()
	if self.Open then
		self:SizeTo(self:GetWide(), 40, 0.3, 0)
		self.Open = false
	else
		self:SizeTo(self:GetWide(), self.Tall + 75, 0.3, 0)
		self.Open = true
	end
	self:InvalidateLayout()
end

vgui.Register("aMenuCategory", PANEL, "DPanel")--]]
--[[
local PANEL = {}

function PANEL:Init()
	self.Name 		= ""
	self.Children 	= {}
	self.Col 		= aMenu.Color

	self:Dock(TOP)

	self.Tall = 40

	self.Button = vgui.Create("DButton", self)
	self.Button:Dock(TOP)
	self.Button:SetTall(40)
	self.Button.DoClick = function() self:Toggle() end
	self.Button:SetText("")
	--self.Button.Paint = function(this, w, h) end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 5, 5, self:GetParent():GetWide()-7, h-5, Color(31, 31, 31, 255))
	draw.SimpleText(self.Name, "aMenuTitle", 10, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	draw.RoundedBox(2, 10, 37, self:GetParent():GetWide()-20, 2, self.Col)
end

function PANEL:GetName()
	return self.Name
end

function PANEL:SetName(str)
	self.Name = str
end

function PANEL:AddChild(child)
	if not ValidPanel(child) then return end
	child:SetParent(self)
	table.insert(self.Children, child)

	local wide = ((ScrW()*0.8 - 220) * 0.66) --oh god why

	local BarW, BarH = (wide/2)-6, 70
	local countx, county = 10, 45

	for k, v in pairs(self.Children) do --I guess it's kinda like text-wrapping but with vgui right?
		if countx >= wide then 
			countx = 10
			county = county + BarH + 5
		end

		v:SetPos(countx, county)
		v:SetSize(BarW, BarH)

		countx = countx + BarW + 5

		self.Tall = county
	end
	self:SizeToChildren(false, true)
	self:SetTall(self:GetTall() + 5)	
end

function PANEL:Toggle()
	if self.Open then
		self:SizeTo(self:GetWide(), 40, 0.3, 0)
		self.Open = false
	else
		self:SizeTo(self:GetWide(), self.Tall + 75, 0.3, 0)
		self.Open = true
	end
	--self:InvalidateLayout()
end

--function PANEL:PerformLayout()

--end

vgui.Register("aMenuCategory", PANEL, "DPanel")
--]]