
timer.Simple(1, function()
	print("! fixing nail model")
	
	scripted_ents.Register({
		Type = "anim",
		 
		Spawnable = false,
		AdminSpawnable = false,
		 
		Initialize = function(self)
			self:SetModel("models/retrobox/retro_nail_small.mdl")
		end
		},
	"gmod_nail", true)
end)

