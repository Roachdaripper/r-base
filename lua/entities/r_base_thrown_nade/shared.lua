
/*-------------------------------------------------*\
|  Copyright © 20XX by Roach, All rights reserved.  |
\*-------------------------------------------------*/
AddCSLuaFile()
ENT.Type 			= "anim"

ENT.Base 			= "base_gmodentity"		-- Change to "r_base_thrown_nade"

ENT.PrintName		= "Base Grenade Entity"	-- |
ENT.Author			= "Roach"				-- |
ENT.Spawnable			= false				-- |
ENT.AdminSpawnable		= false				-- | You can remove these four, particularly the Spawnable vars as we want the player to spawn the SWEP, not the entity.

-- Configs --
ENT.Model = ""						-- Our model.
ENT.BounceSND = {"common/null.wav"}	-- Sound(s) that play when we bounce.
ENT.DetonateType = 1 				-- 0 = explode on impact; 1 = timer; 2 = number of bounces
ENT.Fuse = 2.2 						-- Depends on DetonateType. 0 = Does nothing, 1 = Counts down in seconds, 2 = Counts down every time we bounce.
-- Configs --

function ENT:CustomInit()

end
function ENT:OnCollide(data,physobj)

end
function ENT:OnExplode()
	ErrorNoHalt("[R-Base Grenade Base] OnExplode function not overwritten!")
	SafeRemoveEntity(self)
end



-----
function ENT:Initialize()
	self:SetModel(self.Model)
	if SERVER then self:SetMoveCollide(3)end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetHealth(1)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass(0.1)
		phys:EnableGravity(true)
		phys:EnableDrag(false)
	end
	
	if self.DetonateType == 1 then
		timer.Simple(self.Fuse,function()if SERVER then self:OnExplode()end end)
	end
	self:CustomInit()
end

function ENT:OnRemove()end
function ENT:Think()
end

function ENT:PhysicsCollide(data, physobj)
	if data.Speed > 50 then
		if #self.BounceSND < 2 then
			self:EmitSound(self.BounceSND[1], 75, 100)
		else
			self:EmitSound(self.BounceSND[math.random(1,#self.BounceSND)], 75, 100)
		end
	end
		
	if self.DetonateType == 2 then
		if self.Fuse >= 1 then
			self.Fuse = self.Fuse - 1
		else
			self:OnExplode()
		end
	elseif self.DetonateType == 0 then
		self:OnExplode()
	end
	
	self:OnCollide(data,physobj)
	return true
end