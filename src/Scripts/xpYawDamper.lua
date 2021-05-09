--[[ Starting a new file, what an idiot
xpYawDamper
Objective:
    - Read yaw moment
	- Read YD status
	- If YD is on, then adjust rudder trim to neutralise yaw moment
    ]]

if not SUPPORTS_FLOATING_WINDOWS then
  -- to make sure the script doesn't stop old FlyWithLua versions
  logMsg("imgui not supported, please update to latest version of FlyWithLUA")
  return
  else
  print("xpYawDamper Loaded")
end

-- Modules
require "graphics"
local LIP = require("LIP")

-- Variables
 local xpYawSettings = {}
 local xpUseScript = false
 local xpYawMoment = 0
 local xpRudTrim = 0
 local xpYawLoad = false
 

-- Datarefs
dataref("YAW_MOMENT", "sim/flightmodel2/misc/yaw_string_angle")
dataref("YD_STATUS", "sim/cockpit/switches/yaw_damper_on")
dataref("RUD_TRIM", "sim/cockpit2/controls/rudder_trim")
dataref("WEIGHT_ON_WHEELS", "sim/cockpit2/tcas/targets/position/weight_on_wheels", "readonly", 0)

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
	local f = io.open(AIRCRAFT_PATH .. "/xpYawDamper.ini","r")
	if f ~= nil then 
		io.close(f) 
		xpYawSettings = LIP.load(AIRCRAFT_PATH .. "/xpYawDamper.ini")
		xpUseScript = xpYawSettings.xpYawDamperSettings.xpUseScript
		print("xpYawDamper Settings Loaded")
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

do_sometimes ("xpYawDampInitialise()")



function xpYawDampFuntion()
	if YD_STATUS == 1 and WEIGHT_ON_WHEELS == 0 then
		if xpYawMoment <= -0.01 and xpYawMoment >= -0.09 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim + 0.0001
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
		elseif xpYawMoment <= -0.1 and xpYawMoment >= -0.9 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim + 0.005
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
		elseif xpYawMoment <= -1.0 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim + 0.025
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)	
			
		elseif xpYawMoment >= 0.01 and xpYawMoment <= 0.09 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim - 0.0001
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
		elseif xpYawMoment >= 0.1 and xpYawMoment <= 0.9 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim - 0.005
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
		elseif xpYawMoment >= 1.0 then
			xpRudTrim = RUD_TRIM
			xpRudTrim = xpRudTrim - 0.025
			set("sim/cockpit2/controls/rudder_trim", xpRudTrim)
			print("Yaw moment is " .. xpYawMoment .. " Rudder trim changed to " .. xpRudTrim)
		end
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

function xpYawDampUse()
	xpUseScript = true
	print("User enabled xpYawDamper Script")
	CompilexpYawData()
end

function xpYawDampDontUse()
	xpUseScript = false
	print("User disabled xpYawDamper Script with a baseball bat")
	CompilexpYawData()
end

add_macro("Enable xpYawDamper for this Aircraft", "xpYawDampUse()")
add_macro("Turn Off xpYawDamper", "xpYawDampDontUse()")
