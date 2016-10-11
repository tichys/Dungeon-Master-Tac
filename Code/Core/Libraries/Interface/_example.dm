

/************* INITIALIZE PANEL CONTROLLER *************/
// The first thing you need to do to initialize this library is to turn
// the client's panel_controller variable into a new panel controller,
// and specify which window child, macro set and default panel to use.
client
	New()
		..()
		src.panel_controller = new(src, "default", "default.child", "title")




/************* TITLE SCREEN PANEL *************/
// The title panel is the first thing that you'll see when you load the demo.
// It comes with a custom variable that keeps track of how many times you
// have visited the title panel, and that variable increments each time you
// visit. When you've visited a certain number of times, it will send new
// messages to the player.
panel/title
	ref = "title"

	var
		// This is a list of the options on the title screen.
		list/options = list("newgame", "guide", "info","quit")

		// This is the option that is currently selected.
		selected = "newgame"

	// When the panel is loaded, the welcome message will change to reflect
	// the player's key name, and the first option will highlight.
	Load(client/C)
		winset(C, "title.name_display", "text=\"Welcome, [C]!\"")
		src.Select(C, selected)

	// Removes the highlight from the previous selection and highlights the
	// new selection.
	proc/Select(client/C, option)
		winset(C, "title.[src.selected]", "text-color=#000000")
		winset(C, "title.[option]", "text-color=#FF0000")
		src.selected = option

	// The north key will cause the menu to select the next option up, unless
	// the top option is selected, then it will select the bottom option.
	proc/North(client/C)
		var/position = options.Find(src.selected)
		if(position == 1)
			src.Select(C, src.options[src.options.len])
		else
			src.Select(C, src.options[position-1])
		return

	// The south key will cause the menu to select the next option down, unless
	// the bottom option is selected, then it will select the top option.
	proc/South(client/C)
		var/position = src.options.Find(src.selected)
		if(position == src.options.len)
			src.Select(C, src.options[1])
		else
			src.Select(C, src.options[position+1])
		return

	// Hitting the 'enter' key will activate whichever option is selected, which
	// means either taking them to the map, to the info page, or quitting the game.
	proc/Return(client/C)
		switch(src.selected)
			if("newgame")
				C.SetPanel("map")
			if("info")
				C.SetPanel("info")
			if("quit")
				world.Del()
			if("guide")
				world.Del()

	// These are just secondary keys which do the same thing as the primary keys.
	proc/Numpad8(client/C)
		src.North(C)

	proc/Numpad2(client/C)
		src.South(C)

	proc/Center(client/C)
		src.Return(C)

	// Escape key quits the "game".
	proc/Escape(client/C)
		world.Del()




/************* MAP / GAME PANEL *************/
// The game panel houses the map, and lets the player move around using the
// cardinal arrow keys or numpad keys.
panel/map
	ref = "map"

	// Using arrow keys allows the client to move its mob around the map.
	proc/North(client/C)
		C.North()

	proc/East(client/C)
		C.East()

	proc/South(client/C)
		C.South()

	proc/West(client/C)
		C.West()

	// Numpad arrow keys do the same as regular arrow keys.
	proc/Numpad8(client/C)
		C.North(C)

	proc/Numpad6(client/C)
		C.East(C)

	proc/Numpad2(client/C)
		C.South(C)

	proc/Numpad4(client/C)
		C.West(C)

	// Escape takes the player to their previous panel.
	proc/Escape(client/C)
		C.SetPanel(C.panel_controller.previous)





/************* INFORMATION / CREDITS PANEL *************/
// This panel contains information about the game as well as some credits. The
// only controls necessary are the escape key which takes you back to the title.
panel/info
	ref = "info"

	// Escape takes the player to their previous panel.
	proc/Escape(client/C)
		C.SetPanel(C.panel_controller.previous)





