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
var p2_max_posture: int = 50
# creates a varabiel storing the max ammount of parry
var is_parrying = false
# create a varaible storing the players parrying, make it where they arent parrying
var is_blocking = false
# create a varaible storing the players blocking, make it where they arent blocking
var parry_window = 0.2
# create a varabile storing the window where the player can parry attacks.


@export var light_attack_damage: int = 10
# exporting an variable storing the players light attack damage an an interger
@export var heavy_attack_damage: int = 50
# exporting an varaible storing the players heavy attack damage as an interger
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
	p2_hitbox.monitoring = true
# makes the p2_hitbox area always stay on


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
	if Input.is_action_just_pressed("p2_block"):
		start_parry()
# if the player presses the block button then it will start the parry window.
	
	if Input.is_action_pressed("p2_block") and !is_parrying:
		is_blocking = true
# if the player holds the block button and misses the parry window then they will block.
	
	else:
		is_blocking = false
# if the player lets go or doesnt press block then they will remain unblocking
	
	if Input.is_action_just_pressed("p2_light_attack"):
		light_attack()
# if the player presses the light attack button then it will light attack
	if Input.is_action_just_pressed("p2_heavy_attack"):
		heavy_attack()
# if the player presses the heavy attack button then it will heavy attack

func light_attack():
	if Input.is_action_pressed("p2_down"):
# if the player is holding down when they attack then it will down light
		print("Down L attack")
		
	elif Input.is_action_pressed("p2_left") or Input.is_action_pressed("p2_right"):
# if the play is holding right or left when they attack it will side light
		print("Side L attack")
		
	else:
		print("Up L attack")
# if the player is not holding anything when they attack then it will Up attack
		
	for area in p2_hitbox.get_overlapping_areas():
# a for loop going through all areas inside of p2_hitbox
		if area.get_parent() != self:
			area.get_parent().take_damage(light_attack_damage)
# if there is an area that isnt the p2_hitbox then it will take damage

func heavy_attack():
	if Input.is_action_pressed("p2_down"):
# if the player is holding down when they attack then it will down heavy
		print("Down H attack")
		
	elif Input.is_action_pressed("p2_left") or Input.is_action_pressed("p2_right"):
# if the play is holding right or left when they attack it will side heavy
		print("Side H attack")
		
	else:
		print("Up H attack")
# if the player is not holding anything when they attack then it will Up heavy
		
	for area in p2_hitbox.get_overlapping_areas():
# a for loop going through all areas inside of p2_hitbox
		if area.get_parent() != self:
			area.get_parent().take_damage(heavy_attack_damage)
# if there is an area that isnt the p2_hitbox then it will take damage


func start_parry():
	is_parrying = true
# when the player presses the block button then it will turn on parry
	
	await get_tree().create_timer(parry_window).timeout
	is_parrying = false
# once the parry window closes, the player will no longer be able to parry

func take_damage(amount): 
	if is_parrying:
	
		is_parrying = false
# if player lands a parry then it will turn off
		
		p2_posture += 15 
		p2_posture_ui.value = p2_posture
# when the player lands a parry they will gain 15 posture.
		
		print("parry")
		
		return
# returns the function allowing the player to parry again immediately
	
	
	if is_blocking:
		
		p2_posture -= amount
		p2_posture_ui.value = p2_posture
# if the player is blocking, damage gets converted into posture damage and makes the player lose posture
		
		print("blocked")

		if p2_posture <= 0: 
			posture_break()
		
		return
# allows the player to block damage again imediatly
	
	if p2_health > 0:
		p2_health -= amount
		p2_health_ui.value = p2_health
# if the player has health greater than 0 and takes damage it will take damage lowering the HPP


func posture_break():
	
	print("posture broken")
	
	is_blocking = false
# if the players posture breaks they will stop blocking
	
	await get_tree().create_timer(2.0).timeout
# makes the player unable to block for 2 seconds when they get block broken
	
	p2_posture = p2_max_posture
	p2_posture_ui.value = p2_posture
# once the players block gets broken, their posture bar will rest back to the max
