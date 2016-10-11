


panel_controller

	var

		// The client that the controller belongs to.
		client/owner

		// This is the name of the child window to display the panels in.
		// The panels will not function if no window is set.
		window = "default.child"

		// This is the default macro set to add the additional macros to.
		// It should be a blank macro set ideally.
		macro = "panel_macro_set"

		// By default, the left side of the window is used to display
		// panels in. If you change this, panels will start being loaded
		// in the right side instead, and the left side will be unchanged
		// until you set this back and load a different panel.
		side = "left"

		// The panel which is currently being displayed.
		current

		// The panel which was displayed prior to the current one.
		previous

		// This is the actual panel datum being displayed.
		panel/display_panel

		// When the new controller is created, it will loop through all
		// existing panel types and create a new instance of them, then
		// associate them by their 'ref' to the panel datum. This way
		// each panel can be referred to by its name.
		list/panels = list()


// When a new controller is created, a new owner, a child control and a
// macro set to use must be provided as arguments, as well as a somewhat
// optional default window. The controller will then use the child control
// to display all panels in, and will assign the provided macro set to
// all loaded windows. When newly created, the controller will create a
// its own set of macros on top of the specified macro set, and will create
// a list of available panels to refer to.
	New(new_owner, window, child_control, default, rep=1)

		// If the new controller settings can not be set properly. then
		if(!VerifySettings(new_owner, window, child_control))
			del(src)
			return

		src.owner = new_owner
		src.window = child_control
		usr = src.owner

		// Create a macro for each key under the name of that key.
		src.CreateMacros(rep)

		// Create an instance of each panel.
		src.CreatePanels()

		// Tell the specified window to use the generated macro set.
		winset(src.owner, window, "macro=[src.macro]")

		// Load the default window if there is one.
		if(default)
			src.SetPanel(default)
		return


// This is used to verify that all of the arguments sent to the New() proc
// are valid arguments. If they are not, then the new controller datum will
// self-delete after it is created.
	proc/VerifySettings(new_owner, window, child_control)
		if(!new_owner)
			CRASH("No panel controller owner specified.")
			return 0
		if(!istype(new_owner, /client))
			CRASH("Panel controllers must be owned to type /client.")
			return 0
		if(!window)
			CRASH("Could not setup panel controller, no window specified.")
			return 0
		if(!child_control)
			CRASH("Could not setup panel controller, no child specified.")
			return 0
		if(!winexists(new_owner, window))
			CRASH("Could not setup panel controller, specified window does not exist.")
			return 0
		if(!winexists(new_owner, child_control))
			CRASH("Could not setup panel controller, specified child does not exist.")
			return 0
		return 1


// Create a new instance of each panel when the new controller is
// created and associate that instance with its name in the
// controller's panels list.
	proc/CreatePanels()
		for(var/panel_type in typesof(/panel) - /panel)
			var/panel/panel = new panel_type
			src.AddPanel(panel)
		return


// Adds a new panel datum to the controller's panels listing. This can be
// used to add new panels during runtime as well.
	proc/AddPanel(panel/panel)
		if(!panel.ref)
			return 0
		src.panels[panel.ref] = panel
		return 1


// This function creates a list of all possible keys on the keyboard, then
// creates new macros for each key along all possible combinations of Alt,
// Ctrl and Shift.
	proc/CreateMacros(rep=1)
		var/list
			combos = list("","ALT+","CTRL+","ALT+CTRL+","SHIFT+",
				"ALT+SHIFT+","CTRL+SHIFT+","ALT+CTRL+SHIFT+")
			combos_text = list("","Alt","Ctrl","AltCtrl","Shift",
				"AltShift","CtrlShift","AltCtrlShift")
			symbols = list(
				"`" = "Acute",
				"\[" = "OpenBracket",
				"]" = "CloseBracket",
				";" = "Semicolon",
				"'" = "Apostrophe",
				"," = "Comma",
				"." = "Period",
				"/" = "Forwardslash",
				"\\" = "Backslash",
				"-" = "Hyphen",
				"=" = "Equals",
				"<" = "GreaterThan",
				">" = "LesserThan",
				)
			nonprintable = list(
				"Northwest", "North", "Northeast", "West", "Center", "East",
				"Southwest", "South", "Southeast", "Return", "Escape", "Tab",
				"Space", "Back", "Delete", "Pause", "Select", "Execute",
				"Snapshot", "Insert", "Help", "LWin", "RWin", "Apps", "Numpad0",
				"Numpad1", "Numpad2", "Numpad3", "Numpad4", "Numpad5", "Numpad6",
				"Numpad7", "Numpad8", "Numpad9", "Multiply", "Add", "Separator",
				"Subtract", "Decimal", "Divide", "F1", "F2", "F3", "F4", "F5",
				"F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15",
				"F16", "F17", "F18", "F19", "F20", "F21", "F22", "F23", "F24",
				"Attn", "CrSel", "ExSel", "ErEOF", "Play", "Zoom", "PA1",
				"OEMClear")
			keys = list()

		// Add non-printable keys.
		for(var/n in nonprintable)
			keys[n] = n

		// Add symbol keys.
		keys += symbols

		// Add letter keys.
		for(var/n in 97 to 122)
			var/letter = uppertext(ascii2text(n))
			keys[letter] = letter

		// Add number keys.
		for(var/key in 0 to 9)
			keys["[key]"] = "Num[key]"

		winclone(src.owner, "macro", src.macro)

		// Add each key along with variations to the macros. This will override
		// any old macros that existed in this interface macro set.
		for(var/key in keys)
			for(var/combo in 1 to combos_text.len)
				var/text_key = "[combos_text[combo]][keys[key]]"
				var/combo_key = "[combos[combo]][key][rep?"+REP":""]"

				winset(src.owner, "[text_key]",
					"parent=[src.macro];name=[combo_key];command=\"CallPanelMacro [text_key]\"")
		return


// This set the current panel to the previous panel and unloads it,
// while setting the new panel to the current panel and loading the
// new panel. If the previous panel fails to unload, the new panel
// will not load.
	proc/SetPanel(panel_ref)
		if(!panel_ref)
			CRASH("Invalid panel reference: [panel_ref]")
			return 0

		if(!IsValid(panel_ref))
			CRASH("No such panel exists: [panel_ref]")
			return 0

		// Swap panels
		src.previous = src.current
		src.current = panel_ref

		// Designate the datum for the current panel.
		src.display_panel = src.panels[src.current]

		// Unload previous panel if there is one.
		if(src.previous)
			src.UnloadPanel(src.panels[src.previous])

		// Load the new panel.
		src.LoadPanel(src.display_panel)

		// Display the new panel.
		winset(src.owner, src.window, "[src.side]=[src.display_panel.ref]")
		return


	// If a previous panel is available, load the previous panel.
	proc/PreviousPanel()
		if(src.previous)
			src.SetPanel(src.previous)
			return 1
		return 0


// Loads the specified panel into view.
	proc/LoadPanel(panel/panel)
		panel.Load(src.owner)
		panel.loaded = 1
		return


// Unload the specified panel.
	proc/UnloadPanel(panel/panel)
		panel.Unload(src.owner)
		panel.loaded = 0
		return


// Check to see whether a panel by this reference exists.
	proc/IsValid(panel_name)
		if(!src.panels[panel_name])
			return 0
		return 1


// Switches the side of the child window to be used from left ro right or
// from right to left.
	proc/SwitchSides()
		if(src.side == "left")
			src.side = "right"
		else
			src.side = "left"
		return








panel

	var

		// this is the element name for the panel's child window
		ref = "panel"

		// If true, then the panel has finished loading.
		loaded = 0

// This is used for setting up the display before the player
// actually gets to view it. So any information that needs to
// be updated before showing the player is updated in this proc.
	proc/Load(client/player)
		return 1

// Works on the same premise as Load(), only this is used for
// changing things around when the player is done viewing it.
	proc/Unload(client/player)
		return 1

// This is checked whenever the player presses a macro key. If
// this returns true (and by default it always does), then the
// macro is called. But if for some reason you want to lock
// all of the macro keys on the panel, override this.
	proc/KeyPress(client/player, key)
		return 1







client

	var

		// Used to reference the controller.
		panel_controller/panel_controller


	// This verb is used by the interface macros created by the panel
	// controller in order to call the procs associated with each key
	// that each panel uses.
	verb/CallPanelMacro(key as text)
		set hidden = 1
		if(src.panel_controller)
			if(src.panel_controller.display_panel)
				if(hascall(src.panel_controller.display_panel, key))
					if(src.panel_controller.display_panel.KeyPress(src, key))
						call(src.panel_controller.display_panel, key)(src)
		return

	// This verb is used in interface elements to load the specified panel.
	// Use it in commands like: 'SetPanel title', and it will load the
	// "title" panel.
	verb/SetPanel(panel as text)
		set hidden = 1
		if(src.panel_controller.IsValid(panel))
			src.panel_controller.SetPanel(panel)
		else
			world.log << "Invalid panel: [panel]"
			return




