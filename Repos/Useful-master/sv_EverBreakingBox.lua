/*
	=== Everbreaking Boxes ===
	--By HeX
	Every crate spawned produces two copies when it gets removed!
*/

EBox = {
	Enabled 	= CreateConVar("eb_enabled", 	1, 		FCVAR_CLIENTDLL, "Should Everbreaking Boxes exist?"),
	MaxTotal	= CreateConVar("eb_max", 		200, 	FCVAR_CLIENTDLL, "Max total Everbreaking Boxes on the map"),
	
	Color		= Color(200,200,80),
	GoodProps 	= {
		["models/props_junk/wood_crate001a.mdl"] 						= 1,
		["models/props_junk/wood_crate001a_damaged.mdl"] 				= 1,
		["models/props_junk/wood_crate002a.mdl"] 						= 1,
		["models/items/item_item_crate.mdl"] 							= 1,
		["models/props_junk/wood_crate001a_damagedmax.mdl"] 			= 1,
		["models/props_lab/dogobject_wood_crate001a_damagedmax.mdl"] 	= 1, --Best one
	}
}


function EBox.Spawn(self, mdl, Box)
	if not EBox.Enabled:GetBool() or not EBox.GoodProps[ mdl:lower() ] then return end
	
	//Safe remove
	if self:KeyDown(IN_WALK) then
		self:EmitSound("buttons/button11.wav")
		
		for k,v in pairs( ents.FindByClass("prop_physics") ) do
			if v.EBox_Owner then
				v.EBox_Owner = nil
				
				v:RemoveCallOnRemove("EverbreakingBox")
				v:Remove()
			end
		end
		
		Box:Remove()
		return
	end
	
	Box.EBox_Owner = self
	Box:SetColor(EBox.Color)
	
	//On remove
	Box:CallOnRemove("EverbreakingBox", function(Box)
		//Too many!
		local Tot = 0
		for k,v in pairs( ents.FindByClass("prop_physics") ) do
			if v.EBox_Owner then
				Tot = Tot + 1
			end
		end
		if Tot > EBox.MaxTotal:GetInt() then return end
		
		
		//Make two new ones
		local Mdl	= Box:GetModel()
		local Pos 	= Box:GetPos()
		local Ang	= Box:GetAngles()
		local self 	= Box.EBox_Owner
		
		timer.Simple(0.5, function()
			if not IsValid(self) then return end
			
			for i=1,2 do
				local New = ents.Create("prop_physics")
					New:SetModel(Mdl)
					New:SetPos(Pos)
					New:SetAngles(Ang)
					New.EBox_Owner = self
				New:Spawn()
				
				//Sound
				--New:EmitSound("buttons/button14.wav")
				New:EmitSound("npc/roller/remote_yes.wav", 500, 100)
				
				//Recursive!
				EBox.Spawn(self, Mdl, New)
			end
		end)
	end)
end
hook.Add("PlayerSpawnedProp", "EBox.Spawn", EBox.Spawn)




























