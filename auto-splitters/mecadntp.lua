process("MirrorsEdgeCatalyst.exe")

local current =
{
	contentActive = false,
	loading = false,
	dashStarted = false,
	inMenu = false
}

local old =
{
	contentActive = false,
	loading = false,
	dashStarted = false,
	inMenu = false
}

function startup()
	refreshRate = 120
end

function state()
	old.contentActive = current.contentActive
	old.loading = current.loading
	old.dashStarted = current.dashStarted
	old.inMenu = current.inMenu

	current.contentActive = readAddress("bool", "MirrorsEdgeCatalyst.exe", 0x257E7C8, 0x28, 0x280)
	current.loading = readAddress("bool", "MirrorsEdgeCatalyst.exe", 0x240C2B8, 0x4C1)
	current.dashStarted = readAddress("bool", "MirrorsEdgeCatalyst.exe", 0x0257C9D0, 0xE0)
	current.inMenu = readAddress("bool", "MirrorsEdgeCatalyst.exe", 0x25946E4)
end

function split()
	if ((not current.dashStarted and old.dashStarted) and (not current.inMenu) and not current.loading) then
		return true
	end
end

function start()
	if(current.contentActive and not old.contentActive and not current.inMenu and not current.loading) then
		return true
	end
end

function isLoading()
	if current.loading then
		return true
	end
end
