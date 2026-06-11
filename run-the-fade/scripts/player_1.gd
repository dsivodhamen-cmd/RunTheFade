extends CharacterBody2D

var speed = 300
# create a varaible storing the players speed
var jump = -400
# create a varaible storing the players jump
var max_jumps = 5
# create a variable storing the max jumps the player can jump
var jumps_left = 5
# create a varaible storing the ammount of jumps the player has
var p1_health: int = 500
# create a varaible storing the players health as an interger
var p1_posture: int = 50
# create a varaible storing the players posture as an interger

@export var light_attack_damage: int = 10
# exporting an variable storing the players light attack damage an an interger
@export var p1_health_ui: ProgressBar
# exporting the progress bar and making it an varaible for storing health
@export var p1_posture_ui: ProgressBar
# exporting the progress bar and making it an variable for storing posture
@export var p1_hitbox: Area2D
# exporting an area 2d and making the the varaible for the players hitbox


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
	if is_on_floor():
		jumps_left = max_jumps
# if the player is on the floor the player gets the maximum ammount of jumps
		
		if Input.is_action_just_pressed("p1_up"):
			velocity.y = jump
# allows the player to jump when they are on the floor

	if not is_on_floor():
		velocity += get_gravity() * delta
# giving the player gravity making them fall if they are in the air
		
		if Input.is_action_just_pressed("p1_up") and jumps_left > 0:
			velocity.y = jump
			jumps_left -= 1
# allows the player to jump in the air if they have enough jumps left
	
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
	if Input.is_action_just_pressed("p1_light_attack"):
		_light_attack()
# if the player presses the attack button then it will attack


func _light_attack():
	p1_hitbox.monitoring = true
# makes the hitbox turn on when light attacking
	
	for area in p1_hitbox.get_overlapping_areas():
		if area.get_parent() != self:
			area.get_parent().take_damage(light_attack_damage)
# if the area overlaping the hitbox area isnt it self then it will deal damage to it.
	
	await get_tree().create_timer(0.2).timeout
# a timer putting the light attack on cooldown
	
	p1_hitbox.monitoring = false
# turns the hitbox back off


func take_damage(amount): 
	if p1_health > 0:
		p1_health -= amount
		p1_health_ui.value = p1_health
# if the player has health greater than 0 and takes damage it will take damage lowering the HP
	
