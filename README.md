# xpYawDamper
FlyWithLUA script to provide an active yaw damper system within XP11.

Prerequisite
============
This plugin uses the FlyWithLUA plugin to interface with X-Plane.
It is available freely from [x-plane.org](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/) 

Luna INI Parser (LIP) is included as an additional plugin module for use with FlyWithLua. This module allows for the saving and reading of settings data within LUA. It has been included in this package under the MIT Licence offered by creater [Carreras Nicholas.](https://github.com/Dynodzzo/Lua_INI_Parser)

This is a common plugin, it may already exist in your modules folder causing a prompt to overwrite.

Installation
============

Copy the Scripts and Modules folder into the main folder of FlyWithLUA: 
X-Plane 11 > Resources > plugins > FlyWithLua

Application
============
This script will start inactive. In order to use the active yaw damper feature with an aircraft, you will need to enable it:
Select enable / disable from the Plugins > FlyWithLua > Macros menu.

![xpYD](https://github.com/N1K340/xpYawDamper/blob/f5361176df047f72de71f60b90c7cb86bac52de1/src/xpYD_Menu.JPG)

Once enabled, the rudder trim will be driven to neutralise the yaw moment, providing:
a) The Yaw Damper is selected ON;
b) The aircraft is in the air.

Disclaimer / Feedback
=====================

This package is to be distributed as Freeware only.
Installation and use of this package is at your own risk. 

Change Log
==========
* v1.0 - Initial Release.
