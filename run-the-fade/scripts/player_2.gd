extends CharacterBody2D

var speed = 300
# create a varaible storing the players speed
var jump = -400
# create a varaible storing the players jump

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
# giving the player gravity making them fall if they are in the air
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

	


	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
