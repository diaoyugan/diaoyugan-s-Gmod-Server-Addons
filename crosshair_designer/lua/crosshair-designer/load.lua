CrosshairDesigner = CrosshairDesigner or {}
CrosshairDesigner.VERSION = 3.33
CrosshairDesigner.WSID = 590788321

print("Loading crosshair designer (590788321)")

if SERVER then
	AddCSLuaFile("detours.lua")
	AddCSLuaFile("db.lua")
	AddCSLuaFile("hide.lua")
	AddCSLuaFile("calculate.lua")
	AddCSLuaFile("draw.lua")
	AddCSLuaFile("menu.lua")
	AddCSLuaFile("disable.lua")
	AddCSLuaFile("debug.lua")

	--[[
		Chat command to open menu - OnPlayerChat wasn't working in TTT
	]]--
	hook.Add("PlayerSay", "PlayerSayExample", function(ply, text, team)
		text = string.Trim(string.lower(text))

		if text == "!cross" or text == "!crosshair" or text == "!crosshairs" then
			ply:ConCommand("crosshairs")
			return text
		end
	end)

else
	include("detours.lua")
	include("db.lua")
	include("hide.lua")
	include("calculate.lua")
	include("draw.lua")
	include("menu.lua")
	include("disable.lua")
	include("debug.lua")

	--[[
		Setup the client convars and callbacks to verify values
	]]--
	CrosshairDesigner.SetUpConvars({ -- Must be in this order as it's the order the values are read from file
		{
			id="ShowHL2",
			var="toggle_crosshair_hide",
			default="0",
			help="显示HL2准星（默认准星）",
			title="显示HL2准星",
			isBool=true,
			menuGroup="cross"
		},
		{
			id="ShowCross",
			var="toggle_crosshair",
			default="1",
			help="隐藏自定义准星",
			title="显示自定义准星",
			isBool=true,
			menuGroup="cross"
		},
		{
			id="HideOnADS",
			var="cross_ads",
			default="1",
			help="使用瞄准镜时隐藏自定义准星",
			title="瞄准时隐藏自定义准星",
			isBool=true,
			menuGroup="hide"
		},
		{
			id="UseLine",
			var="cross_line",
			default="1",
			help="显示准星线",
			title="显示准星线",
			isBool=true,
			menuGroup="cross"
		},
		{
			id="LineStyle",
			var="cross_arrow",
			default="0",
			help="更改准星线的样式:\n0 = 长方形\n1 = 向内箭头\n2 = 向外箭头",
			title="准星线样式",
			min=0,
			max=2,
			menuGroup="cross"
		},
		{
			id="UseCircle",
			var="cross_circle",
			default="0",
			help="在准星中心增加一个点",
			title="准星中心点",
			isBool=true,
			menuGroup="cross" -- Only in this group because it makes sense in the menu
		},


		{
			id="Red",
			var="cross_hud_color_r",
			default="50",
			help="更改准星的红色量",
			min=0,
			max=255,
			isColour=true,
		},
		{
			id="Green",
			var="cross_hud_color_g",
			default="250",
			help="更改准星的绿色量",
			min=0,
			max=255,
			isColour=true,
		},
		{
			id="Blue",
			var="cross_hud_color_b",
			default="50",
			help="更改准星的蓝色量",
			min=0,
			max=255,
			isColour=true,
		},
		{
			id="Alpha",
			var="cross_hud_color_a",
			default="255",
			help="更改准星的透明度",
			min=0,
			max=255,
			isColour=true,
		},


		{
			id="Gap",
			var="cross_gap",
			default="8",
			help="更改准星的间隙大小",
			title="间隙大小",
			min=0,
			max=100,
			menuGroup="cross"
		},
		{
			id="Length",
			var="cross_length",
			default="7",
			help="改变准星线条长度",
			title="线条长度",
			min=2,
			max=100,
			menuGroup="cross"
		},
		{
			id="Thickness",
			var="cross_thickness",
			default="3",
			help="更改准星线条的长度",
			title="线条长度",
			min=1,
			max=100,
			menuGroup="cross"
		},
		{
			id="Stretch",
			var="cross_stretch",
			default="0",
			help="更改准星线的拉伸量(使用填充绘制时禁用)",
			title="准星线拉伸量",
			min=-180,
			max=180,
			menuGroup="cross"
		},
		{
			id="CircleRadius",
			var="cross_radius",
			default="0",
			help="当中心点启用时更改准星中心点的大小",
			title="中心点大小",
			min=0,
			max=100,
			menuGroup="circle"
		},
		{
			id="CircleSegments",
			var="cross_segments",
			default="0",
			help="当中心点启用时更改准星中心点的线段数",
			title="中心点线段",
			min=0,
			max=100,
			menuGroup="circle"
		},


		{
			id="ColOnTarget",
			var="hc_target_colour",
			default="1",
			help="在瞄准目标时改变准星的颜色",
			title="瞄准目标时改变颜色",
			isBool=true,
			menuGroup="cross-circle"
		},
		{
			id="TargetRed",
			var="target_cross_hud_color_r",
			default="250",
			help="当瞄准目标时准星中的红色量",
			min=0,
			max=255,
			isColour=true,
		},
		{
			id="TargetGreen",
			var="target_cross_hud_color_g",
			default="46",
			help="当瞄准目标时准星中的绿色量",
			min=0,
			max=255,
			isColour=true,
		},
		{
			id="TargetBlue",
			var="target_cross_hud_color_b",
			default="46",
			help="当瞄准目标时准星中的蓝色量",
			min=0,
			max=255,
			isColour=true,
		},
		{
			id="TargetAlpha",
			var="target_cross_hud_color_a",
			default="255",
			help="更改瞄准目标时准星的透明度",
			min=0,
			max=255,
			isColour=true,
		},


		{
			id="Dynamic",
			var="hc_dynamic_cross",
			default="0",
			help="使准星成为动态准星",
			title="动态准星",
			isBool=true,
			menuGroup="cross"
		},
		{
			id="DynamicSize",
			var="hc_dynamic_amount",
			default="50",
			help="动态准星启动时，准星的偏移量",
			title="动态效果大小",
			min=0,
			max=100,
			menuGroup="cross"
		},
		{
			id="HideInVeh",
			var="hc_vehicle_cross",
			default="1",
			help="在载具中时隐藏准星",
			title="载具中隐藏",
			isBool=true,
			menuGroup="hide"
		},

		-- NEW
		{
			id="HideInSpectate",
			var="crosshairdesigner_hideinspectate",
			default="1",
			help="在观看时隐藏准星",
			title="观看时隐藏准星",
			isBool=true,
			menuGroup="hide"
		},
		{
			id="HideTTT",
			var="crosshairdesigner_hidettt",
			default="1",
			help="隐藏TTT准星",
			title="隐藏TTT准星",
			isBool=true,
			menuGroup="hide"
		},
		{
			id="HideFAS",
			var="crosshairdesigner_hidefas",
			default="1",
			help="隐藏FA:S准星",
			title="隐藏FA:S准星",
			isBool=true,
			menuGroup="hide"
		},
		{
			id="HideCW",
			var="crosshairdesigner_hidecw",
			default="1",
			help="隐藏CW 2.0准星",
			title="隐藏CW准星",
			isBool=true,
			menuGroup="hide"
		},
		{
			id="TraceDraw",
			var="crosshairdesigner_tracedraw",
			default="0",
			help="Draw based on player angles",
			title="Centre to player angles",
			isBool=true,
			menuGroup="cross-circle"
		},

		-- Outline
		{
			id="Outline",
			var="crosshair_designer_outline",
			default="0",
			help="准星描边",
			title="描边",
			min=0,
			max=100,
			menuGroup="cross"
		},
		{
			id="OutlineRed",
			var="crosshair_designer_outline_r",
			default="0",
			help="修改描边红色量",
			min=0,
			max=255,
			isColour=true,
		},
		{
			id="OutlineGreen",
			var="crosshair_designer_outline_g",
			default="0",
			help="修改描边绿色量",
			min=0,
			max=255,
			isColour=true,
		},
		{
			id="OutlineBlue",
			var="crosshair_designer_outline_b",
			default="0",
			help="修改描边蓝色量",
			min=0,
			max=255,
			isColour=true,
		},
		{
			id="OutlineAlpha",
			var="crosshair_designer_outline_a",
			default="255",
			help="更改描边透明度",
			min=0,
			max=255,
			isColour=true,
		},

		-- Rotation
		{
			id="Rotation",
			var="crosshairdesigner_rotation",
			default="0",
			help="修改准星的旋转角度",
			title="旋转角度",
			min=0,
			max=360,
			menuGroup="cross"
		},

		-- Draw with polys instead of lines
		{
			id="FillDraw",
			var="crosshairdesigner_filldraw",
			default="0",
			help="绘制单个形状而不是多条线",
			title="填充绘制",
			isBool=true,
			menuGroup="cross"
		},
		{
			id="Segments",
			var="crosshairdesigner_segments",
			default="4",
			help="更改准星的线段数",
			title="线段数",
			min=1,
			max=100,
			menuGroup="cross"
		},
		{
			id="HideInCameraView",
			var="crosshairdesigner_hideincameraview",
			default="0",
			help="使用相机时隐藏准星",
			title="使用相机时隐藏准星",
			isBool=true,
			menuGroup="hide"
		},
		{
			id="InvertCol",
			var="crosshairdesigner_invertcol",
			default="0",
			help="反转准星颜色",
			title="准星反色",
			isBool=true,
			menuGroup="cross-circle"
		},
		{
			id="InvertOutlineCol",
			var="crosshairdesigner_invertoutlinecol",
			default="0",
			help="翻转描边颜色",
			title="描边反色",
			isBool=true,
			menuGroup="cross-circle"
		},
		{
			id="HighContrastInvertedCol",
			var="crosshairdesigner_highconstrastinvertedcol",
			default="0",
			help="强制反转颜色为黑色或白色",
			title="高对比度反转颜色",
			isBool=true,
			menuGroup="cross-circle"
		},
		{
			id="CrossXOffset",
			var="crosshairdesigner_crossxoffset",
			default="0",
			help="准星在水平轴上的偏移",
			title="准星X轴偏移",
			min=-25,
			max=25,
			menuGroup="cross"
		},
		{
			id="CrossYOffset",
			var="crosshairdesigner_crossyoffset",
			default="0",
			help="准星在垂直轴上的偏移",
			title="准星Y轴偏移",
			min=-25,
			max=25,
			menuGroup="cross"
		},
		{
			id="CircleXOffset",
			var="crosshairdesigner_circlexoffset",
			default="0",
			help="中心点在水平轴上的偏移",
			title="中心点X轴偏移",
			min=-25,
			max=25,
			menuGroup="circle"
		},
		{
			id="CircleYOffset",
			var="crosshairdesigner_circleyoffset",
			default="0",
			help="中心点在垂直轴上的偏移",
			title="中心点Y轴偏移",
			min=-25,
			max=25,
			menuGroup="circle"
		},
		{
			id="CircleRotation",
			var="crosshairdesigner_circlerotation",
			default="0",
			help="中心点旋转角度",
			title="中心点角度",
			min=0,
			max=360,
			menuGroup="circle"
		},
		{
			id="CircleOutlineThickness",
			var="crosshairdesigner_circleoutline",
			default="0",
			help="更改中心点描边",
			title="中心点描边",
			min=0,
			max=100,
			menuGroup="circle"
		},
	})

	--[[
		Crosshair checks

		Checks the currently held weapon and tries to read
		information from the weapon to workout if our
		custom crosshair should be hidden. Such as if
		the player is using the aiming down sights.
	]]--

	-- The more odd they are, the further down the
	-- list they should be placed, so they don't
	-- interfer with anything.
	--
	-- If they're specific then add the param
	-- forceOnBaseClasses, and they will be
	-- used before anything else

	-- Also use forceOnBaseClasses to speedup lookup
	-- for known combinations

	-- TFA -- thank you TFA for being simple!
	-- + Scifi weapons
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'GetIronSights',
		['fnIsValid'] = function(wep)
			return wep.GetIronSights ~= nil
		end,
		['fnShouldHide'] = function(wep)
			return wep:GetIronSights()
		end,
		['forceOnBaseClasses'] = {
			'tfa_gun_base'
		}
	})

	-- DarkRP special case for ls_sniper
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'ls_sniper',
		['fnIsValid'] = function(wep)
			return wep.GetIronsights ~= nil and wep:GetClass() == "ls_sniper"
		end,
		['fnShouldHide'] = function(wep)
			return wep:GetIronsights() and wep:GetScopeLevel() > 1
		end,
		['forceOnBaseClasses'] = {
			'weapon_cs_base2'
		}
	})

	-- DarkRP uses lower case sights
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'GetIron[s]ights',
		['fnIsValid'] = function(wep)
			return wep.GetIronsights ~= nil and wep:GetClass() ~= "ls_sniper"
		end,
		['fnShouldHide'] = function(wep)
			return wep:GetIronsights()
		end,
		['forceOnBaseClasses'] = {
			'weapon_cs_base2'
		}
	})

	-- If DarkRP has lower case sights, maybe some other addon has
	-- something similar with iron, or the whole thing
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'Get[i]ron[s]ights',
		['fnIsValid'] = function(wep)
			return wep.Getironsights ~= nil
		end,
		['fnShouldHide'] = function(wep)
			return wep:Getironsights()
		end,
	})
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = '[g]et[i]ron[s]ights',
		['fnIsValid'] = function(wep)
			return wep.getironsights ~= nil
		end,
		['fnShouldHide'] = function(wep)
			return wep:getironsights()
		end,
	})

	-- Modern Warfare 2459720887
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'GetIsAiming',
		['fnIsValid'] = function(wep)
			return wep.GetIsAiming ~= nil
		end,
		['fnShouldHide'] = function(wep)
			return wep:GetIsAiming()
		end
	})

	-- ArcCW
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'ArcCW',
		['fnIsValid'] = function(wep)
			return wep.Sighted ~= nil and ArcCW ~= nil
		end,
		['fnShouldHide'] = function(wep)
			return wep.Sighted or wep:GetState() == ArcCW.STATE_SIGHTS
		end,
		['forceOnBaseClasses'] = {
			'arccw_base'
		}
	})

	-- DayOfDefeat weapons
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'GetNetworkedBool Iron[s]ights',
		['fnIsValid'] = function(wep)
			return wep.Weapon ~= nil and
				wep.Weapon:GetNetworkedBool("Ironsights", nil) ~= nil
		end,
		['fnShouldHide'] = function(wep)
			return wep.Weapon:GetNetworkedBool("Ironsights", false)
		end
	})

	-- Potentially another with IronSights
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'GetNetworkedBool IronSights',
		['fnIsValid'] = function(wep)
			return wep.Weapon ~= nil and
				wep.Weapon:GetNetworkedBool("IronSights", nil) ~= nil
		end,
		['fnShouldHide'] = function(wep)
			return wep.Weapon:GetNetworkedBool("IronSights", false)
		end
	})

	-- FA:S
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'FA:S',
		['fnIsValid'] = function(wep)
			return wep.dt ~= nil and wep.dt.Status ~= nil
		end,
		['fnShouldHide'] = function(wep)
			return wep.dt.Status == FAS_STAT_ADS
		end,
		['forceOnBaseClasses'] = {
			'fas2_base',
		},
		['onSwitch'] = function(wep)
			-- Hide FA:S 2 crosshair by setting alpha to 0
			if not wep.CrosshairDesignerDetoured then
				local original = wep.DrawHUD

				wep.CrosshairDesignerDetoured = true
				wep.DrawHUD = function(...)
					if CrosshairDesigner.GetBool('HideFAS') then
						wep.CrossAlpha = 0
						-- Temp set firemode to safe to force cross alpha to 0
						-- Also temp hide grenade crosshair
						local originalVehicle = wep.Vehicle
						wep.Vehicle = true

						-- Call original draw hud
						local drawHUDResult = original(...)

						-- Revert back overrides
						wep.Vehicle = originalVehicle

						return drawHUDResult
					else
						return original(...)
					end
				end
			end
		end
	})

	-- CW 2.0
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'CW 2.0',
		['fnIsValid'] = function(wep)
			return wep.dt ~= nil and wep.dt.State ~= nil
		end,
		['fnShouldHide'] = function(wep)
			return wep.dt.State == CW_AIMING
		end,
		['forceOnBaseClasses'] = {
			'cw_base',
		}
	})

	-- M9K Legacy
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'M9K Legacy',
		['fnIsValid'] = function(wep)
			return wep.GetIronSights ~= nil and
				wep.IronSightsPos ~= nil and
				wep.RunSightsPos ~= nil and
				not MMM_M9k_IsBaseInstalled
		end,
		['fnShouldHide'] = function(wep)
			return wep:GetIronSights() and
				wep.IronSightsPos ~= wep.RunSightsPos
		end,
		['forceOnBaseClasses'] = {
			'bobs_gun_base',
			'bobs_scoped_base',
			'bobs_shotty_base'
		}
	})

	-- M9K Remastered -- scoped
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'M9K Remastered scoped',
		['fnIsValid'] = function(wep)
			return wep:GetNWInt("ScopeState", nil) ~= nil and
				MMM_M9k_IsBaseInstalled
		end,
		['fnShouldHide'] = function(wep)
			return wep.IronSightState or
				wep:GetNWInt("ScopeState") > 0
		end,
		['forceOnBaseClasses'] = {
			'bobs_scoped_base',
		}
	})

	-- M9K Remastered -- un scoped
	CrosshairDesigner.AddSWEPCrosshairCheck({
		['id'] = 'M9K Remastered un scoped',
		['fnIsValid'] = function(wep)
			return wep.IronSightState ~= nil and
				MMM_M9k_IsBaseInstalled
		end,
		['fnShouldHide'] = function(wep)
			return wep.IronSightState ~= nil and
				wep.IronSightState
		end,
		['forceOnBaseClasses'] = {
			'bobs_gun_base',
			'bobs_shotty_base'
		}
	})

	-- Disable Target Cross for Prop Hunt and Guess Who to stop cheating
	local gm = engine.ActiveGamemode()
	if gm == "prop_hunt" then
		CrosshairDesigner.DisableFeature("ColOnTarget", false, "Giving away positions in Prop Hunt!")
	elseif gm == "guesswho" then
		CrosshairDesigner.DisableFeature("ColOnTarget", false, "Giving away positions in Guess Who!")
	end

	-- Directory where everything is saved
	if not file.IsDir( "crosshair_designer", "DATA" ) then
		file.CreateDir( "crosshair_designer", "DATA" )
	end
	if not file.IsDir( "crosshair_designer/debug", "DATA" ) then
		file.CreateDir( "crosshair_designer/debug", "DATA" )
	end
end

print("Finished loading crosshair designer (590788321)")
hook.Run("CrosshairDesigner_FullyLoaded", CrosshairDesigner)