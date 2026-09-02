extends Control


func _continue() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
# when the user presses the continue button they will be returned to to main menuu
