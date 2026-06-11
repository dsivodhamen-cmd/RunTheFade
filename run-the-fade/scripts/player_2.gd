extends CharacterBody2D

var speed = 300
# create a varaible storing the players speed
var jump = -400
# create a varaible storing the players jump
var max_jumps = 5
# create a variable storing the max jumps the player can jump
var jumps_left = 5
# create a varaible storing the ammount of jumps the player has
var p2_health: int = 500
# create a variable storing the players health as an interger 
var p2_posture: int = 50
# create a variable storing the players posture as an interger

@export var light_attack_damage: int = 10
# exporting an variable storing the players light attack damage an an interger
@export var p2_health_ui: ProgressBar
# exporting the Progress bar and making it an varaible for storing health
@export var p2_posture_ui: ProgressBar
# exporting the Progress bar and making it an variable storing posture
@export var p2_hitbox: Area2D
# exporting an area 2d and making the the varaible for the players hitbox


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
	if is_on_floor():
		jumps_left = max_jumps
# if the player is on the floor the player gets the maximum ammount of jumps
		
		if Input.is_action_just_pressed("p2_up"):
			velocity.y = jump
# allows the player to jump when they are on the floor

	if not is_on_floor():
		velocity += get_gravity() * delta
# giving the player gravity making them fall if they are in the air
		
		if Input.is_action_just_pressed("p2_up") and jumps_left > 0:
			velocity.y = jump
			jumps_left -= 1
# allows the player to jump in the air if they have enough jumps left
	
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
	if Input.is_action_just_pressed("p2_light_attack"):
		_light_attack()
# if the player presses the attack button then it will attack

func _light_attack():
	p2_hitbox.monitoring = true
# makes the hitbox turn on when light attacking
	
	for area in p2_hitbox.get_overlapping_areas():
		if area.get_parent() != self:
			area.get_parent().take_damage(light_attack_damage)
# if the area overlaping the hitbox area isnt it self then it will deal damage to it.
	
	await get_tree().create_timer(0.2).timeout
# a timer putting the light attack on cooldown
	
	p2_hitbox.monitoring = false
# turns the hitbox back off


func take_damage(amount): 
	if p2_health > 0:
		p2_health -= amount
		p2_health_ui.value = p2_health
# if the player has health greater than 0 and takes damage it will take damage lowering the HP
	
