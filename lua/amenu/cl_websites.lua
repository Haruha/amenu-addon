------------------ Website link page
local PANEL = {}

function PANEL:Init()
	self.Type 		= 0
	self.IsSitePage = true
	self.Link 		= ""

	self:Dock(FILL)
end

function PANEL:OpenPage()
	gui.OpenURL(self.Link)
end

function PANEL:SetLink(link)
	self.Link = link
end

vgui.Register("aMenuWebBase", PANEL, "DPanel")