extends Control

const STAT_RESET = 0
# Constant storing the value for the stat reset


@onready var resume_button = $"Resume button"
@onready var options_button = $"Options button"
@onready var back_to_menu_button = $"Back to Menu button"
@onready var options_menu = $OptionsMenu
# Instacning the buttons and options menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
# Keeps the menu working even while game is paused


func _input(event):
	if event.is_action_pressed("Pause"):
		toggle_pause()
# When the pause button is pressed it will activate the toggle_pause function


func toggle_pause():
	if get_tree().paused:
		resume_game()
	else:
		pause_game()
# If the game is already paused then it will resume, otherwise it will pause the game


func pause_game():
	show()
	get_tree().paused = true
# The function for pausing the game, setting pause to true and showing the pause menuu


func resume_game():
	hide()
	get_tree().paused = false
	show_pause_buttons()
# The function for resmuming the game, setting the pause to false and hiding the pause menuu


func show_pause_buttons():
	resume_button.visible = true
	options_button.visible = true
	back_to_menu_button.visible = true
	options_menu.visible = false
# Shows the 3 pause buttons and hides options mneu


func _on_resume_button_pressed() -> void:
	resume_game()
# When the resume button is press the game will resume


func _on_options_button_pressed() -> void:
	resume_button.visible = false
	options_button.visible = false
	back_to_menu_button.visible = false
	options_menu.visible = true
# Hides the 3 pause buttons and shows the options menu when the options button is pressed


func _on_back_to_menu_button_pressed() -> void:
	get_tree().paused = false
	for player in GameStats.stats:
		for stat in GameStats.stats[player]:
			GameStats.stats[player][stat] = STAT_RESET
# A for loop going through each player and stat in the GameStats and reseting them back to 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
# Changes the scene to the main menu and unpauses when the back to menu button is pressed
