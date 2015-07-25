if myHero.charName ~= "Thresh" then return end

--Required Libs
require 'VPrediction'
require 'SxOrbwalk'
require 'HPrediction'
local enemyHeroes = GetEnemyHeroes()
local REVISION = 1


-- Variables
local BoxRange = 360


--Load Section
function OnLoad()
ts = TargetSelector(TARGET_LESS_CAST_PRIORITY,1100)
 
Config = scriptConfig("Settings", "BigFlays")
Config:addParam("comboMode", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte " ")
Config:addParam("Madlife", "Madlife Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte "a")
Config:addParam("gapCloseDelay", "Humanizer for gapclose", SCRIPT_PARAM_SLICE, 0.05, 0, 1.5, 2)
Config:addParam("autoBoxNum", "min number of enemies for auto box" , SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
Config:addParam("autoBox", "Auto Ult", SCRIPT_PARAM_ONOFF, false)
Config:permaShow("comboMode")

VP = Vpreditcion()
HPRED = Hprediction()
end


--Main Function Area
function OnTick()
	ts:update()

	--Q in combo mode
	if ts.target ~= nil then
		if Config.comboMode then
			if myHero:CanUseSpell(_Q) == READY then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, 0.5, 60, 1075, 1200, myHero, true)
          		if HitChance >= 2 then
            	  CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
	--if ts.target ~= nil then
		--if config.Madlife then
			--if myHero:CanUseSpell(_Q) == READY then

			--anti gap closer
			if myHero:CanUseSpell(_E) == READY then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, gapCloseDelay, 160, 515, math.huge, myHero,false)
				if HitChance >= 2 and CastPosition then
				 local pos = GetReverseFlayPos(CastPosition)
					if pos then
					  CastSpell(_E, pos.x, pos.z)
					end
				end
			end
               --Auto Box check and cast
			if Config.autoBox then
					local inRange = 0
					for i = 1, heroManager.iCount, 1 do
						local btarget = heroManager:getHero(i)
						local Dist = GetDistance(btarget)
						if Dist < BoxRange and btarget.team ~= myHero.team then inRange = inRange + 1 end
					end
					if inRange >= Config.autoBoxNum then
						if myHero:CanUseSpell(_R) == READY then
							CastSpell(_R)
						end
					else 
						inRange = 0
					end
				end
			end
		end
	end


-- Flay Calculation
function GetReverseFlayPos(originalPos)
    return myHero + (myHero - Vector(originalPos.x, originalPos.y, originalPos.z)):normalized() * GetDistance(originalPos)
end


--Move Processing
function Move()

end

--Drawing Handler
function OnDraw()

end

--Spell&Variable Retrieval
function OnProcessSpell(unit,spell)

end

--Object Tracking
function OnCreateObj(object)       

end

function OnDeleteObj(object) 

end

--Buff Tracking
function OnApplyBuff(source, unit, buff)

end

--Triggered when Key is Pressed.
function OnWndMsg(msg,wParam)

end

--Message Execution Section
function OnSendChat(text)

end

--D3D reset call: not used
function OnReset()

end

--Save After Games Ends
function OnUnload()

end

