/client/preload_rsc = 1

/world/view = 9
//hub = "Ginseng.DungeonMaster"
/world/hub = "Godsring.DungeonMaster"
/world/version = 1.102
/world/fps=30
/world/map_format = TOPDOWN_MAP
/world/status = "Dungeon Master:Official Server RP/PVP"
/world/New()
	..()
	log = file("world.log")
	NightChange()
	Repop()
	BirthChanges()
	CallSave()
	LoadWinfo()
	spawn(30)
		SeasonsCneck()
	spawn(20)
		Seasons()

var/Season = "Winter"
var/WorldName
var/Date
var/History
var/Legends
var/Ages
var/night = 1
var/PlayerList = list()
/proc/LoadWorld()
	spawn(10)
		LoadWinfo()
		return
var/client/mouse_pointer_icon(cursor.dmi)