
/*******************************************************************************************

	PANEL LIBRARY
	Created by Foomer (2009)

	What this library does is allow you to easily change the contents of the game's primary
	window using a child control, window panes and customizable panel datums.


	SETUP:

		1. Create a default window, and create a child control inside of it. Stretch the child
			 control to fill the window and anchor it there.

		2. Each panel that you'll display in the child control needs to be a pane. So to begin
			 create a pane for your title screen. If you want to have buttons, the library
			 includes a client verb called SetPanel() which lets you display a new panel through
			 the interface. Just create a button and set its command to "SetPanel panel_name".

		3. Now create a /panel datum, and give it a ref value that matches the name of the
			 pane which you just created. For example, if you just create a pane called "title",
			 then create a /panel datum that looks like this:

					panel/title
						ref = "title"

			 Remember, the ref must be equal to the name of the pane in the interface.

		4. Initialize the panel controller in client/New(). Specify the owner of the panel, the
			 window which the child control is being displayed in, the name of the child control,
			 and the name of the first panel to display in the child control, like this:

					client
						New()
							..()
							src.panel_controller = new(src, "default", "default.child", "title")

		5. You may now create additional panes for use as panels. Make sure to create /panel
			 datums for them, and remember to anchor your controls so they will stretch properly.

	An example is included with this demo to show you how everything works and what the
	possible uses for this library are.



	ADDITIONAL FUNCTIONS:

	Whenever a new panel is loaded, the panel that was previously displayed will call the
	panel.Unload(client) function, and the panel being loaded will call panel.Load(client).
	These can be used to change things in the panel before or after they are loaded, such
	as changing the displayed information to reflect the player's name like in the example.



	DEFINING PANEL MACROS:

	For each panel, different keys will have different results. In order for a keystroke to be
	recognized, however, it must be defined a proc. A list of proc names which are used to
	define macros will be provided here, but you can also require that the Alt, Ctrl or Shift
	keys be part of those macros.

	Suppose you want a macro for the 'A' key, you'd define it like this:

			panel/mypanel
				proc/A(client/player)
					player << "You pressed A!"

	However, if you wanted your macro to be Ctrl+A, you'd define it like this:

			panel/mypanel
				proc/CtrlA(client/player)
					player << "You pressed Ctrl+A!"

	You can use Alt, Ctrl or Shift keys in any combination by appending the appropriate prefix
	to the proc name, as is shown here:

			panel/mypanel
				proc
					A()
					AltA()
					CtrlA()
					ShiftA()
					AltCtrlA()
					AltShiftA()
					CtrlShiftA()
					AltCtrlShiftA()

	The Alt, Ctrl and Shift keys must prefix the procs in the order that they are shown here.
	If they are out of order, such as ShiftAltCtrlA(), then the macro will not be recognized.

	Here is a list of keys that can be used for macros:

	A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, R, X, Y, Z, Num0,
	Num1, Num2, Num3, Num4, Num5, Num6, Num7, Num8, Num9, Northwest, North, Northeast, West,
	Center, East, Southwest, South, Southeast, Return, Escape, Tab, Space, Back, Delete,
	Pause, Select, Execute, Snapshot, Insert, Help, LWin, RWin, Apps, Numpad0, Numpad1,
	Numpad2, Numpad3, Numpad4, Numpad5, Numpad6, Numpad7, Numpad8, Numpad9, Multiply, Add,
	Separator, Subtract, Decimal, Divide, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12,
	F13, F14, F15, F16, F17, F18, F19, F20, F21, F22, F23, F24, Attn, CrSel, ExSel, ErEOF,
	Play, Zoom, PA1, OEMClear, Acute, OpenBracket, CloseBracket, Semicolon, Apostraphe,
	Comma, Period, Forwardslash, Backslash, Hyphen, Equals, GreaterThan and LesserThan.

	It should also be noted that every time a macro is used, the panel.KeyPress(client, key)
	proc will be called as well. So if you want to lock keys or detect when a key has been
	pressed, then you can do it through the KeyPress function.




*******************************************************************************************/
