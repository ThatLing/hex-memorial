
----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------
include('shared.lua')

SWEP.QuadTable = {}
SWEP.QuadTable.w = surface.ScreenWidth()
SWEP.QuadTable.h = surface.ScreenHeight()
SWEP.QuadTable.x = 0
SWEP.QuadTable.y = 0

if SWEP.QuadTable.w > SWEP.QuadTable.h then
	SWEP.QuadTable.x = (SWEP.QuadTable.w - SWEP.QuadTable.h) * .5
	SWEP.QuadTable.w = SWEP.QuadTable.h
--[[else //Tablet PC anyone?
	SWEP.QuadTable.y = (SWEP.QuadTable.h - SWEP.QuadTable.w) * .5
	SWEP.QuadTable.h = SWEP.QuadTable.w]]
else
	return
end

//if surface.ScreenWidth() > surface.ScreenHeight() then
	SWEP.ScopeTable = {}
	SWEP.ScopeTable.x = SWEP.QuadTable.h * .25 + SWEP.QuadTable.x
	SWEP.ScopeTable.y = SWEP.QuadTable.h * .25
	SWEP.ScopeTable.w = SWEP.QuadTable.w * .5
	SWEP.ScopeTable.h = SWEP.QuadTable.h * .5
--[[else //I don't know of anyone who plays on a tablet pc...
	SWEP.ScopeTable = {}
	SWEP.ScopeTable.x = SWEP.QuadTable.w * .25
	SWEP.ScopeTable.y = SWEP.QuadTable.y * 3
	SWEP.ScopeTable.w = SWEP.QuadTable.w * .5
	SWEP.ScopeTable.h = SWEP.QuadTable.h * .5]]
//end

SWEP.ModeDisp = {}
SWEP.ModeDisp.x = surface.ScreenWidth() * .9125
SWEP.ModeDisp.y = surface.ScreenHeight() * .9125

--"Only monitors with greater width than height are supported...

function SWEP:DrawHUD()
	cse_drawing = true
	if not self.lasta then
		self.lasta = {}
		self.lastp = {}
	end
	--[[
		if not self.Owner:GetInfo("cl_ax") then
			CreateClientConVar("cl_ax",self.IronSightsAng.x,true,true)
		end
		if self.lasta.x then
			if self.lasta.x ~= self.Owner:GetInfo("cl_ax") then
				self.IronSightsAng.x = tonumber(self.Owner:GetInfo("cl_ax"))
			end
		end
		self.lasta.x = self.Owner:GetInfo("cl_ax")
		if not self.Owner:GetInfo("cl_ay") then
			CreateClientConVar("cl_ay",self.IronSightsAng.y,true,true)
		end
		if self.lasta.y then
			if self.lasta.y ~= self.Owner:GetInfo("cl_ay") then
				self.IronSightsAng.y = tonumber(self.Owner:GetInfo("cl_ay"))
			end
		end
		self.lasta.y = self.Owner:GetInfo("cl_ay")
		if not self.Owner:GetInfo("cl_az") then
			CreateClientConVar("cl_az",self.IronSightsAng.z,true,true)
		end
		if self.lasta.z then
			if self.lasta.z ~= self.Owner:GetInfo("cl_az") then
				self.IronSightsAng.z = tonumber(self.Owner:GetInfo("cl_az"))
			end
		end
		self.lasta.z = self.Owner:GetInfo("cl_az")
		if not self.Owner:GetInfo("cl_px") then
			CreateClientConVar("cl_px",self.IronSightsPos.x,true,true)
		end
		if self.lasta.x then
			if self.lasta.x ~= self.Owner:GetInfo("cl_px") then
				self.IronSightsPos.x = tonumber(self.Owner:GetInfo("cl_px"))
			end
		end
		self.lasta.x = self.Owner:GetInfo("cl_px")
		if not self.Owner:GetInfo("cl_py") then
			CreateClientConVar("cl_py",self.IronSightsPos.y,true,true)
		end
		if self.lasta.y then
			if self.lasta.y ~= self.Owner:GetInfo("cl_py") then
				self.IronSightsPos.y = tonumber(self.Owner:GetInfo("cl_py"))
			end
		end
		self.lasta.y = self.Owner:GetInfo("cl_py")
		if not self.Owner:GetInfo("cl_pz") then
			CreateClientConVar("cl_pz",self.IronSightsPos.z,true,true)
		end
		if self.lasta.z then
			if self.lasta.z ~= self.Owner:GetInfo("cl_pz") then
				self.IronSightsPos.z = tonumber(self.Owner:GetInfo("cl_pz"))
			end
		end
		self.lasta.z = self.Owner:GetInfo("cl_pz")
	--]]
	
	if game.SinglePlayer() then
		self.xhair.loss = self:GetNetworkedInt("csefl")
	end
	if not self.xhair.colorstr then
		self.xhair.colorstr = self.Owner:GetInfo("cl_crosshair_color")
		if self.xhair.colorstr then
			self.xhair.color = self.string_explode(" ", self.xhair.colorstr)
			self.xhair.color = Color(self.xhair.color[1], self.xhair.color[2], self.xhair.color[3], self.xhair.color[4])
		else
			self.xhair.color = Color(0,255,0,100)
			self.xhair.colorstr = "0 255 0 100"
			CreateClientConVar("cl_crosshair_color","0 255 0 100",true,true)
		end
	elseif self.Owner:GetInfo("cl_crosshair_color") ~= self.xhair.colorstr then
		self.xhair.colorstr = self.Owner:GetInfo("cl_crosshair_color")
		self.xhair.color = string.Explode(" ", self.xhair.colorstr)
		self.xhair.color = Color(self.xhair.color[1], self.xhair.color[2], self.xhair.color[3], self.xhair.color[4])
	end
	if self.Owner:GetFOV() ~= 90 and self.data.scope then
		//Hide the viewmodel
		local fov = 10 + (90 - self.Owner:GetFOV())
		if self.ViewModelFOV == 82 then
			self.ViewModelFOV = fov
		elseif self.ViewModelFOV ~= fov then
			self.ViewModelFOV = fov
		end
		
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0,0,self.QuadTable.x,self.QuadTable.h)
		surface.DrawRect(surface.ScreenWidth() - self.QuadTable.x,0,self.QuadTable.x,self.QuadTable.h)
		
		surface.SetTexture(surface.GetTextureID("gui/sniper_corner"))
		surface.DrawTexturedRectRotated(self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,0)
		surface.DrawTexturedRectRotated(self.ScopeTable.x,surface.ScreenHeight() - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,90)
		surface.DrawTexturedRectRotated(surface.ScreenWidth() - self.ScopeTable.x,surface.ScreenHeight() - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,180)
		surface.DrawTexturedRectRotated(surface.ScreenWidth() - self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,270)
	elseif self.ViewModelFOV ~= 82 then
		self.ViewModelFOV = 82
	end
	
	local mode = self:GetNetworkedInt("csef")
	if mode == 1 then
		self.mode = "auto"
	elseif mode == 2 then
		self.mode = "burst"
	elseif mode == 3 then
		self.mode = "semi"
	end
	surface.SetFont("Trebuchet24")
	surface.SetTextPos(self.ModeDisp.x,self.ModeDisp.y)
	surface.SetTextColor(255,220,0,100)
	if cse_drawfiremode == nil or cse_drawfiremode(self.data[self.mode].label) then
		surface.DrawText(self.data[self.mode].label)
	end
	
	if cse_drawcrosshair == nil or cse_drawcrosshair(self.xhair.loss) then
		surface.SetDrawColor(self.xhair.color.r,self.xhair.color.g,self.xhair.color.b,self.xhair.color.a)
		surface.DrawRect(self.xhair.cx + self.xhair.dist + self.xhair.loss * 4,self.xhair.cy + self.xhair.amp,self.xhair.len,self.xhair.wid)
		surface.DrawRect(self.xhair.cx - self.xhair.dist - self.xhair.loss * 4 - self.xhair.len,self.xhair.cy + self.xhair.amp,self.xhair.len,self.xhair.wid)
		surface.DrawRect(self.xhair.cx + self.xhair.amp,self.xhair.cy + self.xhair.dist + self.xhair.loss * 4,self.xhair.wid,self.xhair.len)
		surface.DrawRect(self.xhair.cx + self.xhair.amp,self.xhair.cy - self.xhair.dist - self.xhair.loss * 4 - self.xhair.len,self.xhair.wid,self.xhair.len)
	end
	
	if self.xhair.loss > 0 then
		self.xhair.loss = self.xhair.loss - (self.Primary.Unrecoil * (os.clock() - self.xhair.time))
		if self.Owner:Crouching() then
			self.xhair.loss = self.xhair.loss * .975
		end
	elseif self.xhair.loss < 0 then
		self.xhair.loss = 0
	end
	if self.xhair.loss > 20 then
		self.xhair.loss = 20
	end
	if !self.Owner:IsOnGround() then
		self.xhair.loss = 20
	end
	self.xhair.time = os.clock()
	if cse_drawpost then
		cse_drawpost()
	end
end

SWEP.xhair = {}
SWEP.xhair.cx = surface.ScreenWidth() * .5
SWEP.xhair.cy = surface.ScreenHeight() * .5
SWEP.xhair.len = surface.ScreenHeight() * .015
SWEP.xhair.wid = surface.ScreenHeight() * .004
SWEP.xhair.dist = surface.ScreenWidth() * .005
SWEP.xhair.amp = SWEP.xhair.wid * -.5
SWEP.xhair.loss = 0
SWEP.xhair.time = os.clock()
SWEP.string_explode = string.Explode
--[[
SWEP.xhair.colorstr = SWEP.Owner:GetInfo("cl_crosshair_color")
if SWEP.xhair.colorstr then
	SWEP.xhair.color = string.explode(" ", SWEP.xhair.color)
	SWEP.xhair.color = Color(SWEP.xhair.color[1], SWEP.xhair.color[2], SWEP.xhair.color[3], SWEP.xhair.color[4])
else
	SWEP.xhair.color = Color(0,255,0,100)
	SWEP.xhair.colorstr = "0 255 0 100"
	CreateClientConVar("cl_crosshair_color","0 255 0 100",true,true)
end]]

function SWEP:PrintWeaponInfo( x, y, alpha )
	//if ( self.DrawWeaponInfoBox == false ) then return end

	if (self.InfoMarkup == nil ) then
		local str
		local title_color = "<color=230,230,230,255>"
		local text_color = "<color=150,150,150,255>"
		
		str = "<font=HudSelectionText>"
		if ( self.Author != "" ) then str = str .. title_color .. "Author:</color>\t"..text_color..self.Author.."</color>\n" end
		if ( self.Contact != "" ) then str = str .. title_color .. "Contact:</color>\t"..text_color..self.Contact.."</color>\n\n" end
		if ( self.Purpose != "" ) then str = str .. title_color .. "Purpose:</color>\n"..text_color..self.Purpose.."</color>\n\n" end
		if ( self.Instructions != "" ) then str = str .. title_color .. "Instructions:</color>\n"..text_color..self.Instructions.."</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse( str, 250 )
	end
	
	surface.SetDrawColor( 60, 60, 60, alpha )
	surface.SetTexture( self.SpeechBubbleLid )
	
	surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 ) 
	draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )
	
	self.InfoMarkup:Draw( x+5, y+5, nil, nil, alpha )
	
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	// try to fool them into thinking they're playing a Tony Hawks game
	//draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-14, 14), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	//draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-9, 9), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end

----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------
include('shared.lua')

SWEP.QuadTable = {}
SWEP.QuadTable.w = surface.ScreenWidth()
SWEP.QuadTable.h = surface.ScreenHeight()
SWEP.QuadTable.x = 0
SWEP.QuadTable.y = 0

if SWEP.QuadTable.w > SWEP.QuadTable.h then
	SWEP.QuadTable.x = (SWEP.QuadTable.w - SWEP.QuadTable.h) * .5
	SWEP.QuadTable.w = SWEP.QuadTable.h
--[[else //Tablet PC anyone?
	SWEP.QuadTable.y = (SWEP.QuadTable.h - SWEP.QuadTable.w) * .5
	SWEP.QuadTable.h = SWEP.QuadTable.w]]
else
	return
end

//if surface.ScreenWidth() > surface.ScreenHeight() then
	SWEP.ScopeTable = {}
	SWEP.ScopeTable.x = SWEP.QuadTable.h * .25 + SWEP.QuadTable.x
	SWEP.ScopeTable.y = SWEP.QuadTable.h * .25
	SWEP.ScopeTable.w = SWEP.QuadTable.w * .5
	SWEP.ScopeTable.h = SWEP.QuadTable.h * .5
--[[else //I don't know of anyone who plays on a tablet pc...
	SWEP.ScopeTable = {}
	SWEP.ScopeTable.x = SWEP.QuadTable.w * .25
	SWEP.ScopeTable.y = SWEP.QuadTable.y * 3
	SWEP.ScopeTable.w = SWEP.QuadTable.w * .5
	SWEP.ScopeTable.h = SWEP.QuadTable.h * .5]]
//end

SWEP.ModeDisp = {}
SWEP.ModeDisp.x = surface.ScreenWidth() * .9125
SWEP.ModeDisp.y = surface.ScreenHeight() * .9125

--"Only monitors with greater width than height are supported...

function SWEP:DrawHUD()
	cse_drawing = true
	if not self.lasta then
		self.lasta = {}
		self.lastp = {}
	end
	--[[
		if not self.Owner:GetInfo("cl_ax") then
			CreateClientConVar("cl_ax",self.IronSightsAng.x,true,true)
		end
		if self.lasta.x then
			if self.lasta.x ~= self.Owner:GetInfo("cl_ax") then
				self.IronSightsAng.x = tonumber(self.Owner:GetInfo("cl_ax"))
			end
		end
		self.lasta.x = self.Owner:GetInfo("cl_ax")
		if not self.Owner:GetInfo("cl_ay") then
			CreateClientConVar("cl_ay",self.IronSightsAng.y,true,true)
		end
		if self.lasta.y then
			if self.lasta.y ~= self.Owner:GetInfo("cl_ay") then
				self.IronSightsAng.y = tonumber(self.Owner:GetInfo("cl_ay"))
			end
		end
		self.lasta.y = self.Owner:GetInfo("cl_ay")
		if not self.Owner:GetInfo("cl_az") then
			CreateClientConVar("cl_az",self.IronSightsAng.z,true,true)
		end
		if self.lasta.z then
			if self.lasta.z ~= self.Owner:GetInfo("cl_az") then
				self.IronSightsAng.z = tonumber(self.Owner:GetInfo("cl_az"))
			end
		end
		self.lasta.z = self.Owner:GetInfo("cl_az")
		if not self.Owner:GetInfo("cl_px") then
			CreateClientConVar("cl_px",self.IronSightsPos.x,true,true)
		end
		if self.lasta.x then
			if self.lasta.x ~= self.Owner:GetInfo("cl_px") then
				self.IronSightsPos.x = tonumber(self.Owner:GetInfo("cl_px"))
			end
		end
		self.lasta.x = self.Owner:GetInfo("cl_px")
		if not self.Owner:GetInfo("cl_py") then
			CreateClientConVar("cl_py",self.IronSightsPos.y,true,true)
		end
		if self.lasta.y then
			if self.lasta.y ~= self.Owner:GetInfo("cl_py") then
				self.IronSightsPos.y = tonumber(self.Owner:GetInfo("cl_py"))
			end
		end
		self.lasta.y = self.Owner:GetInfo("cl_py")
		if not self.Owner:GetInfo("cl_pz") then
			CreateClientConVar("cl_pz",self.IronSightsPos.z,true,true)
		end
		if self.lasta.z then
			if self.lasta.z ~= self.Owner:GetInfo("cl_pz") then
				self.IronSightsPos.z = tonumber(self.Owner:GetInfo("cl_pz"))
			end
		end
		self.lasta.z = self.Owner:GetInfo("cl_pz")
	--]]
	
	if game.SinglePlayer() then
		self.xhair.loss = self:GetNetworkedInt("csefl")
	end
	if not self.xhair.colorstr then
		self.xhair.colorstr = self.Owner:GetInfo("cl_crosshair_color")
		if self.xhair.colorstr then
			self.xhair.color = self.string_explode(" ", self.xhair.colorstr)
			self.xhair.color = Color(self.xhair.color[1], self.xhair.color[2], self.xhair.color[3], self.xhair.color[4])
		else
			self.xhair.color = Color(0,255,0,100)
			self.xhair.colorstr = "0 255 0 100"
			CreateClientConVar("cl_crosshair_color","0 255 0 100",true,true)
		end
	elseif self.Owner:GetInfo("cl_crosshair_color") ~= self.xhair.colorstr then
		self.xhair.colorstr = self.Owner:GetInfo("cl_crosshair_color")
		self.xhair.color = string.Explode(" ", self.xhair.colorstr)
		self.xhair.color = Color(self.xhair.color[1], self.xhair.color[2], self.xhair.color[3], self.xhair.color[4])
	end
	if self.Owner:GetFOV() ~= 90 and self.data.scope then
		//Hide the viewmodel
		local fov = 10 + (90 - self.Owner:GetFOV())
		if self.ViewModelFOV == 82 then
			self.ViewModelFOV = fov
		elseif self.ViewModelFOV ~= fov then
			self.ViewModelFOV = fov
		end
		
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0,0,self.QuadTable.x,self.QuadTable.h)
		surface.DrawRect(surface.ScreenWidth() - self.QuadTable.x,0,self.QuadTable.x,self.QuadTable.h)
		
		surface.SetTexture(surface.GetTextureID("gui/sniper_corner"))
		surface.DrawTexturedRectRotated(self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,0)
		surface.DrawTexturedRectRotated(self.ScopeTable.x,surface.ScreenHeight() - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,90)
		surface.DrawTexturedRectRotated(surface.ScreenWidth() - self.ScopeTable.x,surface.ScreenHeight() - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,180)
		surface.DrawTexturedRectRotated(surface.ScreenWidth() - self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,270)
	elseif self.ViewModelFOV ~= 82 then
		self.ViewModelFOV = 82
	end
	
	local mode = self:GetNetworkedInt("csef")
	if mode == 1 then
		self.mode = "auto"
	elseif mode == 2 then
		self.mode = "burst"
	elseif mode == 3 then
		self.mode = "semi"
	end
	surface.SetFont("Trebuchet24")
	surface.SetTextPos(self.ModeDisp.x,self.ModeDisp.y)
	surface.SetTextColor(255,220,0,100)
	if cse_drawfiremode == nil or cse_drawfiremode(self.data[self.mode].label) then
		surface.DrawText(self.data[self.mode].label)
	end
	
	if cse_drawcrosshair == nil or cse_drawcrosshair(self.xhair.loss) then
		surface.SetDrawColor(self.xhair.color.r,self.xhair.color.g,self.xhair.color.b,self.xhair.color.a)
		surface.DrawRect(self.xhair.cx + self.xhair.dist + self.xhair.loss * 4,self.xhair.cy + self.xhair.amp,self.xhair.len,self.xhair.wid)
		surface.DrawRect(self.xhair.cx - self.xhair.dist - self.xhair.loss * 4 - self.xhair.len,self.xhair.cy + self.xhair.amp,self.xhair.len,self.xhair.wid)
		surface.DrawRect(self.xhair.cx + self.xhair.amp,self.xhair.cy + self.xhair.dist + self.xhair.loss * 4,self.xhair.wid,self.xhair.len)
		surface.DrawRect(self.xhair.cx + self.xhair.amp,self.xhair.cy - self.xhair.dist - self.xhair.loss * 4 - self.xhair.len,self.xhair.wid,self.xhair.len)
	end
	
	if self.xhair.loss > 0 then
		self.xhair.loss = self.xhair.loss - (self.Primary.Unrecoil * (os.clock() - self.xhair.time))
		if self.Owner:Crouching() then
			self.xhair.loss = self.xhair.loss * .975
		end
	elseif self.xhair.loss < 0 then
		self.xhair.loss = 0
	end
	if self.xhair.loss > 20 then
		self.xhair.loss = 20
	end
	if !self.Owner:IsOnGround() then
		self.xhair.loss = 20
	end
	self.xhair.time = os.clock()
	if cse_drawpost then
		cse_drawpost()
	end
end

SWEP.xhair = {}
SWEP.xhair.cx = surface.ScreenWidth() * .5
SWEP.xhair.cy = surface.ScreenHeight() * .5
SWEP.xhair.len = surface.ScreenHeight() * .015
SWEP.xhair.wid = surface.ScreenHeight() * .004
SWEP.xhair.dist = surface.ScreenWidth() * .005
SWEP.xhair.amp = SWEP.xhair.wid * -.5
SWEP.xhair.loss = 0
SWEP.xhair.time = os.clock()
SWEP.string_explode = string.Explode
--[[
SWEP.xhair.colorstr = SWEP.Owner:GetInfo("cl_crosshair_color")
if SWEP.xhair.colorstr then
	SWEP.xhair.color = string.explode(" ", SWEP.xhair.color)
	SWEP.xhair.color = Color(SWEP.xhair.color[1], SWEP.xhair.color[2], SWEP.xhair.color[3], SWEP.xhair.color[4])
else
	SWEP.xhair.color = Color(0,255,0,100)
	SWEP.xhair.colorstr = "0 255 0 100"
	CreateClientConVar("cl_crosshair_color","0 255 0 100",true,true)
end]]

function SWEP:PrintWeaponInfo( x, y, alpha )
	//if ( self.DrawWeaponInfoBox == false ) then return end

	if (self.InfoMarkup == nil ) then
		local str
		local title_color = "<color=230,230,230,255>"
		local text_color = "<color=150,150,150,255>"
		
		str = "<font=HudSelectionText>"
		if ( self.Author != "" ) then str = str .. title_color .. "Author:</color>\t"..text_color..self.Author.."</color>\n" end
		if ( self.Contact != "" ) then str = str .. title_color .. "Contact:</color>\t"..text_color..self.Contact.."</color>\n\n" end
		if ( self.Purpose != "" ) then str = str .. title_color .. "Purpose:</color>\n"..text_color..self.Purpose.."</color>\n\n" end
		if ( self.Instructions != "" ) then str = str .. title_color .. "Instructions:</color>\n"..text_color..self.Instructions.."</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse( str, 250 )
	end
	
	surface.SetDrawColor( 60, 60, 60, alpha )
	surface.SetTexture( self.SpeechBubbleLid )
	
	surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 ) 
	draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )
	
	self.InfoMarkup:Draw( x+5, y+5, nil, nil, alpha )
	
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	// try to fool them into thinking they're playing a Tony Hawks game
	//draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-14, 14), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	//draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-9, 9), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end
