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
@export var heavy_attack_damage: int = 50
# exporting an varabile storing the players heavy attack damage as an interger
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
	p1_hitbox.monitoring = true
# makes p1_hitbox stay on all the time.

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
		light_attack()
# if the player presses the light attack button then they will light attack
	elif Input.is_action_just_pressed("p1_heavy_attack"):
		heavy_attack()
# if the player presses the heavy attack button then they will heavy attack


func light_attack():
	if Input.is_action_pressed("p1_down"):
# if the player is holding down when they attack then it will down light
		print("Down L attack")
		
	elif Input.is_action_pressed("p1_left") or Input.is_action_pressed("p1_right"):
# if the play is holding right or left when they attack it will side light
		print("Side L attack")
		
	else:
		print("Up L attack")
# if the player is not holding anything when they attack then it will Up attack
		
	for area in p1_hitbox.get_overlapping_areas():
# a dictionary checking for all areas inside of p1_hitbox
		if area.get_parent() != self:
			area.get_parent().take_damage(light_attack_damage)
# if there is an area that isnt the p1_hitbox then it will take damage


func heavy_attack():
	if Input.is_action_pressed("p1_down"):
# if the player is holding down when they attack then it will down heavy
		print("Down H attack")
		
	elif Input.is_action_pressed("p1_left") or Input.is_action_pressed("p1_right"):
# if the play is holding right or left when they attack it will side heavy
		print("Side H attack")
		
	else:
		print("Up H attack")
# if the player is not holding anything when they attack then it will Up heavy
		
	for area in p1_hitbox.get_overlapping_areas():
# a dictionary checking for all areas inside of p1_hitbox
		if area.get_parent() != self:
			area.get_parent().take_damage(heavy_attack_damage)
# if there is an area that isnt the p1_hitbox then it will take damage


func take_damage(amount): 
	if p1_health > 0:
		p1_health -= amount
		p1_health_ui.value = p1_health
# if the player has health greater than 0 and takes damage it will take damage lowering the HPP
	
