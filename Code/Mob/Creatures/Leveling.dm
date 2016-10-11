mob/var/SandKing = 0
atom/var
	Strength
	Agility
	Defence

var/ExperienceMultiplier=1
mob/proc/GainEXP(XP)
	if(CanBeSlaved) EXP+=(XP*ExperienceMultiplier)/2
	else EXP+=XP*ExperienceMultiplier
	LevelUp()
mob/proc/LevelUp()
	if(Level >= 100) return
	while(EXP >= EXPNeeded)
		if(Level >= 100) break
		EXP -= EXPNeeded
		EXPNeeded += 50
		EXPNeeded += Level / 3
		Level += 1
		Owner << "[src] has reached level [Level]!"
		switch(Race)
			if("Dwarf","Demon","Gargoyle","Frogman","Dragon") OrganMaxHP+=5
			if("Frogman","Vampire","Demon","Orc","Dwarf","Gargoyle","Svartalfar") OrganMaxHP+=3
			if("Human","Goblin","Illithid","Elf","Kobold","Zombie") OrganMaxHP+=2
			if("Ratman","Lizardman") OrganMaxHP+= 1.5
			if("Spider") OrganMaxHP += 1
			else OrganMaxHP += rand(0.75,1)
		if(OrganMaxHP > 600) OrganMaxHP = 600
		var/STR=0
		var/AGL=0
		var/INT=0
		var/DEF=0
		var/WEI=0
		var/POI=0
		var/WEB=0


		switch(Race)
			if("Devourer")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=0
			if("Skeleton")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Zombie")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Illithid")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Kobold")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Ratman")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Goblin")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Human")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Frogmen")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Elf")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Lizardman")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("HalfDemon")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Orc")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=5
			if("Dwarf")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=0
			if("Gargoyle")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=0
			if("Svartalfar")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=0
			if("Demon")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=0
			if("Spider")
			if("Queen")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=10
			if("Warrior")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=10
			if("Worker")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=0
			if("Hunter")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=0
			if("Vampire")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=0
			if("Werewolf")
				STR+=0.25;AGL+=0.25;DEF+=0.2;WEI+=5;INT+=0.01;POI+=0.25;WEB+=0
		Strength+=STR
		Agility+=AGL
		Intelligence+=INT
		Defence+=DEF
		PoisonDMG+=POI
		WebContent+=WEB
		MaxWebContent+=WEB
