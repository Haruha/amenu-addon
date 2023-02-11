------------------- Custom DButton
local PANEL = {}

function PANEL:Init()
	self.Text 		= self:GetText()
	self.Col 		= aMenu.Color
	self.Disabled 	= false

	self:SetText("")
end

function PANEL:Paint(w, h)
	if self.Disabled then
		draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41))
		draw.SimpleText(self.Text, "aMenu22", w/2, h/2, Color(120, 120, 120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
	else
		draw.RoundedBox(4, 0, 0, w, h, self.Col)
		if self:IsHovered() then
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 20))
		end
		draw.SimpleText(self.Text, "aMenu22", w/2, h/2, Color(255, 253, 252), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
	end
end

vgui.Register("aMenuButton", PANEL, "DButton")