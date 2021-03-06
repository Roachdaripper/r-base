
/*-----------------------------------------------------------------------------------------------------------*\
|							 ___________________________________________________ 							  |
|							/                                                   \							  |
|							|  Copyright © 20XX by Roach, All rights reserved.  |							  |
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
ENT.Damage = 30												-- Our damage output.
ENT.Speed = 100												-- How fast we move.
ENT.IdleNoiseInterval = 10									-- How often do we play idle noises?
ENT.IdleSounds = {}
ENT.WalkAnim = ("")											-- The animation we play while walking.

-- Footsteps --
ENT.UseFootSteps = true										-- Do we play footstep sounds?
ENT.FootStepInterval = 1 									-- How long to wait before playing footstep sound again.

-- Immunities --
ENT.ImmuneToCombineBalls = false							-- Do we take damage from Combine Balls?
ENT.ResistantToCombineBalls = false							-- Can we survive more than one Combine Ball?
ENT.CombineBallDamage = ENT.health/2						-- How much damage do we take from Combine Balls? (Can either be a number or a calculation as shown.)
ENT.ImmuneToElectricity = false 							-- Do we take damage from electrical attacks?
ENT.ImmuneToFire = false									-- Do we ignite/take damage from fire?
ENT.ImmuneToIce = false										-- Do we freeze/take damage from ice?
ENT.CanDrown = true											-- Can we drown?
ENT.BreathTime = 30											-- How long can we hold our breath for while underwater?

-- Possession --
ENT.CanBePossessed = true									-- Can we be possessed by using the possessor?
ENT.IsStationary = false									-- Can we move? Used for the Possessor since otherwise all movement (or lack thereof) is controlled manually.

function ENT:CustomInit()end
function ENT:OnSpawn()end--hintactivity (internal name for hint type)
function ENT:CustomThink()end
function ENT:CustomChaseEnemy(target)end
function ENT:FootSteps()end
function ENT:CustomIdle()end
function ENT:CustomIdleSound() --  Default function, overwrite as you please.
	if #self.IdleSounds > 1 then
		self:EmitSound(self.IdleSounds[math.random(1,#self.IdleSounds)])
	elseif #self.IdleSounds == 1 then
		self:EmitSound(self.IdleSounds[1])
	end
end
function ENT:CustomKilled(dmginfo)end
function ENT:CustomInjured(dmginfo)end
function ENT:CustomElementalInjured(dmgtype,attacker)end
function ENT:CustomOnDrowning(dmginfo)end
function ENT:CustomOnRemove()end
function ENT:CustomRunBehaviour()end
function ENT:CustomOnDissolve() -- Use for gibbing or etc.
end
function ENT:CustomOnJump() -- What do we do when jumping?
end

function ENT:P_PrimaryAttack(possessor)
	self:P_GenericMeleeCode(possessor,0,"", "common/null.wav")
end
function ENT:P_SecondaryAttack(possessor)end
function ENT:P_Jump(possessor)end
function ENT:P_Reload(possessor) end
function ENT:P_Sprint(possessor)end
function ENT:P_PossessorIdle(possessor) -- Default idle code as a fallback, replace as you wish. 
	self:StartActivity(ACT_IDLE)
	self.loco:SetDesiredSpeed(0)
end

--Helper functions - you don't need to use them but it'll probably make your life easier.
--[[---------------------------------------------------------------------------------------
	self:P_IsPossessed()
	Returns whether we are possessed or not.

	self:P_GetPossessor()
	Returns the player that is possessing us, or returns nil if that player doesn't exist.
	
	self:P_GenericMeleeCode(Player possessor, Integer delay, String sequence, string SoundFile)
	Ex: self:P_GenericMeleeCode(possessor, 0.6, "attack", "common/null.wav")
	A simple default melee function for possessed nextbots, as attacking works WAY differently. You can still code your own if you want, though.

	self:MovementFunctions(Sequence seq, Integer speed, Integer cycle, Integer playbackrate)
	Ex: self:MovementFunctions("idle",1,0,1)
	An easier method of playing a sequence, moving at a speed, and if necessary, setting the cycle and playback rate.

	CreateBeamParticle(String pcf, Vector pos1, Vector pos2, Angle ang1, Angle ang2, Entity parent, Boolean candie, Integer dietime)
	Ex: CreateBeamParticle("error",self:GetPos(),Vector(0,0,0),self:GetAngles(),Angle(0,0,0),self,false)
	Creates a particle beam. Works in a different manner to util.ParticleTracer as (you guessed it) it doesn't use TraceData.

	GetCenter(Entity v)
	Ex: GetCenter(self:GetEnemy())
	Returns (roughly) the center of an entity.
	
	P_Possess(Player player, Entity nextbot, Integer delay)
	Ex: P_Possess(ply, self, 0)
	Forces a player into possessing a specific nextbot. Useful if your nextbot is split up into different entities for whatever reason.
	
	self:Helper_Attack(Entity victim, Integer delay, String sequence, Bool ShouldStop, Integer Damage, Integer damageradius, String hitsound)
	Ex: self:Helper_Attack(v,0.6,"attack",true,100,150,"common/null.wav")
	Simple helper function for a basic melee attack. You can always use your own.
	
	self:Helper_PuntProp(Entity prop, Integer delay, Integer force)
	Ex: self:Helper_PuntProp(v,1,1000000)
	Simple helper function for basic prop punting.
	
	self:Helper_BreakDoor(Entity door, Integer delay)
	See above. Except for breaking down doors.
	
	self:Helper_SafeTimer(Integer delay, Function func)
	A timer.Simple that automatically checks for validity.
---------------------------------------------------------------------------------------]]--
-- Everything below this line is all default stuff that comes with the base. Feel free to delete it in your NPC.
function ENT:Initialize()
	self.IsPossessed = false
	self.Interval = self.FootStepInterval 
	self:CustomInit()
	self.Entity:SetCollisionBounds(Vector(-4,-4,0), Vector(4,4,64))
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	self:SetHealth(self.health)
	self:SetModel(self.Model)
	self.LoseTargetDist	= 250000000 
	self.SearchRadius 	= 999000000 
	if SERVER then 
		self.loco:SetStepHeight(35)
		self.loco:SetAcceleration(900)
		self.loco:SetDeceleration(900)
		self:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)
	end 
	self.nextbot = true 
	self:CreateBullseye()
	self.NextIdle = CurTime() + self.IdleNoiseInterval
end
function ENT:BodyUpdate()
	self:BodyMoveXY()
end
function ENT:GetEnemy()
	return self.Enemy 
end
function ENT:SetEnemy(ent)
	self.Enemy = ent 
end
function ENT:HaveEnemy()
	if self:P_IsPossessed() then return false end
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
	if self:P_IsPossessed() then return end
	if GetConVarNumber("ai_disable") == 1 then return end
	local _ents = ents.FindInSphere(self:GetPos(), self.SearchRadius or 9000)
		for k,v in pairs(_ents) do 
			if (GetConVarNumber("ai_ignoreplayers") == 1) then 
				if v:GetClass() != self and ((v:GetClass() == "npc_bullseye" and v:GetName() == "NextbotTarget") or v:GetClass() != "npc_bullseye") and v:GetClass() != "npc_grenade_frag" and v:IsNPC() and v:Health() > 0 then
					self:SetEnemy(v)
					return true
				end
			else
				if (v:IsPlayer() and v:Alive()) then 
					self:SetEnemy(v)
					return true 
				elseif v:GetClass() != self and ((v:GetClass() == "npc_bullseye" and v:GetName() == "NextbotTarget") or v:GetClass() != "npc_bullseye") and v:GetClass() != "npc_grenade_frag" and v:IsNPC() and v:Health() > 0 then
					self:SetEnemy(v)
					return true
				end 	
			end
		end 
	self:SetEnemy(nil)
	return false 
end
function ENT:Think()
	if not SERVER then return end 
	if self:P_IsPossessed() then
		if self:P_IsPossessed() and (self.IsStationary or self:GetVelocity() == Vector(0,0,0)) then
			self.loco:FaceTowards(self:P_GetPossessor():GetPos() + self:P_GetPossessor():GetForward() * 100)
		end
	end
	
	if !IsValid(self) then return end 
	self:CustomThink()
	if tobool(self.UseFootSteps) then 
		if !self.nxtThink then self.nxtThink = 0 end 
		if CurTime() < self.nxtThink then return end 
			self.nxtThink = CurTime() + 0.025 
			self:DoFootstep() 
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
	self:CreateRelationShip()
end
function ENT:DoFootstep()
	if CurTime() < self.Interval then return end 
	if self:GetVelocity() == Vector(0,0,0) or self.loco:GetGroundMotionVector() == 0 then return end 
		self:FootSteps()
	self.Interval = CurTime() + self.FootStepInterval 
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

function ENT:RunBehaviour()
	self:SpawnIn()
	while (true) do
		if self.CanBePossessed and self:P_IsPossessed() then
			if CLIENT then continue end
			-- self:SetNotSolid(true)
			local ply = self:P_GetPossessor()
			
			if IsValid(ply) then
					local MoveToPosTable = {}
					MoveToPosTable.lookahead = 300
					-- MoveToPosTable.tolerance = 100
					MoveToPosTable.tolerance = 20
					MoveToPosTable.draw = false
					-- MoveToPosTable.draw = true
					MoveToPosTable.maxage = 0.1
					MoveToPosTable.repath = 0.1

				if ply:KeyDown(IN_FORWARD) and not self.IsStationary then -- Your basic move forward key.
					self:ResetSequence(self.WalkAnim)
					self.loco:SetDesiredSpeed(self.Speed)
							
					self:P_MoveToPos(MoveToPosTable, ply, "forward")
					self:P_PossessorIdle(ply)
				else
					if ply:KeyDown(IN_MOVELEFT) and not self.IsStationary then -- Your basic move left key.
						self:ResetSequence(self.WalkAnim)
						self.loco:SetDesiredSpeed(self.Speed)
					
						self:P_MoveToPos(MoveToPosTable, ply, "left")
						self:P_PossessorIdle(ply)
					end
					if ply:KeyDown(IN_MOVERIGHT) and not self.IsStationary then -- Your basic move right key.
						self:ResetSequence(self.WalkAnim)
						self.loco:SetDesiredSpeed(self.Speed)
					
						self:P_MoveToPos(MoveToPosTable, ply, "right")
						self:P_PossessorIdle(ply)
					end
					if ply:KeyDown(IN_BACK) and not self.IsStationary then -- Your basic move back key.
						self:ResetSequence(self.WalkAnim)
						self.loco:SetDesiredSpeed(self.Speed)
					
						self:P_MoveToPos(MoveToPosTable, ply, "backward")
						self:P_PossessorIdle(ply)
					end

					if ply:KeyDown(IN_USE) then -- Key to bail.
						SafeRemoveEntity(self)
					end
					if ply:KeyDown(IN_ATTACK) then self:P_PrimaryAttack(ply) end -- Your basic attacking key I think?
					if ply:KeyDown(IN_ATTACK2) then self:P_SecondaryAttack(ply) end -- Your basic ... Secondary attack whatever.
					if ply:KeyDown(IN_JUMP) then self:P_Jump(ply) end
					if ply:KeyDown(IN_SPEED) then self:P_Sprint(ply) end
					if ply:KeyDown(IN_RELOAD) then self:P_Reload(ply) end
					
					self:P_PossessorIdle(ply)
				end
			end
			if self.PossessedWaitTime then
				coroutine.wait(self.PossessedWaitTime or 2)
			else
				coroutine.yield()
			end
		else
			if (GetConVarNumber("ai_disabled") == 0 or GetConVarNumber("ai_ignoreplayers") == 0) then 
				self:CustomRunBehaviour()
				if (self:HaveEnemy()) then 
					self.loco:SetDesiredSpeed(self.Speed)
					self:ResetSequence(self.WalkAnim)
					self:ChaseEnemy()
				else 
					self:CustomIdle()
					self:FindEnemy()
				end
			else
				self:CustomIdle()
				self:FindEnemy()
			end
			coroutine.wait(2)
		end 
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
		
/*		local nav = navmesh.GetNearestNavArea(self:GetPos())
		if (IsValid(nav) and tobool(self.CanDetectNavNodes)) then
			if (nav:HasAttributes(NAV_MESH_JUMP) and tobool(self.CanJump)) then
				if !self.NextJump or CurTime() > self.NextJump then
						-- self.loco:SetDesiredSpeed(0)
						self.loco:SetJumpHeight(self.JumpHeight)
						self:PlaySequenceAndWait(self.JumpAnim)
						-- self.loco:SetDesiredSpeed(self.Speed)
						coroutine.wait(0.25)
						self.loco:Jump()
					self.NextJump = CurTime() + 10
				end
			end
		end 
*/
		if self.NextIdle < CurTime() then
			self:CustomIdleSound()
			self.NextIdle = CurTime() + self.IdleNoiseInterval
		end
		
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
			if string.find(v:GetClass(),"sim_fphys") or v:IsVehicle() then
				if v:GetVelocity():Length() > 50 then
					if string.find(self:GetClass(),"regzombie") then
						if v:GetVelocity():Length() > self.health*5 then
							local ent = ents.Create("nzombie_death")
							ent:SetPos(self:GetPos())
							ent:SetAngles(self:GetAngles())
							ent:Spawn()
							ent.Typ = "phys"
							if self.LGibbed then ent:SetBodygroup(0,1) end
							if self.RGibbed then ent:SetBodygroup(0,2) end
							
							SafeRemoveEntity(self)
						else
							self:TakeDamage(v:GetVelocity():Length()/10,v:GetOwner(),v)
						end
					else
						self:EmitSound("physics/metal/metal_sheet_impact_hard"..math.random(6,8)..".wav")
						if v:GetVelocity():Length() > self.health then self:Helper_BecomeRagdoll()end
					end
				end
			end
			if !string.find(self:GetClass(),"regzombie") then			
				if v:GetClass() == "obj_lstaff_lgtball" then
					ParticleEffectAttach("zomb_elec",PATTACH_POINT_FOLLOW,self,0)
					self:EmitSound("staff/lightning/victim_shocked.mp3")
				
					timer.Simple(1,function()
						self:TakeDamage(self:Health())
					end)
					SafeRemoveEntity(v)
				else
					if string.find(v:GetClass(),"obj_") and string.find(v:GetClass(),"staff_") then
						if v:GetClass() == "obj_lstaff_lgtball" then continue end
						v:OnCollide(nil,v:GetPhysicsObject(),true)
						self:TakeDamage(self:Health())
					end
				end
			end
		end
		
		self:CustomChaseEnemy(self:GetEnemy())
		
		coroutine.yield()
	end
	return "ok"
end
function ENT:OnRemove()
	if self:P_IsPossessed() and IsValid(self:P_GetPossessor()) then
		local spark = EffectData()
		spark:SetOrigin(self:GetPos() + Vector(0,0,math.random(0,20)))
		spark:SetStart(self:GetPos() + Vector(0,0,math.random(0,20)))
		for i=0,math.random(30,50) do util.Effect("cball_explode",spark) end
		
		self:P_GetPossessor():EmitSound("npc/assassin/ball_zap1.wav")
		self:P_GetPossessor():KillSilent()
	end
	
	self:CustomOnRemove()
end
function ENT:OnKilled(dmginfo)
	if dmginfo:IsDamageType(DMG_DISSOLVE) then
		self:HandleDissolving(dmginfo)
	else
		self:CustomKilled(dmginfo)
	end
	if !file.Exists("autorun/slvbase","LUA") then -- Hopefully should fix conflictions against SLVBase. HOPEFULLY.
		if file.Exists("autorun/bgo_autorun_sh","LUA") then return end -- BGO has a bone to pick with R-Base too it seems.
		hook.Run("OnNPCKilled",self,dmginfo:GetAttacker(),dmginfo:GetInflictor())
	end
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
	if (!self:HaveEnemy() and (att:IsNPC() or att:IsPlayer())) then self:SetEnemy(att) end

	if (dmginfo:IsDamageType(DMG_BURN) and !tobool(self.ImmuneToFire)) then self:CustomElementalInjured(DMG_BURN,dmginfo:GetAttacker()) else
		if (dmginfo:IsDamageType(DMG_SHOCK) and !tobool(self.ImmuneToElectricity)) then self:CustomElementalInjured(DMG_SHOCK,dmginfo:GetAttacker()) end
		if (dmginfo:IsDamageType(DMG_SLOWBURN) and !tobool(self.ImmuneToIce)) then self:CustomElementalInjured(DMG_SLOWBURN,dmginfo:GetAttacker()) end
		if (dmginfo:IsDamageType(DMG_DISSOLVE) and !tobool(self.ImmuneToCombineBalls)) then self:CustomElementalInjured(DMG_DISSOLVE,dmginfo:GetAttacker()) end
		if (dmginfo:IsDamageType(DMG_DROWN) and !tobool(self.CanDrown)) then self:CustomOnDrowning(dmginfo)end
	end
		self:CustomInjured(dmginfo)
end
--Possession funcs
function ENT:P_MoveToPos(options, possessor, direction)
	local options = options or {}
	direction = direction or "forward"
	
	local pos --= possessor:GetForward() * 9999
	if direction == "left" then
		pos = possessor:GetRight() * -9999
	else
		if direction == "right" then pos = possessor:GetRight() * 9999 end
		if direction == "backward" then pos = possessor:GetForward() * -9999 end
		if direction == "forward" then pos = possessor:GetForward() * 9999 end
	end
	
	local path = Path("Follow")
	path:SetMinLookAheadDistance(options.lookahead or 300)
	path:SetGoalTolerance(options.tolerance or 20)
	path:Compute(self, pos)
	if (!path:IsValid()) then return "failed" end
	while (path:IsValid()) do
		if direction == "left" then
			pos = possessor:GetRight() * -9999
		else
			if direction == "right" then pos = possessor:GetRight() * 9999 end
			if direction == "backward" then pos = possessor:GetForward() * -9999 end
			if direction == "forward" then pos = possessor:GetForward() * 9999 end
		end
	
			path:Update(self)
		if (!possessor:KeyDown(IN_FORWARD) and !possessor:KeyDown(IN_MOVELEFT)) and (!possessor:KeyDown(IN_MOVERIGHT) and !possessor:KeyDown(IN_BACK)) then return "timeout" end
		if (options.draw) then
			path:Draw()
		end
		if (self.loco:IsStuck()) then
			self:HandleStuck()
			return "stuck"
		end
		if (options.maxage) then
			if (path:GetAge() > options.maxage) then	
				path:Compute(self, pos)
			end
		end
		coroutine.yield()
	end
	return "ok"
end
function ENT:P_GenericMeleeCode(possessor, delay, sequence, SoundFile)
	delay = delay or 0
	
	local tra = {}
	tra.start = possessor:GetPos()
	tra.endpos = possessor:GetPos() +possessor:GetAimVector()*500
	tra.filter = {possessor, self}
	local tr = util.TraceLine(tra)
	
	timer.Simple(delay, function()
		if !IsValid(self) then return end
		for k,v in pairs(ents.FindInSphere(tr.HitPos, self.Damage * 2)) do
			if v == self then continue end
			if v == possessor then continue end
			
			v:TakeDamage(self.Damage, self)
			if SoundFile and IsValid(v) then self:EmitSound(SoundFile) end
		end
	end)
	if sequence then 
		self:PlaySequenceAndWait(sequence)
	end
end

-- NPC-Targetting funcs
function ENT:CreateBullseye(height)
	if !SERVER then return end
	local bullseye = ents.Create("npc_bullseye")
	bullseye:SetPos(self:GetPos() + Vector(0,0,height or 50))
	bullseye:SetAngles(self:GetAngles())
	bullseye:SetParent(self)
	bullseye:SetNotSolid(true)
	bullseye:SetCollisionGroup(COLLISION_GROUP_NONE)
	bullseye:SetOwner(self)
	bullseye:Spawn()
	bullseye:Activate()
	bullseye:SetHealth(9999999)

	self.Bullseye = bullseye
end
function ENT:CreateRelationShip()
	if (self.RelationTimer or 0) < CurTime() then
		local bullseye = self.Bullseye
		if !self:CheckValid(bullseye) then SafeRemoveEntity(bullseye)return end

		self.LastPos = self:GetPos()
		local ents = ents.GetAll()
		table.Add(ents)
		for _,v in pairs(ents) do
			if v:GetClass() != self and v:GetClass() != "npc_bullseye" and v:GetClass() != "npc_grenade_frag" and v:IsNPC() then
				v:AddEntityRelationship(bullseye, 1, 10)
			end
		end

		self.RelationTimer = CurTime() + 2
	end
end
function ENT:CheckValid(ent)
	if !ent then return false end
	if !IsValid(self) then return false end
	if self:Health() < 0 then return false end
	if !IsValid(ent) then return false end
	if ent:Health() < 0 then return false end
	return true
end

-- Helper funcs
function ENT:P_IsPossessed()
	if self.IsPossessed then return true end
	return false
end
function ENT:P_GetPossessor()
	if IsValid(self.Possessor) then
		return self.Possessor
	end
	return nil
end
function ENT:MovementFunctions(seq, speed, cycle, playbackrate)
	speed = speed or 0
	cycle = cycle or 0
	playbackrate = playbackrate or 1
	if cycle > 1 then ErrorNoHalt("Nextbot MovementFunctions error: cycle must be less than 1.") cycle = 0 end

	self:ResetSequence(seq)
	self:SetCycle(cycle)
	self:SetPlaybackRate(playbackrate)
	self.loco:SetDesiredSpeed(speed)
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
function GetCenter(v)
	return v:GetPos() + Vector(0,0,50)
end
function P_Possess(player,nextbot,delay)
	if player and nextbot then
		delay = delay or 0
		timer.Simple(delay,function()
			if nextbot:IsNPC() or nextbot:IsPlayer() then
				ErrorNoHalt("[R-Base Developer Error](P_Possess) attempting to possess a non-Nextbot NPC.")
			else
				local v = nextbot
				if string.find(v.Base,"r_base") then
					v:SetEnemy(nil)
					v.Possessor = ply
					v.IsPossessed = true
					
					local Spectator = ents.Create("prop_dynamic")
					if v:GetClass() == "nbnz_bo2_avo" then
						Spectator:SetPos((v:GetPos() + Vector(0,0,100)) + v:GetForward() * -50)
					else
						Spectator:SetPos((v:GetPos() +Vector(0,0,v:OBBMaxs().z +20)) + (Vector(0,0,-20)))
					end
					Spectator:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
					Spectator:SetParent(v)
					Spectator:SetRenderMode(RENDERMODE_TRANSALPHA)
					Spectator:Spawn()
					Spectator:SetColor(Color(0,0,0,0))
					Spectator:SetNoDraw(false)
					Spectator:DrawShadow(false)
					
					ply:Spectate(OBS_MODE_CHASE)
					ply:SpectateEntity(Spectator)
					ply:SetNoTarget(true)
					ply:DrawShadow(false)
					ply:SetNoDraw(true)
					ply:SetMoveType(MOVETYPE_OBSERVER)
					ply:DrawViewModel(false)
					ply:DrawWorldModel(false)
					ply:StripWeapons()
				else
					ErrorNoHalt("[R-Base Developer Error](P_Possess) attempting to possess a non-RBase nextbot.")
				end
			end
		end)
	else
		ErrorNoHalt("[R-Base Developer Error](P_Possess) function has incomplete arguments.")
	end
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
		if !self:CheckValid(self) then return end
		func()
	end)
end

function ENT:Helper_Attack(victim,delay,sequence,ShouldStop,damage,damageradius,hitsound)
	local v = victim

	if IsValid(v) and ((v:GetClass() != self and v:GetClass() != "npc_bullseye" and v:GetClass() != "npc_grenade_frag" and v:IsNPC() and v:Health() > 0) or (v:IsPlayer() && v:Alive()) or string.find(v:GetClass(),"vrill_human")) then
		if not (v:IsValid() && v:Health() > 0) then return end
		self:Helper_SafeTimer(delay,function()
			if !IsValid(v) then return end
			if self:GetRangeTo(v:GetPos()) > damageradius then return end
			self:EmitSound(hitsound)
			v:TakeDamage(damage,self)
		end)
		if ShouldStop then
			self:PlaySequenceAndWait(sequence)
			self:ResetSequence(self.WalkAnim)
		else
			local seq,dur = self:LookupSequence(sequence)
			self:ResetSequence(seq)
			self:ResetSequence(seq)
			self:Helper_SafeTimer(dur,function()
				self:ResetSequence(self.WalkAnim)
			end)
		end
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