
/*-------------------------------------------------*\
|  Copyright © 20XX by Roach, All rights reserved.  |
\*-------------------------------------------------*/
AddCSLuaFile()
ENT.Type 			= "anim"

ENT.Base 			= "base_gmodentity"	-- Change to "r_base_projectile"

ENT.PrintName		= "Projectile Base"	-- |
ENT.Author			= "Roach"			-- |
ENT.Spawnable			= false			-- |
ENT.AdminSpawnable		= false			-- | You can delete these four, as projectiles fired by SWEPs or NPCs generally aren't spawnable.

-- Configs --

ENT.TrailPCF = "error"					-- This is the particle effect that appears while we're travelling.
ENT.TrailSND = "common/null.wav"		-- This is the LOOPING sound effect that plays while we're travelling.
ENT.CollidePCF = ""				-- This is the particle effect that appears when we hit something.
ENT.CollideSND = {"common/null.wav"}	-- These are the sounds that play when we hit something. (You can add as many as you like, seperated by a comma.)
ENT.Damage = 0							-- How much damage we do if we hit an entity. (You can keep this at 0 and apply the damage in DealCollideEffects if you so wish.)
ENT.HasTimeout = false					-- Can we timeout?
ENT.TimeoutPeriod = 0					-- How long does it take?
ENT.MoveSpeed = 0						-- How fast do we move?

-- Configs --

function ENT:DealCollideEffects(v,att,inf) -- DealCollideEffects(entity victim, entity attacker, entity inflictor)
	ErrorNoHalt("[Projectile Base] DealCollideEffects function not overwritten!")
end
function ENT:CustomInit()end

function ENT:OnCollide(data,physobj,NoData) -- OnCollide(CollisionData data, Physics Object physobj, Boolean NoData)
	NoData = NoData or false

	if #self.CollideSND < 2 then
		self:EmitSound(self.CollideSND[1], 75, 100)
	else
		self:EmitSound(self.CollideSND[math.random(1,#self.CollideSND)], 75, 100)
	end
	ParticleEffect(self.CollidePCF,self:GetPos(),self:GetAngles(),nil)
	if !NoData then
		if IsValid(data.HitEntity) then 
			self:DealCollideEffects(data.HitEntity,OWNER,self)
			data.HitEntity:TakeDamage(self.Damage,self)
		end
		-- local _ent = ents.FindInSphere(self:GetPos(),50)
		-- for i=0,#_ent do
			-- if #_ent < 1 then break end
			-- local v = table.GetFirstValue(_ent)
			-- if (v:IsPlayer() or v:IsNPC()) then
				-- if v ~= OWNER then
					-- self:DealCollideEffects(v,OWNER,self)
				-- end
			-- end
			-- table.RemoveByValue(_ent,v)
		-- end
	end
	if IsValid(effect) then effect:Remove() end
	SafeRemoveEntity(self)
end

if CLIENT then
	function ENT:Draw()
	end
end

function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	if SERVER then self:SetMoveCollide(3)end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetHealth(1)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass(1)
		phys:EnableGravity(false)
		phys:EnableDrag(false)
	end
	
	self.cspSound = CreateSound(self, self.TrailSND)
	self.cspSound:Play()
	
	if SERVER then
		effect = ents.Create("info_particle_system")
		effect:SetKeyValue("effect_name", self.TrailPCF)
		effect:SetKeyValue("start_active", "1")
		effect:SetPos(self:GetPos())
		effect:SetParent(self)
		effect:Spawn()
		effect:Activate()
	end
	
	OWNER = self.Own
	
	if self.HasTimeout then
		timer.Simple(self.TimeoutPeriod,function()
			if IsValid(self) then
				self:OnCollide(nil,nil,true)
			end 
		end)
	end
	self:CustomInit()
end

function ENT:OnRemove()
	if SERVER then self.cspSound:Stop()end
end

function ENT:Think()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then	
		if self:GetVelocity() == Vector(0,0,0) then
			if SERVER then phys:ApplyForceCenter(self:GetForward()*self.MoveSpeed)end
		end
	end
end

function ENT:PhysicsCollide(data, physobj)
	if IsValid(data.HitEntity) then
		if string.find(data.HitEntity:GetClass(), "obj_") or string.find(data.HitEntity:GetClass(), "r_base") then return false end
	end
	self:OnCollide(data,physobj)
	return true
end

function CreateBeamParticle(pcf,pos1,pos2,ang1,ang2,parent,candie,dietime)
	if SERVER then
		local P_End = ents.Create("info_particle_system") 
		P_End:SetKeyValue("effect_name",pcf)
		P_End:SetName("info_particle_system_MajikPoint_"..pcf)
		P_End:SetPos(pos2) 
		P_End:SetAngles((ang2 or Angle(0,0,0))) 
		P_End:Spawn()
		P_End:Activate()
		P_End:SetParent(parent or nil)
		
		local P_Start = ents.Create("info_particle_system")
		P_Start:SetKeyValue("effect_name",pcf)
		P_Start:SetKeyValue("cpoint1",P_End:GetName())
		P_Start:SetKeyValue("start_active",tostring(1))
		P_Start:SetPos(pos1)
		P_Start:SetAngles((ang1 or Angle(0,0,0)))
		P_Start:Spawn()
		P_Start:Activate() 
		P_Start:SetParent(parent or nil)
		
		if candie then P_End:Fire("Kill",nil,dietime)P_Start:Fire("Kill",nil,dietime) end
	end
end 