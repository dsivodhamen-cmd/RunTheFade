extends CharacterBody2D

var speed = 300
# create a varaible storing the players speed
var jump = -400
# create a varaible storing the players jump
var p2_health: int = 500
# create a variable storing the players health as an interger 
var p2_posture: int = 50
# create a variable storing the players posture as an interger

@export var p2_health_ui: ProgressBar
# exporting the Progress bar and making it an varaible for storing health
@export var p2_posture_ui: ProgressBar
# exporting the Progress bar and making it an variable storing posture

func _ready() -> void:
	p2_health_ui.max_value = p2_health
# changes the max value of the Progress bar to the p2_health amount
	p2_health_ui.value = p2_health
# makes the value of the progress bar to the p2_health ammount
	p2_posture_ui.max_value = p2_posture
# makes the max value of the Progress bar to the p2_posture ammount
	p2_posture_ui.value = p2_posture
# makes the value of the Progress bar to the p2_posture ammount

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
# giving the player gravity making them fall if they not on the floor
		if Input.is_action_just_pressed("p2_up"):
			velocity.y = jump
	else:
		if Input.is_action_just_pressed("p2_up"):
			velocity.y = jump
# allows the player to jump while on the floor as well as in the air
	
	var direction = Input.get_axis("p2_left", "p2_right")
# A varabile storing the direction of where the player travels
	if direction: 
		velocity.x = direction * speed
# allows the player to move in the direction they are holding
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
# if the player lets go they will stop moving
	
	move_and_slide()
# makes the player move

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
