# xpYawDamper

** Updated 18 Sep 2022 **

FlyWithLUA script to provide an active yaw damper system within XP11 and XP12.
When engaged, the script will attempt to neutralise yawing moments through the use of the rudder trim controls.

## Prerequisite

This plugin uses the FlyWithLUA plugin to interface with X-Plane.
It is available free from [x-plane.org](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/) 

Luna INI Parser (LIP) is included as an additional plugin module for use with FlyWithLua. This module allows for the saving and reading of settings data within LUA. It has been included in this package under the MIT Licence offered by creator [Carreras Nicholas.](https://github.com/Dynodzzo/Lua_INI_Parser) This is a common plugin, it may already exist in your modules folder causing a prompt to overwrite.

## Installation

Copy the Scripts and Modules folder into the main folder of FlyWithLUA: 
X-Plane 11 > Resources > plugins > FlyWithLua

## Application

xpYawDamper will initialise inactive on every aircraft.
In order to use the active yaw damper system open the menu by selecting:
    Plugins > FlyWithLua > FlyWithLua Macros > View xpYawDamp Settings

![xpYD](https://github.com/N1K340/xpYawDamper/blob/f5361176df047f72de71f60b90c7cb86bac52de1/src/xpYD_Menu.JPG)

Enable the plugin by selecting the checkbox. This will need to be completed for each aircraft you wish to use the plugin with.

Once enabled, the rudder trim will be driven to neutralise the yaw moment, providing:
- The Yaw Damper is selected ON;
- The aircraft is in the air.

A current rudder trim position readout is provided. It is flanked by two indicators:
- +++ Indicating it is commanding right rudder trim
- --- Indicating it is commanding left rudder trim

The number of trim icons denotes the amount of trim being applied, with three being the most aggressive.

## Disclaimer / Feedback

This package is to be distributed as Freeware only under the GPL v3 license.
Use of this code in other freeware projects is permitted with acknowledgment.

## Change Log

* v1.0 - Initial Release.
* v1.1 - Changed settings to a menu UI
* v1.2 - Added feedback in the menu UI for rudder trim position and movement
