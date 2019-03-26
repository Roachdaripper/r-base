
/*-----------------------------------------------------------------------------------------------------------*\
|							 ___________________________________________________ 							  |
|							/                                                   \							  |
|							|  Copyright © 2017 by Roach, All rights reserved.  |							  |
|							\___________________________________________________/ 							  |
|						This base assumes that you know basic lua. It will not teach						  |
|					you how to make Nextbots. With that said, most of the variables have					  |
|							comments on them to explain them a bit more in-depth.							  |
|										Have fun creating Nextbots!											  |
|																											  |
\*-----------------------------------------------------------------------------------------------------------*/

if (SERVER) then AddCSLuaFile("shared.lua")end				-- Don't touch.
ENT.Type = "nextbot"
----------------------------------------------
ENT.Base     = "base_nextbot"								-- Change "base_nextbot" to "r_base_basic".
ENT.Spawnable= false										-- Leave this at false. Nextbots need to be manually shunted over to the NPC category.

-- list.Set("NPC", "replace_this_with_the_filename_of_your_nextbot", {
	-- Name = "Basic Nextbot",
	-- Class = "replace_this_with_the_filename_of_your_nextbot",
	-- Category = "Other"
-- })	
if CLIENT then
	language.Add("replace_this_with_the_filename_of_your_nextbot","Basic Nextbot")
end


-- Essentials --
ENT.Model = ""												-- Our model.
ENT.health = 0												-- Our health.
ENT.WalkSpeed = 100
ENT.RunSpeed = 200												-- How fast we move.

-- Immunities --
ENT.ImmuneToCombineBalls = false							-- Do we take damage from Combine Balls?
ENT.ResistantToCombineBalls = false							-- Can we survive more than one Combine Ball?
ENT.CombineBallDamage = ENT.health/2						-- How much damage do we take from Combine Balls? (Can either be a number or a calculation as shown.)
ENT.ImmuneToElectricity = false 							-- Do we take damage from electrical attacks?
ENT.ImmuneToFire = false									-- Do we ignite/take damage from fire?
ENT.ImmuneToIce = false										-- Do we freeze/take damage from ice?
ENT.CanDrown = true											-- Can we drown?
ENT.BreathTime = 30											-- How long can we hold our breath for while underwater?

//-- Darksouls specific functions
ENT.IsBoss = false											-- Are we a boss? (Skips shield/parry code and changes strafing code)

ENT.HasShield = false										-- Do we have a shield?
ENT.HasEstus = false										-- Do we have Estus?
ENT.NumEstus = 3											-- How many estus sips can we have? (Ignored if HasEstus is false)
ENT.CanClimbLadders = true									-- Can we climb ladders? (Up only so far)

ENT.Stamina = 100
ENT.CollisionRadius = 50 -- How big is the sphere that covers us?

ENT.Equipment = {
	Weapon = {
		Damage = 30,
		Dmgtype = DMG_SLASH, -- Replace with poison, radiation, or acid for any of those types of damage, DMG_SONIC could be divine?
		Parryable = true, -- Can we /be/ parried?
	},
	Shield = {
		Stability = 100, -- stability/100, higher stability = less stamina usage when taking a hit.
		PoisonDEF = 0, -- Additional Resistance to POISON when shield is raised.
		ToxicDEF = 0, -- Additional Resistance to TOXIC when shield is raised.
		BleedDEF = 0, -- Additional Resistance to BLEED when shield is raised.
		Parry = false, -- Can we parry?
	}
}

ENT.Animations = {
	Idle = "",
	Walk = {
		F = "", -- The four directions we can move in, Forward, Back, Left, Right
		B = "",
		L = "",
		R = "",
		F_P = "", -- Parry state, leave blank if we can't parry
		L_P = "",
		R_P = "",
		F_S = "", -- Shield state, leave blank if we can't shield
		B_S = "",
		L_S = "",
		R_S = "",
	},
	Run = "",
	Flinch = {
		Default = {""}, -- You can put more than one animation here and it'll randomly select between animations.
		Blast= "", -- Explosion-specific flinch, leave blank to use default.
	},
	Ladder = {
		Mount = "",
		ClimbUp = "",
		ClimbDown = "",
		Dismount = "",
		Death = "",
	},
	Dodge = {
		F = "", -- The four directions we can move in, Forward, Back, Left, Right
		B = "", -- Leave blank if one or more directions can't be moved in for lack of animations.
		L = "",
		R = "",
	},
	Glide="", -- Animation we use if we fall off a ledge and are in the air.
	Land="", -- Ditto for when we land.
	
	Parry={
		To = "", -- Animation we play when entering a parry state.
		Parry = "", -- If we successfully parry?
		Riposte = "", -- And our follow up critical strike.
		From = "", -- Animation for leaving a parry state.
		
		Parried="", -- We just got parried, bummer.
		Riposted="", -- Oof, and we got riposted too.
	},
	Shield={
		To = "", -- Animation we play when entering a shield state.
		From = "", -- Animation for leaving a shield state.
		
		Hit = "", -- When we block a hit.
		BigHit = "", -- When we block a big hit.
	},
	Estus = {
		To = "", -- When we attempt to drink estus. Leave blank if we can't drink estus.
		Drink = "", -- sippies 4 lief m8
		Empty = "", -- wtf sippies empty m8
	},
}
ENT.AttackRangeVeryFar = 600 -- This is the range at which an enemy would firebomb, throwing knife, etc.
ENT.AttackRangeFar = 450
ENT.AttackRangeMedium = 300
ENT.AttackRangeClose = 150

ENT.MaxStrafes = 15 -- When we're walking, how many times can we change direction before deciding to attack again?
ENT.DodgeChance = 0 -- How likely are we to dodge (%)?
//-- Darksouls specific functions

function ENT:CustomInit()end
function ENT:OnSpawn()end
function ENT:CustomThink()end
function ENT:CustomIdle()end
function ENT:CustomKilled(dmginfo)end
function ENT:CustomInjured(dmginfo)end
function ENT:CustomElementalInjured(dmgtype,attacker)end
function ENT:CustomOnDrowning(dmginfo)end
function ENT:CustomOnRemove()end
function ENT:CustomRunBehaviour()end
function ENT:CustomOnDissolve() -- Use for gibbing or etc.
end
function ENT:CustomSetupDataTables() end

function ENT:CustomOnClimbLadder()end
function ENT:CustomOnEndClimbLadder()end

function ENT:CustomWithinAttackRange(range,target) end

function ENT:OnParryUp() end
function ENT:OnParryDown() end
function ENT:OnShieldUp() end
function ENT:OnShieldDown() end

function ENT:OnParry() end
function ENT:OnRiposteStart() end
function ENT:OnRiposteStab() end
function ENT:OnRiposteKick() end

function ENT:OnDodge() end

function ENT:OnStartDrinkEstus()end
function ENT:OnDrinkEstus()end
function ENT:OnEndDrinkEstus()end
function ENT:OnEstusEmpty()end
--[[---------------------------------------------------------------------------------------]]--
function ENT:Initialize()
	self.Interval = self.FootStepInterval 
	self.Entity:SetCollisionBounds(Vector(-4,-4,0), Vector(4,4,64))
	self:SetHealth(self.health)
	self.Entity:SetModel(self.Model)
	self.LoseTargetDist	= 250000000 
	self.SearchRadius 	= 999000000 
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	if SERVER then 
		self.loco:SetStepHeight(35)
		self.loco:SetAcceleration(900)
		self.loco:SetDeceleration(900)
		self:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)
	end 
	self.nextbot = true 
	
	self:InitStates()
	//-- ds
		self.CurrentState = DS_STATE_IDLE -- This forms the entire foundation of the NPC, as everything will rely on what state we're in.
		self.Stam = self.Stamina
		self.NextRegen = CurTime() + 0.1
	//-- ds
	
	self:SetRB_DebugHealth(self:Health())
	self:SetRB_DebugStamina(self.Stamina)
	self:SetRB_DebugState("SPAWNING")
	self:CustomInit()
end
function ENT:InitStates()
	DS_STATE_IDLE = 0000
	DS_STATE_ESTUSING = 0001
	DS_STATE_SHIELDING = 0002
	DS_STATE_PARRYING = 0003
	DS_STATE_RIPOSTING = 0004
	DS_STATE_PARRIED = 0005
	
	DS_STATE_WANDERING = 0200
	DS_STATE_CHASINGENEMY = 0500
	DS_STATE_DEAD = 2200
	DS_STATE_ATTACKING = 3000
	DS_STATE_LADDER = 7000
	
	DS_STATE_OVERRIDE = 9000 -- Pretty much a state specifically for when we're playing contextual animations, like pre-aggro.
	
	self.OverrideAnim = ""
	
	DS_RANGE_VERYFAR = 3019 -- Ranges for attacking code
	DS_RANGE_FAR = 3011
	DS_RANGE_MED = 3012
	DS_RANGE_LOW = 3013
end

function ENT:SetGodMode(b)
	self.IsGodded = tobool(b)
end
function ENT:GetGodMode()
	return self.IsGodded
end
function ENT:GetState()return self.CurrentState end
function ENT:SetState(state)
	local tblstates = {
		[0000] = true,
		[0001] = true,
		[0002] = true,
		[0003] = true,
		[0004] = true,
		[0005] = true,
		[0200] = true,
		[0500] = true,
		[2200] = true,
		[3000] = true, 
		[7000] = true,
		[9000] = true
	} -- All valid states
		if !tblstates[state] then
			Error("! ERROR !\nAttempted to set an invalid state!")
		return end -- I think Error() inherrently returns, but I'm adding this in anyway.
		
	self:SetRB_DebugState(
		(state == 0000 and "IDLE") or (state == 0001 and "DRINKING ESTUS") or (state == 0002 and "SHIELDING") or 
		(state == 0003 and "PARRYING") or (state == 0004 and "RIPOSTING") or (state == 0005 and "PARRIED") or 
		(state == 0200 and "WANDERING") or (state == 0500 and "CHASING") or (state == 2200 and "DEAD") or 
		(state == 3000 and "ATTACKING") or (state == 7000 and "CLIMBING") or (state == 9000 and "ANIMATION OVERRIDE") or "NIL"
	)
	self.CurrentState = state
end

function ENT:BodyUpdate()self:BodyMoveXY()end
function ENT:GetEnemy()return self.Enemy end
function ENT:SetEnemy(ent)self.Enemy = ent end

function ENT:HaveEnemy()
	if (self:GetEnemy() and IsValid(self:GetEnemy())) then 
		if (self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist or 99000) then 
			return self:FindEnemy()
		elseif ((self:GetEnemy():IsPlayer() and !self:GetEnemy():Alive()) or (self:GetEnemy():IsNPC() and !string.find(self:GetEnemy():GetClass(), "bullseye"))) then 
			return self:FindEnemy()
		end 
		return true 
	else 
		return self:FindEnemy()
	end 
end
function ENT:FindEnemy()
	if GetConVarNumber("ai_disabled") == 1 then return end
	local _ents = ents.FindInSphere(self:GetPos(), self.SearchRadius or 9000)
		for k,v in pairs(_ents) do 
			if (GetConVarNumber("ai_ignoreplayers") == 1) then 
				if (v:IsScripted()) and v.Base == "r_base_darksouls" then
					if v == self then continue end
					self:SetEnemy(v)
					return true
				end
			else
				if (v:IsPlayer() and v:Alive()) then 
					self:SetEnemy(v)
					return true 
				elseif (v:IsScripted()) and v.Base == "r_base_darksouls" then
					if v == self then continue end
					self:SetEnemy(v)
					return true
				end
			end
		end 
	self:SetEnemy(nil)
	return false 
end
function ENT:Think()
	if !IsValid(self) then return end 
	self:CustomThink()
	
	if (IsValid(self)) and self.Stam < self.Stamina then
		if CurTime() < self.NextRegen then return end
			if self.Stam >= self.Stamina then
				self.Stam = self.Stamina
			else
				self.Stam = self.Stam + 1
			end
			self:SetRB_DebugStamina(self.Stam)
		self.NextRegen = CurTime() + 0.1
	end

	if tobool(self.CanDrown) then
		if self:WaterLevel() >= 3 then
			timer.Simple(self.BreathTime,function()
				if !IsValid(self) then return end
				if self:WaterLevel() <= 2 then return end
				
				local d = DamageInfo()
				d:SetAttacker(self)
				d:SetDamage(1)
				d:SetDamageType(DMG_DROWN)
				
				self:TakeDamageInfo(d)
			end)
		end
	end
end

function ENT:SpawnIn()
	if !SERVER then return end
	local nav = navmesh.GetNearestNavArea(self:GetPos())
	if !self:IsInWorld() or !IsValid(nav) or nav:GetClosestPointOnArea(self:GetPos()):DistToSqr(self:GetPos()) >= 10000 then 
		-- ErrorNoHalt("Nextbot ["..self:GetClass().."]["..self:EntIndex().."] spawned too far away from a navmesh!")
		for k,v in pairs(player.GetAll()) do
			if (string.find(v:GetUserGroup(),"admin")) then
				v:PrintMessage(HUD_PRINTTALK,"Nextbot ["..self:GetClass().."]["..self:EntIndex().."] spawned too far away from a navmesh!")
			end
		end
		SafeRemoveEntity(self)
	end 
	self:OnSpawn()
end

function ENT:OnRemove()
	self:CustomOnRemove()
end
function ENT:OnKilled(dmginfo)
	if self:GetState() == DS_STATE_LADDER then
		self.WasClimbingWhenDead = true
	end
	self:SetState(DS_STATE_DEAD)
	
	if dmginfo:IsDamageType(DMG_DISSOLVE) then
		self:HandleDissolving(dmginfo)
	else
		self:CustomKilled(dmginfo)
	end
	if !file.Exists("autorun/slvbase","LUA") then -- Hopefully should fix conflictions against SLVBase. HOPEFULLY.
		if file.Exists("autorun/bgo_autorun_sh","LUA") then return end -- BGO has a bone to pick with R-Base too it seems.
		hook.Run("OnNPCKilled",self,dmginfo:GetAttacker(),dmginfo:GetInflictor())
	end
	self:SetRB_DebugHealth(0)
end
function ENT:HandleDissolving(dmginfo)
	self:CustomOnDissolve()
	for i=1,math.random(2,10) do
		ParticleEffectAttach("rbase_dissolve",PATTACH_ABSORIGIN_FOLLOW,self,0)
	end
	SafeRemoveEntityDelayed(self,0.2)
end
function ENT:OnInjured(dmginfo)
	local att = dmginfo:GetAttacker()
	if (!self:HaveEnemy() and (att:IsNPC() or att:IsPlayer())) then self:SetEnemy(att)self:HandleMove() end
	
	if self:GetGodMode() == true then dmginfo:ScaleDamage(0)dmginfo:SetDamage(0) return end
	
	if self:GetState() == DS_STATE_PARRYING then
		self:SetState(DS_STATE_RIPOSTING)
		if self:GetRangeTo(att:GetPos()) <= self.AttackRangeClose then
			self:OnParry()
			if att:IsPlayer() then att:Freeze(true) end
			if self:GetIsRBaseNPC(att) then 
				att:SetState(DS_STATE_PARRIED) 
				att.loco:SetDesiredSpeed(0) 
				att.OverrideAnim = att.Animations.Parry.Parried
			end
			self.OverrideAnimRate = 1.5
			self.OverrideAnim = self.Animations.Parry.Parry
			self.OverrideAnimRate = 1
			self:ResetSequence(self.Animations.Idle)
			self:Helper_SafeTimer(1,function()
				self:HandleRiposte(att)
			end)
		end
		dmginfo:ScaleDamage(0)
		return
	end
	
	dmginfo:ScaleDamage(1)
	self:SetRB_DebugHealth(self:Health())
	if (dmginfo:IsDamageType(DMG_BURN) and !tobool(self.ImmuneToFire)) then self:CustomElementalInjured(DMG_BURN,dmginfo:GetAttacker()) else
		if (dmginfo:IsDamageType(DMG_SHOCK) and !tobool(self.ImmuneToElectricity)) then self:CustomElementalInjured(DMG_SHOCK,dmginfo:GetAttacker()) end
		if (dmginfo:IsDamageType(DMG_SLOWBURN) and !tobool(self.ImmuneToIce)) then self:CustomElementalInjured(DMG_SLOWBURN,dmginfo:GetAttacker()) end
		if (dmginfo:IsDamageType(DMG_DISSOLVE) and !tobool(self.ImmuneToCombineBalls)) then self:CustomElementalInjured(DMG_DISSOLVE,dmginfo:GetAttacker()) end
		if (dmginfo:IsDamageType(DMG_DROWN) and !tobool(self.CanDrown)) then self:CustomOnDrowning(dmginfo)end
	end
		self:CustomInjured(dmginfo)
end

-- Helper funcs
function ENT:CheckValid(ent)
	if !ent then return false end
	if !IsValid(self) then return false end
	if self:Health() < 0 then return false end
	if !IsValid(ent) then return false end
	if ent:Health() < 0 then return false end
	return true
end

function ENT:CreateBeamParticle(pcf,pos1,pos2,ang1,ang2,parent,candie,dietime)
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

function GetCenter(v)
	return v:GetPos() + Vector(0,0,50)
end

function ENT:Helper_BreakDoor(door,delay)
	local cls = door:GetClass()
	local del = delay or 0
	
	timer.Simple(del,function()
		if !IsValid(self) then return end
		if !IsValid(door) then return end
		
		self:EmitSound("physics/wood/wood_plank_break1.wav")
		door:SetNoDraw(true)
		door:SetNotSolid(true)
		door:DrawShadow(false)
		
		if string.find(cls,"door_rotating") then
			local propdoor = ents.Create("prop_physics")
			propdoor:SetPos(door:GetPos())
			propdoor:SetAngles(door:GetAngles())
			propdoor:SetModel(door:GetModel())
			propdoor:SetSkin(door:GetSkin())
			propdoor:Spawn()
			propdoor:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			
			local physicsObject = propdoor:GetPhysicsObject()
			
			if (IsValid(physicsObject)) then
				if (IsValid(self)) then
					physicsObject:ApplyForceCenter((door:GetPos() - self:GetPos()):GetNormal() * 10000)
				end
			end
		end
		
		timer.Simple(30,function()
			if !IsValid(door) then return end
			
			SafeRemoveEntity(propdoor)
			door:SetNoDraw(false)
			door:SetNotSolid(false)
			door:DrawShadow(true)
		end)
	end)
end

function ENT:Helper_PuntProp(prop,delay,force)
	force = force or 100000
	
	timer.Simple(delay,function()
		if !IsValid(self) then return end
		if !IsValid(prop) then return end
		
		prop:EmitSound("npc/zombie/zombie_pound_door.wav")
		prop:TakeDamage(force*10)
		
		local physicsObject = prop:GetPhysicsObject()
		if (IsValid(physicsObject)) then
			if (IsValid(self)) then
				physicsObject:ApplyForceCenter((prop:GetPos() - self:GetPos()):GetNormal() * force)
			end
		end
	end)
end

function ENT:Helper_SafeTimer(delay,func)
	timer.Simple(delay,function()
		if !IsValid(self) then return end
		func()
	end)
end

function ENT:Helper_DelaySound(delay,snd,radius,pitch)
	self:Helper_SafeTimer(delay,function()
		self:EmitSound(snd,radius or 511,pitch or 100)
	end)
end

function ENT:GetIsRBaseNPC(ent)
	return (ent:IsScripted() and ent.Base == "r_base_darksouls")
end
function ENT:Helper_Attack(v,delay,sequence,ShouldStop,damage,damageradius,facetarget,snd)
	if IsValid(v) and ((v:GetClass() != self and v:Health() > 0) 
	or (v:IsPlayer() && v:Alive()) or string.find(v:GetClass(),"vrill_human")
	or (self:GetIsRBaseNPC(v))) then
		if not (v:IsValid() && v:Health() > 0) then return end
		if v:IsPlayer() then
			self.Stam = self.Stam - (damage*1.5)
		else
			self.Stam = self.Stam - (damage*math.random(0.4,1.6))
		end
		self:Helper_SafeTimer(delay-(delay*0.5), function()self:EmitSound(snd[2],511,100)end)
		self:Helper_SafeTimer(delay,function()
			if !IsValid(v) then return end
			if self:GetRangeTo(v:GetPos()) > damageradius then return end
			if (self:GetIsRBaseNPC(v) and v:GetGodMode()) then return end
			v:TakeDamage(damage,self)
			
			if self:GetIsRBaseNPC(v) then 
				ParticleEffect("blood_impact_red_01",v:GetPos() + Vector(math.Rand(-5,5),math.Rand(-5,5),math.Rand(30,50)), Angle(0,0,0), v)
			end
			
			self:EmitSound(snd[1],511,100)
		end)
		if sequence == "" then return end-- The function can also be used without forcing an animation, for attacks that hit more than once.
			self:SetState(DS_STATE_ATTACKING)
				if ShouldStop then
					-- self:DS_PlaySequenceAndWait(sequence)
					self:PlaySequenceAndWait(sequence)
				else
					self:DS_PlaySequenceAndMove(sequence,facetarget or false)
				end
				self:DS_StopWeaponTrail()
			self:SetState(DS_STATE_CHASINGENEMY)
			self:HandleMove()
	end
end

function ENT:Helper_BecomeRagdoll(dmginfo,time)
	time = time or 30
	if SERVER then
		if !util.IsValidRagdoll(self:GetModel()) then
			self:OnKilled(dmginfo)
		else
			local ent = ents.Create("prop_ragdoll")
			ent:SetPos(self:GetPos())
			ent:SetAngles(self:GetAngles())
			ent:SetModel(self.Model)
			ent:Spawn()
			ent:Activate()
			ent:SetColor(self:GetColor())
			ent:SetMaterial(self:GetMaterial())
			ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			ent:Fire("FadeAndRemove","",time)

			local dmgforce = dmginfo:GetDamageForce()
			for bonelim = 1,128 do -- 128 = Bone Limit
				local childphys = ent:GetPhysicsObjectNum(bonelim)
				if IsValid(childphys) then
					local childphys_bonepos, childphys_boneang = self:GetBonePosition(ent:TranslatePhysBoneToBone(bonelim))
					if (childphys_bonepos) then 
						childphys:SetPos(childphys_bonepos)
						childphys:SetAngles(childphys_boneang)
						childphys:SetVelocity(dmgforce /40)
					end
				end
			end
			SafeRemoveEntity(self)
			
			return ent
		end
	end
end

function ENT:RunBehaviour()
	self:SpawnIn()
	while (true) do
		if self:GetState() != DS_STATE_OVERRIDE then
			self:CustomRunBehaviour()
			if (self:HaveEnemy()) then 
				self:SetState(DS_STATE_CHASINGENEMY)
				self:HandleMove()
				self:ChaseEnemy()
			else 
				self:SetState(DS_STATE_WANDERING)
				self:HandleMove()
				self:CustomIdle()
				self:FindEnemy()
			end
		coroutine.wait(0.2)
		end
	end
end
function ENT:HandleAnimationOverride()
	if self.OverrideAnim == "" then return end
		if self:GetState() != DS_STATE_PARRIED then
			self:SetState(DS_STATE_OVERRIDE)
		end
		self:DS_PlaySequenceAndWait(self.OverrideAnim,self.OverrideAnimRate or 1) 
	self.OverrideAnim = ""
	if self:GetState() != DS_STATE_PARRIED then
		self:SetState(DS_STATE_IDLE)
	end
end
function ENT:HandleMove()
	if self:GetState() == DS_STATE_WANDERING then
		self.loco:SetDesiredSpeed(self.WalkSpeed)
		self:ResetSequence(self.Animations.Walk.F)
	elseif self:GetState() == DS_STATE_CHASINGENEMY then
		self.loco:SetDesiredSpeed(self.RunSpeed)
		self:ResetSequence(self.Animations.Run)
	end
end

function ENT:ChaseEnemy(options)
	local options = options or {}
	local path = Path("Follow")
	path:SetMinLookAheadDistance(options.lookahead or 300)
	path:SetGoalTolerance(options.tolerance or 20)
	if IsValid(self:GetEnemy()) then
		path:Compute(self, self:GetEnemy():GetPos())
	else
		print("Something removed the ENEMY prematurely so this overly-long message is being printed to your console so that you can be safe in the knowledge the problem was not caused by you and was in-fact caused by the idiotic developer it was probably Roach he's dumb like that LOL XD\n\n")
		SafeRemoveEntity(self)
	end
	if (!path:IsValid()) then return "failed" end
	while (path:IsValid() and self:HaveEnemy()) do

		if (path:GetAge() > 0.1) then	
			if IsValid(self:GetEnemy()) then
				path:Compute(self, self:GetEnemy():GetPos())
			else
				print("Something removed the ENEMY prematurely so this overly-long message is being printed to your console so that you can be safe in the knowledge the problem was not caused by you and was in-fact caused by the idiotic developer it was probably Roach he's dumb like that LOL XD\n\n")
				SafeRemoveEntity(self)
			end
		end
		path:Update(self)	
		if (options.draw) then path:Draw() end
		if (self.loco:IsStuck()) then
			self:HandleStuck()
			return "stuck"
		end
		
		self:HandleAnimationOverride()
		if self:GetState() != DS_STATE_PARRIED then
			self:CollisionBounce(self.CollisionRadius,512)
			self:HandleDodging()
				
			for k,v in pairs(ents.FindInSphere(self:GetPos(),70)) do
				if (string.find(v:GetClass(),"prop_combine_ball")) then
					if !self.ImmuneToCombineBalls then
						local d = DamageInfo()
						d:SetAttacker(v:GetOwner())
						d:SetInflictor(v)
						if self.ResistantToCombineBalls then
							d:SetDamage(self.CombineBallDamage)
						else
							d:SetDamage(self:Health())
						end
						d:SetDamageType(DMG_DISSOLVE)
						self:TakeDamageInfo(d)
					end
					
					v:Fire("explode","",0.1)
				end
			end
			if self.CanClimbLadders then -- Obviously we want to skip this code entirely if we can't climb ladders.
				if self:GetState() == DS_STATE_DEAD then return end
				if IsValid(navmesh.GetNearestNavArea(self:GetPos())) then
					local pos = self:GetPos()
					if table.Count(navmesh.GetNearestNavArea(pos):GetLadders()) > 0 then
						local ladder = navmesh.GetNearestNavArea(pos):GetLadders()[1]
						if pos:Distance(ladder:GetPosAtHeight(pos.z)) < 50 then
							if path:GetClosestPosition(ladder:GetPosAtHeight(pos.z)):Distance(ladder:GetPosAtHeight(pos.z)) < 20 then 
								-- We make sure the path at our height is actually close to the ladder
								if self:GetPos():Distance(ladder:GetTop()) >= 50 then
									self:ClimbLadder(ladder)
										-- There's no real accurate way to do this, we can only assume that if we're close enough
										-- to the top, then we're already at the top, and don't need to start climbing again.
								end
							end
						end
					end
				end
			end
			
			if (self.HasEstus) and (self.NumEstus > 0) and (self:Health() < (self.health/3)) then
				self:Helper_ForceDodge(2)
				coroutine.wait(0.1)
				self:Helper_ForceDodge(2)
				
				self:SetState(DS_STATE_ESTUSING)
				self:OnStartDrinkEstus()
					self:PlaySequenceAndWait(self.Animations.Estus.To)
					if self.Animations.Estus.Drink != "" then 
						self:OnDrinkEstus()
						self:PlaySequenceAndWait(self.Animations.Estus.Drink)
						self:OnEndDrinkEstus()
					end
				self.NumEstus = self.NumEstus - 1
				if self.NumEstus == 0 then 
					self:OnEstusEmpty()
					self:PlaySequenceAndWait(self.Animations.Estus.Empty)
				end
			end

			if self.Stam >= 1 and self:GetState() == DS_STATE_CHASINGENEMY then
				if self:GetState() == DS_STATE_ATTACKING then
					self:NoStamLogic()
				else
					if self:GetRangeTo(self:GetEnemy():GetPos()) < self.AttackRangeClose then
						self:CustomWithinAttackRange(DS_RANGE_LOW, self:GetEnemy())
					elseif self:GetRangeTo(self:GetEnemy():GetPos()) < self.AttackRangeMedium then
						self:CustomWithinAttackRange(DS_RANGE_MED, self:GetEnemy())
					elseif self:GetRangeTo(self:GetEnemy():GetPos()) < self.AttackRangeFar then
						self:CustomWithinAttackRange(DS_RANGE_FAR, self:GetEnemy())
					elseif self:GetRangeTo(self:GetEnemy():GetPos()) < self.AttackRangeVeryFar then
						self:CustomWithinAttackRange(DS_RANGE_VERYFAR, self:GetEnemy())
					end
				end
			else
				self:NoStamLogic()
			end
		else
			self.loco:SetDesiredSpeed(0)
		end
		coroutine.yield()
	end
	return "ok"
end

-- Custom Dark Souls shit --
function ENT:CanDodge()
	local function getplayerkey(ply,key)
		if ply:KeyPressed(key) then		return true		end
		if ply:KeyReleased(key) then	return true		end
		if ply:KeyDown(key) then		return true		end
		return false
	end

	if self:GetState() == DS_STATE_ATTACKING then return false end
	if self.Animations.Dodge.F == "" and self.Animations.Dodge.B == ""
	and self.Animations.Dodge.L == "" and self.Animations.Dodge.R == "" then 
		-- If these strings were left blank, it's a pretty safe bet that the nextbot is incapable of dodging.
		return false
	end
	local v = self:GetEnemy()
	if v:IsPlayer() && v:GetEyeTrace().Entity == self && (getplayerkey(v, IN_ATTACK) or getplayerkey(v, IN_ATTACK2))
	and (math.random(1,100) <= self.DodgeChance) then
		return true
	elseif (self:GetIsRBaseNPC(v) and v:GetState() == DS_STATE_ATTACKING) and (math.random(1,100) <= self.DodgeChance) then
		return true
	else
		return false
	end
end
function ENT:Helper_ForceDodge(dir)
	if self:GetGodMode() then return end
	local m = dir or math.random(1,4)
	if m == 1 and self.Animations.Dodge.F != "" then
		self:OnDodge()
		self:SetGodMode(true)
			self:DS_PlaySequenceAndMove(self.Animations.Dodge.F,true)
		self:SetGodMode(false)
		self:HandleMove()
	elseif m == 2 and self.Animations.Dodge.B != "" then
		self:OnDodge()
		self:SetGodMode(true)
			self:DS_PlaySequenceAndMove(self.Animations.Dodge.B,true)
		self:SetGodMode(false)
		self:HandleMove()
	elseif m == 3 and self.Animations.Dodge.L != "" then
		self:OnDodge()
		self:SetGodMode(true)
			self:DS_PlaySequenceAndMove(self.Animations.Dodge.L,true)
		self:SetGodMode(false)
		self:HandleMove()
	elseif m == 4 and self.Animations.Dodge.R != "" then
		self:OnDodge()
		self:SetGodMode(true)
			self:DS_PlaySequenceAndMove(self.Animations.Dodge.R,true)
		self:SetGodMode(false)
		self:HandleMove()
	end
end
function ENT:HandleDodging()
	if !self:CanDodge() then return end
	if self:GetGodMode() then return end
	local m = math.random(1,4)
	if m == 1 and self.Animations.Dodge.F != "" then
		self:OnDodge()
		self:SetGodMode(true)
			self:DS_PlaySequenceAndMove(self.Animations.Dodge.F,true)
		self:SetGodMode(false)
		self:HandleMove()
	elseif m == 2 and self.Animations.Dodge.B != "" then
		self:OnDodge()
		self:SetGodMode(true)
			self:DS_PlaySequenceAndMove(self.Animations.Dodge.B,true)
		self:SetGodMode(false)
		self:HandleMove()
	elseif m == 3 and self.Animations.Dodge.L != "" then
		self:OnDodge()
		self:SetGodMode(true)
			self:DS_PlaySequenceAndMove(self.Animations.Dodge.L,true)
		self:SetGodMode(false)
		self:HandleMove()
	elseif m == 4 and self.Animations.Dodge.R != "" then
		self:OnDodge()
		self:SetGodMode(true)
			self:DS_PlaySequenceAndMove(self.Animations.Dodge.R,true)
		self:SetGodMode(false)
		self:HandleMove()
	end
end
function ENT:DS_MoveToPos(pos, options)
	local options = options or {}
	local path = Path("Follow")
	path:SetMinLookAheadDistance(options.lookahead or 300)
	path:SetGoalTolerance(options.tolerance or 20)
	path:Compute(self, pos)
	if (!path:IsValid()) then return "failed" end
	while (path:IsValid()) do
	
		self:HandleAnimationOverride()
		
		if self:GetState() == DS_STATE_RIPOSTING then return "failed" end
		if self:GetState() == DS_STATE_DEAD then return "failed" end
		if self.OverrideAnim != "" then return "failed" end
		
		path:Update(self)
		if (self.loco:IsStuck()) then
			self:HandleStuck()
			return "stuck"
		end
		if (options.maxage) then
			if (path:GetAge() > options.maxage) then return "timeout" end
		end
		if (options.repath) then
			if (path:GetAge() > options.repath) then path:Compute(self, pos) end
		end
		coroutine.yield()
	end
	return "ok"
end
function ENT:DS_PlaySequenceAndWait(name,speed)
	local len = self:SetSequence(name)
	speed = speed or 1
	
	self:ResetSequenceInfo()
	self:SetCycle(0)
	self:SetPlaybackRate(speed)

	while self.OverrideAnim == name and self:GetCycle() < 1 do
		if self:GetState() == DS_STATE_RIPOSTING then break end
		if self:GetState() == DS_STATE_DEAD then break end
		coroutine.wait(0.05)
	end
	-- coroutine.wait(len/speed)
end
function ENT:HandleRiposte(v)
	self:SetState(DS_STATE_RIPOSTING)
	self:OnRiposteStart(v)
	
		if v:IsPlayer() then 
			v:Freeze(false)
			if SERVER then
				attachment = ents.Create("prop_dynamic")
				attachment:SetModel(v:GetModel())
				attachment:SetPos(self:LocalToWorld(Vector(25,0,0)))
				attachment:SetAngles((self:GetPos() - v:GetPos()):GetNormal():Angle())
				attachment:SetParent(self)
				attachment:SetKeyValue("playbackrate",2)
				attachment:Spawn()
				attachment:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				
					v:Spectate(OBS_MODE_CHASE)
					v:SpectateEntity(self)
					v:StripWeapons()
					attachment:Fire("SetAnimation", "idle_all_01",0)
					
				timer.Simple(0.35,function()
					self:OnRiposteStab(attachment)
					attachment:Fire("SetAnimation", "death_04",0)
					for i=10,23 do
						timer.Simple(0.1*i,function()
							if IsValid(attachment) then
								attachment:SetAngles((self:GetPos() - attachment:GetPos()):GetNormal():Angle())
								attachment:SetPos(self:LocalToWorld(Vector(5+(i*2),0,0)))
							end
						end)
					end
					
					timer.Simple(1.7,function()
							if attachment then 
								self.doll=ents.Create("prop_ragdoll")
								self.doll:SetModel(attachment:GetModel())
								self.doll:SetPos(attachment:LocalToWorld(Vector(-20,0,20)))
								self.doll:Spawn()
								self.doll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
								self.doll:GetPhysicsObject():SetVelocity(self:LocalToWorld(Vector(math.random(2048,4096),0,0)))
								self.doll:Fire("fadeandremove",2.5,3.5)
								
								SafeRemoveEntity(attachment)
								
								if IsValid(v) then v:SpectateEntity(self.doll) end
							end
						self:OnRiposteKick(self.doll)
							timer.Simple(3.5, function()
								if IsValid(v) then v:Spawn() end
								if !IsValid(self) then return end
								self:SetState(DS_STATE_WANDERING)
							end)
					end)
				end)
			end
		elseif self:GetIsRBaseNPC(v) then
			v:SetState(DS_STATE_PARRIED)
			for i=1,1000 do v.loco:FaceTowards(self:GetPos()) end
			v.OverrideAnim=v.Animations.Idle
			
			timer.Simple(0.35,function()
				self:OnRiposteStab(v)
				v.OverrideAnim=v.Animations.Parry.Riposted
				v:SetHealth(1)
				for i=1,1000 do v.loco:FaceTowards(self:GetPos()) end
				
				timer.Simple(1.7,function()
					self:OnRiposteKick(v)
						timer.Simple(3.5, function()
							if IsValid(v) then v:Spawn() end
							if !IsValid(self) then return end
							self:SetState(DS_STATE_WANDERING)
							v:SetState(DS_STATE_IDLE)
						end)
				end)
			end)
		end	
end
function ENT:NoStamLogic()
	if self:GetIsRBaseNPC(self:GetEnemy()) then
		self:WalkLogic()
	else
		local m = math.random(1,3)
		if m == 1 and self.HasShield then
			self:OnShieldUp()
			self:DS_PlaySequenceAndWait(self.Animations.Shield.To,0.5)
			self:SetState(DS_STATE_SHIELDING)
			self:WalkLogic()
		elseif m == 2 and self.Equipment.Shield.Parry then
			self:OnParryUp()
			self:DS_PlaySequenceAndWait(self.Animations.Parry.To,0.5)
			self:SetState(DS_STATE_PARRYING)
			self:WalkLogic()		
		else
			self:WalkLogic()
		end
	end
end
function ENT:WalkLogic()
	if self:GetIsRBaseNPC(self:GetEnemy()) then
		self.Stam = self.Stamina
		self:HandleMove()
	else -- To make NB vs NB combat more fluid, we skip on normal strafing and simply refill our stamina.
	-- ... Oh also because parrying/riposting against eachother is fucking broken atm LMAO
		for i=0,self.MaxStrafes do
			local m = math.random(1,3)
				if self:GetState() == DS_STATE_SHIELDING then
					if m == 1 then
						self:DS_PlaySequenceAndMove(self.Animations.Walk.B_S,true)
						self:SetState(DS_STATE_SHIELDING)
					elseif m == 2 then
						self:DS_PlaySequenceAndMove(self.Animations.Walk.L_S,true)
						self:SetState(DS_STATE_SHIELDING)
					elseif m == 3 then
						self:DS_PlaySequenceAndMove(self.Animations.Walk.R_S,true)
						self:SetState(DS_STATE_SHIELDING)
					end
					if i == self.MaxStrafes then
						self:OnShieldDown()
						self:DS_PlaySequenceAndWait(self.Animations.Shield.From,0.5)
						self:SetState(DS_STATE_CHASINGENEMY)
					end
				else
					if self:GetState() == DS_STATE_PARRYING then
						if m == 1 then
							self:DS_PlaySequenceAndMove(self.Animations.Walk.F_P,true)
							self:SetState(DS_STATE_PARRYING)
						elseif m == 2 then
							self:DS_PlaySequenceAndMove(self.Animations.Walk.L_P,true)
							self:SetState(DS_STATE_PARRYING)
						elseif m == 3 then
							self:DS_PlaySequenceAndMove(self.Animations.Walk.R_P,true)
							self:SetState(DS_STATE_PARRYING)
						end
						-- print("We're parrying!")
						if i >= self.MaxStrafes then
							self:OnParryDown()
							self:SetState(DS_STATE_CHASINGENEMY)
							self:DS_PlaySequenceAndWait(self.Animations.Parry.From,0.5)
						end
					else
						if m == 1 and self.Animations.Walk.B != "" then
							self:DS_PlaySequenceAndMove(self.Animations.Walk.B,true)
						elseif m == 2 and self.Animations.Walk.L != "" then
							self:DS_PlaySequenceAndMove(self.Animations.Walk.L,true)
						elseif m == 3 and self.Animations.Walk.R != "" then
							self:DS_PlaySequenceAndMove(self.Animations.Walk.R,true)
						else
							self:CustomIdle()
							-- We can't default to anything else, so we just idle.
							self.Stam = self.Stamina
							-- However to make up for that fact we get full stamina back.
							self:HandleMove()
						end
						-- print("We're walking!")
						if i == self.MaxStrafes then
							self:SetState(DS_STATE_CHASINGENEMY)
							self:HandleMove()
						end
					end
				end
		end
	end
end
function ENT:ClimbLadder(ladder)
    local pos
    local vector
    local direction
    local count = 0
	local position = self:GetPos()
    pos = ladder:GetTop()
    vector = Vector(0,0,1).z
	
	self:SetState(DS_STATE_LADDER)
		self:SetPos(position+self:GetForward()*20)
		for i=1,1000 do self.loco:FaceTowards(ladder:GetPosAtHeight(self:GetPos().z)) end
		if IsValid(self) then self:DS_PlaySequenceAndWait(self.Animations.Ladder.Mount) end
		self:CustomOnClimbLadder()
		if IsValid(self) and self:GetState() == DS_STATE_LADDER then self:ResetSequence(self.Animations.Ladder.ClimbUp)end
		local startpos = self:GetPos()
		while (self:GetPos():Distance(pos) > 20) do
			if self:GetState() != DS_STATE_LADDER then break end
			if count > 3 then
				if self:GetState() != DS_STATE_LADDER then break end
				if self:GetPos() == startpos then
					return "failed"
				end
			end
			self.loco:FaceTowards(ladder:GetPosAtHeight(self:GetPos().z))
			self:SetPos(ladder:GetPosAtHeight(vector +self:GetPos().z) + (self:GetForward()*-15))
			count = count + 1
			if self:GetState() == DS_STATE_LADDER then coroutine.wait(0.01) end
		end
		if self:GetState() != DS_STATE_LADDER then return end
		if IsValid(self) then self:DS_PlaySequenceAndWait(self.Animations.Ladder.Dismount) end
	self:SetState(DS_STATE_IDLE)
	self:CustomOnEndClimbLadder()
    self:SetPos(pos)
end
function ENT:DS_PlaySequenceAndMove(seq,facetowards)
	local sequence,dur = self:LookupSequence(seq)
	local prevstate = self:GetState()
	if (sequence) then
		-- self:SetState(DS_STATE_OVERRIDE)
	
		self:ResetSequence(sequence)
		self:SetCycle(0)
		for i=1,math.Round(dur*100,0) do
			self:Helper_SafeTimer(0.01*i,function()
				if self:GetSequence() != sequence then return end
				self.loco:SetDesiredSpeed(self:GetSequenceGroundSpeed(sequence))
				if (IsValid(self) and IsValid(self:GetEnemy()))
				and facetowards then for i=1,1000 do self.loco:FaceTowards(self:GetEnemy():GetPos()+Vector(0,0,50)) end end
				self:CollisionBounce(self.CollisionRadius,512)
			end)
		end
	
		local ga,gb,gc = self:GetSequenceMovement(sequence,0,1)
		local pos = self:LocalToWorld(gb)
		-- if util.IsInWorld(pos) then
			self:DS_MoveToPos(pos)
		-- else
			-- self:DS_MoveToPos(pos,{tolerance=300})
		-- end
		
		-- self:SetState(prevstate or DS_STATE_IDLE)
	end
end
function ENT:CollisionBounce(radius,force) -- Internal use only, for moving players out of the way.
   for k, target in pairs(ents.FindInSphere(self:GetPos(), radius/1.5)) do
      if IsValid(target) then
         local tpos = target:LocalToWorld(target:OBBCenter())
         local dir = (tpos - self:GetPos()):GetNormal()
         local phys = target:GetPhysicsObject()

         if target:IsPlayer() then
            local push = dir * force
            local vel = target:GetVelocity() + push
			vel.z = 1
            target:SetVelocity(vel)
         end
      end
   end
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", 31, "RB_DebugHealth")
	self:NetworkVar("Float", 30, "RB_DebugStamina")
	self:NetworkVar("String", 3, "RB_DebugState")
	
	self:CustomSetupDataTables()
end

if !CLIENT then return end
hook.Add("HUDPaint", "RBase_Debug_ShowDetails", function()
	if GetConVar("rb_ds1_debuginfo"):GetInt() == 1 then
		local seqinfo, tp = nil, nil
		for k,v in pairs(ents.GetAll()) do
			if IsValid(v) and (v:IsScripted() and v.Base == "r_base_darksouls") then
				seqinfo = v:GetSequenceInfo(v:GetSequence())
				tp = (v:GetPos() + Vector(0,0,seqinfo.bbmax.z + 10)):ToScreen()

				if (tp.visible) then
					draw.SimpleText(
						"Health: "..v:GetRB_DebugHealth(), "GModNotify", 
						tp.x, tp.y, color_white, TEXT_ALIGN_LEFT
					)
					draw.SimpleText(
						"Stamina: "..v:GetRB_DebugStamina().."/"..v.Stamina, "GModNotify", 
						tp.x, tp.y+20, color_white, TEXT_ALIGN_LEFT
					)
					draw.SimpleText(
						"State: "..v:GetRB_DebugState(), "GModNotify", 
						tp.x, tp.y+40, color_white, TEXT_ALIGN_LEFT
					)
				end
			end
		end
	end
end)