extends Control

@onready var help_doc = $"Help Doc"
# Variable bringing the help_doc into the script to use as reference

const P1_KEYBINDS = ["p1_up", "p1_left", "p1_down", "p1_right", "p1_light_attack",
"p1_heavy_attack", "p1_block", "p1_dash"]
# Constant storing all of the player 1 key binds
const P2_KEYBINDS = ["p2_up", "p2_left", "p2_down", "p2_right", "p2_light_attack",
"p2_heavy_attack", "p2_block", "p2_dash"]
# Constant storing all of the player 2 key binds

var selecting_keybind: String = ""
# Varaible storing what keybind is currently being rebinded, empyty if none
var selected_keybind: Button = null
# Varabile storing what keybind is pressed


@export var is_in_pause_menu: bool = false
# A checkbox storing that the pause menu is in the menu


@onready var p1_binds = $P1_keybind_list
@onready var p2_binds = $P2_keybind_list
# Container holding the player binds


func _ready() -> void:
	build_keybind_list(P1_KEYBINDS, p1_binds)
	build_keybind_list(P2_KEYBINDS, p2_binds)
# Builds both players keybind list


func build_keybind_list(keybinds: Array, container: VBoxContainer) -> void:
	for keybind in keybinds:
		var button = Button.new()
		button.text = get_bind_text(keybind)
		button.pressed.connect(_on_bind_button_pressed.bind(keybind, button))
		container.add_child(button)
# For loop going through each keybind per keybinds and adds them to the list


func get_bind_text(keybind: String) -> String:
	var events = InputMap.action_get_events(keybind)
	if events.size() > 0:
		return keybind + ": " + events[0].as_text()
	return keybind + ": (unbound)"
# Returns the keybind name and what key they are binding it too


func _on_bind_button_pressed(keybind: String, button: Button) -> void:
	selecting_keybind = keybind
	selected_keybind = button
	button.text = "Press a key..."
# When a player presses a keybind button, it will listen for the players input


func _input(event: InputEvent) -> void:
	if selecting_keybind == "":
		return
# Returns the function if player is binding key already

	if event is InputEventKey and event.is_pressed():
		InputMap.action_erase_events(selecting_keybind)
		InputMap.action_add_event(selecting_keybind, event)
		selected_keybind.text = get_bind_text(selecting_keybind)
		selecting_keybind = ""
		selected_keybind = null
		get_viewport().set_input_as_handled()
# Remove the old keybind and replaces it with the new one updating the keybinds and stops listening for player input.


func _back() -> void:
	if is_in_pause_menu:
		visible = false
		get_parent().show_pause_buttons()
# If the options mneu was opened in the pause menu then it will hide and show the pause buttons
	else:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
# When the button is pressed outside the pause menu it will return the player back to the menu


func _on_full_screen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
# If the game is already in full screen then it will set the game to windowed
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
# Puts the game into fullscreen


func _on_help_doc_button_pressed() -> void:
	help_doc.visible = true
# When the help button is pressed the help doc becomes visible
