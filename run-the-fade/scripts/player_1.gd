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
var p1_max_posture: int = 50
# creates a varabiel storing the max ammount of parry
var is_parrying = false
# create a varaible storing the players parrying, make it where they arent parrying
var is_blocking = false
# create a varaible storing the players blocking, make it where they arent blocking
var parry_window = 0.2
# create a varabile storing the window where the player can parry attacks.
var is_attacking = false
# creates a variable storing the players atacking, make it where they arent attacking


@export var animation: AnimationPlayer
# exporting an varaible storing all the animations for player 2
@export var light_attack_damage: int = 10
# exporting an variable storing the players light attack damage an an interger
@export var heavy_attack_damage: int = 50
# exporting an varabile storing the players heavy attack damage as an interger
@export var light_down_knockback = 400
# exporting an varaible storing the players light down knockback
@export var light_side_knockback = 1800
# exporting an varaible storing the players light side knockback
@export var light_up_knockback = 400
# exporting an varaible storing the players light up knockback
@export var heavy_down_knockback = 800
# exporting an varaible storing the players heavy down knockback
@export var heavy_side_knockback = 4000
# exporting an variable storing the players heavy side knockback
@export var heavy_up_knockback = 800
#exporting an varaible storing the players heavy up knockback
@export var p1_health_ui: ProgressBar
# exporting the progress bar and making it an varaible for storing health
@export var p1_posture_ui: ProgressBar
# exporting the progress bar and making it an variable for storing posture
@export var p1_hitbox: Area2D
# exporting an area 2d and making the the varaible for the players hitbox
@onready var sprite_2d: Sprite2D = $Sprite2D
# bringst the sprite 2d into the code allowing for it to be referenced (will be used to flip sprite)


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
	var direction = Input.get_axis("p1_left", "p1_right")
# A varabile storing the direction of where the player travels

	if is_attacking:
		move_and_slide()
		return
# If the player is attacking then this will prevent the player from moving
	if is_parrying:
		move_and_slide()
		return
# If the player is parrying then this will prevent the player from moving

	if direction > 0:
		sprite_2d.flip_h = false
# If the player is moving to the right then the sprite will not flip
	elif direction < 0:
		sprite_2d.flip_h = true
# If the player is moving to the left then the sprite will flip facing the right direction.


	if direction: 
		velocity.x = lerp(velocity.x, direction * speed, 0.2)
		
# allows the player to move in the direction they are holding
		if is_on_floor():
			animation.play("walking")
# Plays the walking animation if the player is moving while on the floor
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
# if the player lets go they will stop moving
		if is_on_floor():
			animation.play("idle")
# Plays the idle animation if the player isnt moving while on the floor.
	
	if is_on_floor():
		jumps_left = max_jumps
# if the player is on the floor the player gets the maximum ammount of jumps
		
		if Input.is_action_just_pressed("p1_up"):
			velocity.y = jump
			animation.play("jumping")
			jumps_left -= 1
# allows the player to jump when they are on the floor and plays the jumping animation

	if not is_on_floor():
		velocity += get_gravity() * delta
# giving the player gravity making them fall if they are in the air
		if velocity.y > 0:
			animation.play("falling")
# if the player is falling (negative y) then the falling animation will play
		
		if Input.is_action_just_pressed("p1_up") and jumps_left > 0:
			velocity.y = jump
			animation.play("jumping")
			jumps_left -= 1
# allows the player to jump in the air if they have enough jumps left and plays the jumping animation

	move_and_slide()
# makes the player move


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("p1_block"):
		start_parry()
# if the player presses the block button then it will start the parry window.
	
	if Input.is_action_pressed("p1_block") and !is_parrying:
		is_blocking = true
		animation.play("Block")
# if the player holds the block button and misses the parry window then they will block.
	
	else:
		is_blocking = false
# if the player lets go or doesnt press block then they will remain unblocking


	if Input.is_action_just_pressed("p1_light_attack"):
		light_attack()
# if the player presses the light attack button then they will light attack
	elif Input.is_action_just_pressed("p1_heavy_attack"):
		heavy_attack()
# if the player presses the heavy attack button then they will heavy attack
 

func light_attack():
	if is_attacking:
		return
# returns the function if the player is attacking
	
	is_attacking = true 
# sets attacking to true

	var knockback = Vector2.ZERO
# creates a varible in the light attack function storing knockback

	if Input.is_action_pressed("p1_down"):
# if the player is holding down when they attack then it will down light
		animation.play("Light down attack")
# plays the down light attack animation
		knockback = Vector2(0, light_down_knockback)
# changes the knockback varabile value to the light_down_knockback ammount

	elif Input.is_action_pressed("p1_left") or Input.is_action_pressed("p1_right"):
# if the play is holding right or left when they attack it will side light
		animation.play("Light side attack")
# plays the side light attack animation
		if sprite_2d.flip_h:
			knockback = Vector2(-light_side_knockback, 0)
		else:
			knockback = Vector2(light_side_knockback, 0)
# depending on the direction the player is facing will apply knockback in that direction.

	else:
		animation.play("Light up attack")
# if the player is not holding anything when they attack then it will Up attack	
		knockback = Vector2(0, -light_up_knockback)
# changes the knockback varaible value to the light_up_knockback ammount

	for area in p1_hitbox.get_overlapping_areas():
# a for loop going through for all areas inside of p1_hitbox
		if area.get_parent() != self:
			area.get_parent().take_damage(light_attack_damage, knockback)
# if there is an area that isnt the p1_hitbox then it will take damage
	await animation.animation_finished 
	is_attacking = false 
# waits for the animation to end and then makes the player stop attacking


func heavy_attack():
	if is_attacking:
		return
# returns the function if the player is already attacking
	
	is_attacking = true
# sets attacking to true

	var knockback = Vector2.ZERO
# creates an variable in the heavy attack function storing knockback

	if Input.is_action_pressed("p1_down"):
# if the player is holding down when they attack then it will down heavy
		animation.play("Heavy down attack")
# plays the heavy down attack animation
		knockback = Vector2(0, heavy_down_knockback)
# changes the knockback varaible value to the heavy_down_knockback amount

	elif Input.is_action_pressed("p1_left") or Input.is_action_pressed("p1_right"):
# if the play is holding right or left when they attack it will side heavy
		animation.play("Heavy side attack")
# plays the heavy side attack animation
		if sprite_2d.flip_h:
			knockback = Vector2(-heavy_side_knockback, 0)
		else:
			knockback = Vector2(heavy_side_knockback, 0)
# deals knockback depending on the direction the player is facing

	else:
		animation.play("Heavy up attack")
# if the player is not holding anything when they attack then it will Up heavy and play animation
		knockback = Vector2(0, -heavy_up_knockback)
# changes the knockback variable value to the heavy_up_knockback ammount

	await get_tree().create_timer(0.5).timeout
#creates a timer of 0.5s before dealing damage and knockback to players

	for area in p1_hitbox.get_overlapping_areas():
# a for loop going through all areas inside of p1_hitbox
		if area.get_parent() != self:
			area.get_parent().take_damage(heavy_attack_damage, knockback)
# if there is an area that isnt the p1_hitbox then it will take damage
	await animation.animation_finished
	is_attacking = false 
# waits for the animation to end and then makes the player stop attacking


func start_parry():
	is_parrying = true
# when the player presses the block button then it will turn on parry
	animation.play("Parry")
# plays the parry animation
	
	await get_tree().create_timer(parry_window).timeout
	is_parrying = false
# once the parry window closes, the player will no longer be able to parry

func take_knockback(force: Vector2):
	velocity = force



func take_damage(amount, knockback): 
	if is_parrying:
		
		is_parrying = false
# if player lands a parry then it will turn off
		
		p1_posture += 15 
		p1_posture_ui.value = p1_posture
# when the player lands a parry they will gain 15 posture.
		
		return
# returns the function
	
	
	if is_blocking:
		
		p1_posture -= amount
		p1_posture_ui.value = p1_posture
# if the player is blocking, damage gets converted into posture damage and makes the player lose posture
		
		print("blocked")

		if p1_posture <= 0: 
			posture_break()
		
		return
# allows the player to block damage again imediatly
	
	
	if p1_health > 0:
		p1_health -= amount
		p1_health_ui.value = p1_health
# if the player has health greater than 0 and takes damage it will take damage lowering the HP
		take_knockback(knockback)
# the player takes knockback acording to the attack that they were hit with.

func posture_break():
	
	print("posture broken")
	
	is_blocking = false
# if the players posture breaks they will stop blocking
	
	await get_tree().create_timer(2.0).timeout
# makes the player unable to block for 2 seconds when they get block broken
	
	p1_posture = p1_max_posture
	p1_posture_ui.value = p1_posture
# once the players block gets broken, their posture bar will rest back to the max
