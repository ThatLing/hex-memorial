
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
ENT.Type 		= "anim"
ENT.PrintName	= "Explosive C4"
ENT.Author		= "Worshipper"
ENT.Contact		= "Josephcadieux@hotmail.com"
ENT.Purpose		= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "Timer")
end 


function ENT:Initialize()
	self.C4CountDown = self:GetDTInt(0)
	self:CountDown()
	self:EmitSound("C4.Plant")
end


function ENT:CountDown()
	if self.C4CountDown > 1 then
		self:EmitSound("C4.PlantSound")
		
		self.C4CountDown = self.C4CountDown - 1
		
		timer.Create(tostring(self), 1, 0, function()
			self:CountDown()
		end)
	else
		self.C4CountDown = 0
		
		timer.Destroy("CountDown")
		timer.Destroy( tostring(self) )
	end
end


function ENT:OnRemove()
	timer.Destroy( tostring(self) )
end






----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
ENT.Type 		= "anim"
ENT.PrintName	= "Explosive C4"
ENT.Author		= "Worshipper"
ENT.Contact		= "Josephcadieux@hotmail.com"
ENT.Purpose		= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "Timer")
end 


function ENT:Initialize()
	self.C4CountDown = self:GetDTInt(0)
	self:CountDown()
	self:EmitSound("C4.Plant")
end


function ENT:CountDown()
	if self.C4CountDown > 1 then
		self:EmitSound("C4.PlantSound")
		
		self.C4CountDown = self.C4CountDown - 1
		
		timer.Create(tostring(self), 1, 0, function()
			self:CountDown()
		end)
	else
		self.C4CountDown = 0
		
		timer.Destroy("CountDown")
		timer.Destroy( tostring(self) )
	end
end


function ENT:OnRemove()
	timer.Destroy( tostring(self) )
end





