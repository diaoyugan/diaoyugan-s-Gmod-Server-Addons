if SERVER then
	AddCSLuaFile("crosshair-designer/load.lua")
	include("crosshair-designer/load.lua")
else
	include("crosshair-designer/load.lua")
end
resource.AddWorkshop( "590788321")