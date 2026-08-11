extends Control


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
# the function for pausing the game, setting pause to true and showing the pause menuu


func resume_game():
	hide()
	get_tree().paused = false
# the function for resmuming the game, setting the pause to false and hiding the pause menuu


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	resume_game()
# when the resume button is press the game will resume


func _on_options_button_pressed() -> void:
	pass


func _on_back_to_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
# changes the scene to the main menu and unpauses when the back to menu button is pressed
