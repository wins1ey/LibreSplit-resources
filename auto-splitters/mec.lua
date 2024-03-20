process('MirrorsEdgeCatalyst.exe')

local current =
{
	loading = false,
	mission = 0,
	canShift = false,
	inCutscene = false,
	endBanner = 0,
	movementState = 0,
	health = 0.0,
	y = 0.0
}

local old =
{
	loading = false,
	mission = 0,
	canShift = false,
	inCutscene = false,
	endBanner = 0,
	movementState = 0,
	health = 0.0,
	y = 0.0

}

local vars =
{
	inReleaseIntro = false,
	icarusWalk = false,
	vTol = false,
	hasPxFightStarted = false,
	pxTrain = false,
	shardTrain = false,
	shardCounter = 0
}

function startup()
	refreshRate = 120
end


function state()
	old.loading = current.loading
	old.mission = current.mission
	old.canShift = current.canShift
	old.inCutscene = current.inCutscene
	old.endBanner = current.endBanner
	old.movementState = current.movementState
	old.health = current.health
	old.y = current.y

	current.loading = readAddress('bool', 0x240C2B8, 0x4C1)
	current.mission = readAddress('uint', 0x0257C9D8, 0x20, 0x1858, 0x18)
	current.canShift = readAddress('bool', 0x0257C9D8, 0x20, 0x2D0, 0x18)
	current.inCutscene = readAddress('bool', 0x02577770, 0x70, 0xC0, 0, 0)
	current.endBanner = readAddress('byte', 0x0237DEB8, 0x218, 0x2F0, 0x8, 0x7BC)
	current.movementState = readAddress('uint', 0x2576FDC)
	current.health = readAddress('float', 0x2547F90, 0x28, 0, 0x20)
	current.y = readAddress('float', 0x02106A68, 0xD0, 0x128, 0x30, 0x54)
end

function update()
	if current.mission == 35 then
		if current.canShift then
			vars.icarusWalk = false
			vars.inReleaseIntro = false
		elseif current.inCutscene and not old.inCutscene and vars.inReleaseIntro then
			vars.icarusWalk = true
		end

		if current.health == 0 then
			vars.icarusWalk = false
		end

		if(current.inCutscene and not vars.inReleaseIntro) then
			vars.inReleaseIntro = true
		end
	else
		vars.inReleaseIntro = false
		vars.icarusWalk = false
	end

	if current.mission == 77 then
		if(current.movementState ~= 0) then
			vars.vTol = false
		elseif(old.movementState == 23) then
			vars.vTol = true
		end

		if(current.movementState == 26 or current.movementState == 27 or current.movementState == 20) then
			vars.hasPxFightStarted = true
		end
		if(health == 0) then
			vars.hasPxFightStarted = false
		end
		
		vars.pxTrain = old.loading and not current.loading and vars.hasPxFightStarted
	else
		vars.vTol = false
		vars.hasPxFightStarted = false
		vars.pxTrain = false
	end

	if current.mission == 91 then
		if (not old.inCutscene and current.inCutscene) or (old.inCutscene and not current.inCutscene) then
			vars.shardCounter = vars.shardCounter + 1
		end
		if(vars.shardCounter < 4) then
			vars.shardTrain = true
		else
			vars.shardTrain = false
		end
	else
		vars.shardTrain = false
		vars.shardCounter = 0
	end
end

function start()
	if current.mission == 35 and not current.inCutscene and old.inCutscene then
		print("start")
		return true
	end

	if current.mission ~= 35 and current.mission ~= 0 and old.loading and not current.loading then
		return true
	end
end


function split()
	if current.endBanner == 154 and old.endBanner ~= 154 then
		print("split")
		return true
	end

	if old.y and old.y > 1400 and current.y < 100 and current.y > 10 then
		print("split")
		return true
	end
end

function isLoading()
	if current.loading or vars.icarusWalk or vars.vTol or vars.pxTrain or vars.shardTrain then
		print("loading")
		return true
	end
end

