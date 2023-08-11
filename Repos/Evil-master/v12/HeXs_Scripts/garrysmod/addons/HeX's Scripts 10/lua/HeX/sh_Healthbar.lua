
if CLIENT then
	surface.CreateFont("coolvetica", 30, 80, true, false, "HealthFont" )
	surface.CreateFont("coolvetica", 22, 50, true, false, "HealthNumberFont")
	
	local function HealthBar()
		local trace = util.TraceLine( utilx.GetPlayerTrace(LocalPlayer(), LocalPlayer():GetCursorAimVector() ) )
		
		local LookingHealth		= LocalPlayer():GetNWInt("LookingHealth")
		local LookingMaxHealth	= LocalPlayer():GetNWInt("LookingMaxHealth")
		
		if (!trace.Hit) then return end
		if (!trace.HitNonWorld) then return end
		
		local x,y = gui.MousePos()
		draw.SimpleText(trace.Entity:GetClass(), "HealthFont", x+100, y + 20, Color(255,255,255,255),1,1) 
		
		if LookingHealth != 0 && LookingMaxHealth >= LookingHealth then
			surface.SetDrawColor( 255,255,255,255 ) --255,0,0,255
			surface.DrawRect( x + 20, y + 40, 150, 15 )
			surface.SetDrawColor( 0,255,0,255 )
			surface.DrawRect( x + 20, y + 40, (LookingHealth / LookingMaxHealth * 150), 15 )
			surface.SetDrawColor( 0,0,0,255 )
			surface.DrawRect( x + 16, y + 40, 4, 15 )
			surface.DrawRect( x + 170, y + 40, 5, 15 )
			surface.DrawRect( x + 16, y + 36, 159, 4 )
			surface.DrawRect( x + 16, y + 55, 159, 4 )
			surface.DrawRect( x + 15, y + 42, 1, 13 )
			surface.DrawRect( x + 175, y + 42, 1, 13 )
			surface.DrawRect( x + 14, y + 44, 1, 9 )
			surface.DrawRect( x + 176, y + 44, 1, 9 )
			draw.SimpleText(LookingHealth.. "/" .. LookingMaxHealth, "HealthNumberFont", x + 90, y + 49, Color(255,0,0,255),1,1) 
			
		elseif LookingHealth != 0 && LookingMaxHealth <= LookingHealth then
			surface.SetDrawColor( 255,255,255,255 ) --255,0,0,255
			surface.DrawRect( x + 20, y + 40, 150, 15 )
			surface.SetDrawColor( 0,255,0,255 )
			surface.DrawRect( x + 20, y + 40, 150, 15 )
			draw.SimpleText(LookingHealth.. "/" .. LookingMaxHealth, "HealthNumberFont", x + 90, y + 49, Color(255,0,0,255),1,1)
		end

	end
	hook.Add("HUDPaint", "HealthBar", HealthBar)
end


if (SERVER) then
	local function HealthBarGetHealth()  
		for k,v in pairs( player.GetAll() ) do
			if ValidEntity(v) then
				local trace = util.TraceLine( utilx.GetPlayerTrace(v, v:GetCursorAimVector() ) )
				
				if (!trace.Hit) then return end
				if (!trace.HitNonWorld) then return end
				
				v:SetNWInt("LookingHealth", trace.Entity:Health() )
				v:SetNWInt("LookingMaxHealth", trace.Entity:GetMaxHealth() )
			end
		end
	end
	hook.Add("Think", "HealthBarGetHealth", HealthBarGetHealth)
end



