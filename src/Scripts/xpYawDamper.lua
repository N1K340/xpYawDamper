--[[
*****************************************************************************************
* xpYawDamper

* Objective:
*    - Read yaw moment
*	- Read YD status
*	- If YD is on, then adjust rudder trim to neutralise yaw moment providing aircraft is airborne
*	
* Changelog:
* v1.0 - Initial Release
* v1.1 - Changed settings to a menu UI
* v1.2 - Added feedback in the menu UI for rudder trim position and movement
* 
* Copyright (C) 2022  N1K340
* 
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License version 3 as published by
* the Free Software Foundation.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/gpl-3.0.html>.

*****************************************************************************************
--]]

--*************************************************************************************--
--** 					               modules                    		     		 **--
--*************************************************************************************--
require "graphics"
local LIP = require("LIP")

--*************************************************************************************--
--** 					               variables                   		     		 **--
--*************************************************************************************--
local xpYawSettings = {}
local xpUseScript = false
local xpYawDampSettingsWindow = false
local xpYawMoment = 0
local xpRudTrim = 0
local xpYawLoad = false
local status_txt = ""
local status_pl = ""
local status_m = ""


--*************************************************************************************--
--** 					               datarefs                 		     		 **--
--*************************************************************************************--
dataref("YAW_MOMENT", "sim/flightmodel2/misc/yaw_string_angle")
dataref("YD_STATUS", "sim/cockpit/switches/yaw_damper_on")
dataref("RUD_TRIM", "sim/cockpit2/controls/rudder_trim")
dataref("WEIGHT_ON_WHEELS", "sim/cockpit2/tcas/targets/position/weight_on_wheels", "readonly", 0)

--*************************************************************************************--
--** 					               	functions                    		     		 **--
--*************************************************************************************--

-- Save Settings
function WritexpYawDamperData(xpYawSettings)
	LIP.save(AIRCRAFT_PATH .. "/xpYawDamper.ini", xpYawSettings)
	print("xpYawDamper Settings Saved")
end

function CompilexpYawData()
	xpYawSettings = {
		xpYawDamperSettings = {
			xpUseScript = xpUseScript,
		}
	}
	WritexpYawDamperData(xpYawSettings)
end

function ParsexpYawData()
	local f = io.open(AIRCRAFT_PATH .. "/xpYawDamper.ini", "r")
	if f ~= nil then
		io.close(f)
		xpYawSettings = LIP.load(AIRCRAFT_PATH .. "/xpYawDamper.ini")
		xpUseScript = xpYawSettings.xpYawDamperSettings.xpUseScript
		print("xpYawDamper Settings Loaded")
		print("xpYawDamper plugin enabled set to " .. tostring(xpUseScript))
	else
		print("xpYawDamper Settings for aircraft not found")
	end
end

function xpYawDampInitialise()
	if xpYawLoad == false then
		ParsexpYawData()
		xpYawLoad = true
	end
end

do_sometimes("xpYawDampInitialise()")

-- Fuction of the yaw axis

function xpYawDampFuntion()
	if YD_STATUS == 1 and WEIGHT_ON_WHEELS == 0 then
		if xpYawMoment <= -0.01 and xpYawMoment >= -0.09 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim + 0.0001
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
			status_pl = "+"
			status_m = ""
		elseif xpYawMoment <= -0.1 and xpYawMoment >= -0.9 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim + 0.005
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
			status_pl = "++"
			status_m = ""
		elseif xpYawMoment <= -1.0 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim + 0.025
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
			status_pl = "+++"
			status_m = ""
		elseif xpYawMoment >= 0.01 and xpYawMoment <= 0.09 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim - 0.0001
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
			status_m = "-"
			status_pl = ""
		elseif xpYawMoment >= 0.1 and xpYawMoment <= 0.9 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim - 0.005
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
			status_m = "--"
			status_pl = ""
		elseif xpYawMoment >= 1.0 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim - 0.025
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
			status_m = "---"
			status_pl = ""
		elseif xpYawMoment >= -0.01 and xpYawMoment <= 0.01 then
			status_m = ""
			status_pl = ""
		end
	end
	-- Status Text
	if WEIGHT_ON_WHEELS == 1 then
		status_txt = "YD Not Active on the ground"
	end
	if WEIGHT_ON_WHEELS == 0 and YD_STATUS == 0 then
		status_txt = "YD is currently OFF"
	end
	if WEIGHT_ON_WHEELS == 0 and YD_STATUS == 1 then
		status_txt = "YD is currently ACTIVE"
	end
end

function xpYawDampSync()
	if YD_STATUS == 1 then
		if YAW_MOMENT ~= xpYawMoment then
			xpYawMoment = YAW_MOMENT
		end
	end
end

function xpYawDampMain()
	if xpUseScript == true then
		xpYawDampSync()
		xpYawDampFuntion()
	end
end

do_often("xpYawDampMain()")

--*************************************************************************************--
--** 					               Settings and GUI            		     		 **--
--*************************************************************************************--
-- Create and Destroy Settings Window
function OpenxpYawDampSettings_wnd()
	ParsexpYawData()
	xpYawDampSettings_wnd = float_wnd_create(400, 200, 1, true)
	float_wnd_set_title(xpYawDampSettings_wnd, "xpYawDamper Settings")
	float_wnd_set_imgui_builder(xpYawDampSettings_wnd, "xpYawDampSettings_content")
	float_wnd_set_onclose(xpYawDampSettings_wnd, "ClosexpYawDampSettings_wnd")
end

function ClosexpYawDampSettings_wnd()
	if xpYawDampSettings_wnd then
		float_wnd_destroy(xpYawDampSettings_wnd)
	end
end

-- Contents of Settings Window
function xpYawDampSettings_content(xpYawDampSettings_wnd, x, y)
	local winWidth = imgui.GetWindowWidth()
	local winHeight = imgui.GetWindowHeight()
	local titleText = "xpYawDamper Settings"
	local titleTextWidth, titleTextHeight = imgui.CalcTextSize(titleText)

	imgui.SetCursorPos(winWidth / 2 - titleTextWidth / 2, imgui.GetCursorPosY())
	imgui.TextUnformatted(titleText)

	imgui.Separator()
	imgui.TextUnformatted("")
	imgui.SetCursorPos(20, imgui.GetCursorPosY())
	local changed, newVal = imgui.Checkbox("Use xpYawDamper with this aircraft?", xpUseScript)
	if changed then
		xpUseScript = newVal
		CompilexpYawData()
		print("xpYawDamper: Plugin enabled changed to " .. tostring(xpUseScript))
	end
	imgui.TextUnformatted("")
	imgui.SetCursorPos(50, imgui.GetCursorPosY())
	imgui.TextUnformatted(status_txt)
	imgui.TextUnformatted("")
	imgui.SetCursorPos(50, imgui.GetCursorPosY())
	imgui.TextUnformatted("Current Yaw Trim position:")
	imgui.SetCursorPos(100, imgui.GetCursorPosY())
	imgui.TextUnformatted(status_m .. "   " .. string.format("%.4f", RUD_TRIM) .. "  " .. status_pl)
end

add_macro("View xpYawDamp Settings", "OpenxpYawDampSettings_wnd()", "ClosexpYawDampSettings_wnd()", "deactivate")
