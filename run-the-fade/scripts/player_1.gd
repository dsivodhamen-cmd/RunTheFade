extends CharacterBody2D

var speed = 300
# create a varaible storing the players speed
var jump = -400
# create a varaible storing the players jump
var p1_health: int = 500
# create a varaible storing the players health as an interger
var p1_posture: int = 50
# create a varaible storing the players posture as an interger

@export var p1_health_ui: ProgressBar
# exporting the progress bar and making it an varaible for storing health
@export var p1_posture_ui: ProgressBar
# exporting the progress bar and making it an variable for storing posture

func _ready() -> void:
	p1_health_ui.max_value = p1_health
# changes the max value of the Progress bar to the p1_health ammount
	p1_health_ui.value = p1_health
# cahnges the value of the Progress bar to the p1_health ammount
	p1_posture_ui.max_value = p1_posture
# changes the max value of the Progress bar to the p1_posture ammount
	p1_posture_ui.value = p1_posture
# changes the value of the Progress bar to the p1_posture ammount

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
# giving the player gravity making them fall if they are in the air
		if Input.is_action_just_pressed("p1_up"):
			velocity.y = jump
	else:
		if Input.is_action_just_pressed("p1_up"):
			velocity.y = jump
# allows the player to jump while on the floor as well as in the air
	
	var direction = Input.get_axis("p1_left", "p1_right")
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
