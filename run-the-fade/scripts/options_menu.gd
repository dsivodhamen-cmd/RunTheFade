extends Control

@onready var help_doc = $"Help Doc"

var p1_keybinds = ["p1_up", "p1_left", "p1_down", "p1_right", "p1_light_attack",
"p1_heavy_attack", "p1_block", "p1_dash"]
# variable storing all of the player 1 key binds
var p2_keybinds = ["p2_up", "p2_left", "p2_down", "p2_right", "p2_light_attack",
"p2_heavy_attack", "p2_block", "p2_dash"]
# varaible storing all of the player 2 key binds

var selecting_keybind: String = ""
# varaible storing what keybind is currently being rebinded, empyty if none
var selected_keybind: Button = null
# varabile storing what keybind is pressed


@export var is_in_pause_menu: bool = false
# a checkbox storing that the pause menu is in the menu


@onready var p1_binds = $P1_keybind_list
@onready var p2_binds = $P2_keybind_list
# container holding the player binds


func _ready() -> void:
	build_keybind_list(p1_keybinds, p1_binds)
	build_keybind_list(p2_keybinds, p2_binds)
# builds both players keybind list


func build_keybind_list(keybinds: Array, container: VBoxContainer) -> void:
	for keybind in keybinds:
		var button = Button.new()
		button.text = get_bind_text(keybind)
		button.pressed.connect(_on_bind_button_pressed.bind(keybind, button))
		container.add_child(button)
# for loop going through each keybind per keybinds and adds them to the list


func get_bind_text(keybind: String) -> String:
	var events = InputMap.action_get_events(keybind)
	if events.size() > 0:
		return keybind + ": " + events[0].as_text()
	return keybind + ": (unbound)"
# returns the keybind name and what key they are binding it too


func _on_bind_button_pressed(keybind: String, button: Button) -> void:
	selecting_keybind = keybind
	selected_keybind = button
	button.text = "Press a key..."
# when a player presses a keybind button, it will listen for the players input


func _input(event: InputEvent) -> void:
	if selecting_keybind == "":
		return
# returns the function if player is binding key already

	if event is InputEventKey and event.is_pressed():
		InputMap.action_erase_events(selecting_keybind)
		InputMap.action_add_event(selecting_keybind, event)
		selected_keybind.text = get_bind_text(selecting_keybind)
		selecting_keybind = ""
		selected_keybind = null
		get_viewport().set_input_as_handled()
# remove the old keybind and replaces it with the new one updating the keybinds and stops listening for player input.


func _back() -> void:
	if is_in_pause_menu:
		visible = false
		get_parent().show_pause_buttons()
# if the options mneu was opened in the pause menu then it will hide and show the pause buttons
	else:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
# when the button is pressed outside the pause menu it will return the player back to the menu


func _on_full_screen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
# if the game is already in full screen then it will set the game to windowed
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
# puts the game into fullscreen


func _on_help_doc_button_pressed() -> void:
	help_doc.visible = true
# when the help button is pressed the help doc becomes visible
