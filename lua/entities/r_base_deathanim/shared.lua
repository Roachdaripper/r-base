
/*-----------------------------------------------------------------------------------------------------------*\
|							 ___________________________________________________ 							  |
|							/                                                   \							  |
|							|  Copyright © 2017 by Roach, All rights reserved.  |							  |
|							\___________________________________________________/ 							  |
|						This base assumes that you know basic lua. It will not teach						  |
|					you how to make Nextbot death animations. With that said, most of 						  |
|				 the variables have comments on them to explain them a bit more in-depth.					  |
|													Have fun!												  |
|																											  |
\*-----------------------------------------------------------------------------------------------------------*/

if (SERVER) then AddCSLuaFile("shared.lua")end				-- Don't touch.
----------------------------------------------
ENT.Base     = "base_nextbot"								-- Change "base_nextbot" to "r_base_basic".
ENT.Spawnable= false										-- Leave this at false. Nextbots need to be manually shunted over to the NPC category.
----------------------------------------------
ENT.Model = ""
ENT.HasMultipleDeathAnims = false

function ENT:OnSpawn() -- Called at the beginning of RunBehaviour, NOT Initialize. Use for playing sound files, emitting particle effects, etc.
	
end
function ENT:DeathAnimation() -- Replace "death1" with the sequence name of our death animation.
	return "death1"
end
function ENT:DeathAnimationS() -- Use for multiple death animations. Put as many as you need into the table.
	return {"death1","death2"}
end
function ENT:OnFinishAnim() -- When your model has finished playing the animation. Use self:BecomeRagdoll(DamageInfo()) if you want the bot to ragdollize, else you can use the code provided.
	ParticleEffectAttach("rbase_dissolve",PATTACH_POINT_FOLLOW,self,0)
	SafeRemoveEntityDelayed(self,0.2)
	-- Note: If you leave this function empty, the death animation will endlessly repeat.
end

--------------------------------------------
--Base functions, delete in your entity to save space--
function ENT:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetHealth(1250)
	self:SetModel(self.Model)
	if SERVER then
		self.loco:SetAcceleration(400)
		self.loco:SetDeceleration(400)
	end
end
function ENT:RunBehaviour()
	while ( true ) do
		self:OnSpawn()
		if self.HasMultipleDeathAnims then
			local anim = table.Random(self:DeathAnimationS())
		else
			local anim = self:DeathAnimation()
		end
		
			self:PlaySequenceAndWait(anim)
		
		coroutine.wait(5)
			self:OnFinishAnim()
		coroutine.wait(0.3)
	end
end	
function ENT:OnKilled(dmginfo)end