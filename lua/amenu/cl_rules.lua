------------------ Rules page
local PANEL = {}

function PANEL:Init()
	self.Type 		= 0
	self.Rules 		= ""
	self:Dock(FILL)
	self:DockPadding(5, 5, 5, 5)

	self.RichText = vgui.Create("RichText", self)
	self.RichText:Dock(FILL)
	self.RichText:InsertColorChange(210, 210, 210, 255)

	self:GetRules()
end

function PANEL:GetRules()
	if aMenu.UseLink then
		http.Fetch(aMenu.RulesLink,
			function(body, len, headers, code)
				if self.Rules then
					self.Rules = body
					self.RichText:AppendText(self.Rules)
					self:InvalidateLayout()				
				end
			end,
			function(error)
				MsgC(Color(240, 173, 78), "[aMenu] ", Color(210, 210, 210), "Failed to get online rules, reverting to config set.\n")
				self.Rules = aMenu.Rules
				self.RichText:AppendText(self.Rules)
				self:InvalidateLayout()
			end
		)
	else
		self.Rules = aMenu.Rules
		self.RichText:AppendText(self.Rules)
		self:InvalidateLayout()
	end
end

function PANEL:PerformLayout()
		self.RichText:SetFontInternal("aMenu22")
		--self.RichText:SetFGColor(Color(255, 255, 255))
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(41, 41, 41, 255))
end

vgui.Register("aMenuRules", PANEL, "DPanel")