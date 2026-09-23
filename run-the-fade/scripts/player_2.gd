extends CharacterBody2D

var jumps_left = 5
# Create a varaible storing the ammount of jumps the player has
var p2_health: int = 500
# Create a varaible storing the players health as an interger
var p2_posture: int = 50
# Create a varaible storing the players posture as an interger
var is_parrying = false
# Create a varaible storing the players parrying, make it where they arent parrying
var is_blocking = false
# Create a varaible storing the players blocking, make it where they arent blocking
var is_attacking = false
# Creates a variable storing the players atack, make it where they arent attacking
var is_stunned = false
# Creates a variable storing the players stun, makes it where player isnt stunned.
var lifes: int = 3
# Creates a vrabile storing the players lives as in interger.
var is_dead = false
# Creates a varaible storing whether the player is dead, makes it where the player isnt dead
var is_dashing = false
# Creates a varaible storing the players dash, makes it where the player isnt dashing

const SPEED = 300
# Create a constant storing the players speed
const JUMP = -400
# Create a constant storing the players jump
const MAX_JUMPS = 5
# Create a constant storing the max jumps the player can jump
const MINUS_JUMPS = 1
# Creates a constant storing the value the player losses when they jump
const NO_JUMPS = 0
# Creats a constant storing the value the player has when they have no jumps
const P2_MAX_HEALTH: int = 500
# Creates a constant storing the players maxium health as an interger
const P2_MAX_POSTURE: int = 50
# Creates a constant storing the max ammount of parry
const PARRY_WINDOW = 0.2
# Create a constant storing the window where the player can parry attacks.
const DASH = 500
# Create a constant storing the players dash
const DASH_COOLDOWN = 0.2
# Creates a constant storing the players dash cooldown
const DASH_DISTANCE = 0.2
# Creates a constant storing the players dash distance
const HEAVY_ATTACK_DELAY = 0.25
# Creates a constant storing the players heavy attack delay
const POSTURE_GAIN = 10
# Creates a constant storing the players posture gain when landing a parry
const ADD_STAT = 1
# Creates a constant storing the value that players stat increases by
const DEATH_TIME = 3
# Creates a constant storing the time that the player remains dead
const DEATH_HP = 0
# Creates a constant storing the hp of the player when they are dead
const BROKEN_POSTURE_AMOUNT = 0
# Creates a constant storing the posture of the player when their posture is broken
const MINUS_LIVES = 1
# Creats a constant storing the value the player losses when the lose a live
const NO_LIVES = 0
# Creates a constant storing the value the player has when they have no lives

@export var player_id: String = "p2"
# Exporting an varaible storing the players ID and making it a string (used to refer stats)
@export var animation: AnimationPlayer
# Exporting an varaible storing all the animations for player 2
@export var light_attack_damage: int = 10
# Exporting an variable storing the players light attack damage an an interger
@export var heavy_attack_damage: int = 50
# Exporting an varabile storing the players heavy attack damage as an interger
@export var light_down_knockback = 400
# Exporting an varaible storing the players light down knockback
@export var light_side_knockback = 400
# Exporting an varaible storing the players light side knockback
@export var light_up_knockback = 400
# Exporting an varaible storing the players light up knockback
@export var heavy_down_knockback = 800
# Exporting an varaible storing the players heavy down knockback
@export var heavy_side_knockback = 800
# Exporting an variable storing the players heavy side knockback
@export var heavy_up_knockback = 800
# Eporting an varaible storing the players heavy up knockback
@export var light_attack_stun = 0.2
# Exporting an varaible storing the light attack stun
@export var heavy_attack_stun = 0.5
# Exporting an variable storing the heavy attack stun
@export var parry_stun = 0.5
# Exporting an varaible storing the parry stun
@export var posture_break_stun = 1
# Exporting an varaible storing the posture break stun
@export var p2_health_ui: ProgressBar
# Exporting the progress bar and making it an varaible for storing health
@export var p2_posture_ui: ProgressBar
# Exporting the progress bar and making it an variable for storing posture
@export var p2_hitbox: Area2D
# Exporting an area 2d and making the the varaible for the players hitbox
@onready var sprite_2d: Sprite2D = $Sprite2D
# Brings the sprite 2d into the code allowing for it to be referenced (will be used to flip sprite)
@export var p2_lifes_ui: Label
# Exporting the label and making it an varaible for storing lifes


func _ready() -> void:
	p2_health_ui.max_value = p2_health
# Changes the max value of the Progress bar to the p2_health ammount
	p2_health_ui.value = p2_health
# Changes the value of the Progress bar to the p2_health ammount
	p2_posture_ui.max_value = p2_posture
# Changes the max value of the Progress bar to the p2_posture ammount
	p2_posture_ui.value = p2_posture
# Changes the value of the Progress bar to the p2_posture ammount
	p2_lifes_ui.text = str(lifes)
# Changes the value of the label to the lifes ammount as a string
	p2_hitbox.monitoring = true
# Makes p2_hitbox stay on all the time.


func _physics_process(delta: float) -> void:
	
	var direction = Input.get_axis("p2_left", "p2_right")
# A varabile storing the direction of where the player travels

	if is_attacking:
		move_and_slide()
		return
# If the player is attacking then this will prevent the player from moving
	
	if is_parrying:
		move_and_slide()
		return
# If the player is parrying then this will prevent the player from moving
	
	if is_stunned:
		velocity += get_gravity() * delta
		move_and_slide()
		return
# If the player is stunned then this will prevent the player from moving and lets them fall if in air

	if is_dead:
		velocity += get_gravity() * delta
		move_and_slide()
		return
# If the player is dead then this will prevent the player from moving and lets thm fall if in air

	if is_dashing:
		move_and_slide()
		animation.play("Dash")
		return
# If the player is dashing then this will prevent the player from moving and plays the dashing animation


	if direction > 0:
		sprite_2d.flip_h = false
# If the player is moving to the right then the sprite will not flip
	elif direction < 0:
		sprite_2d.flip_h = true
# If the player is moving to the left then the sprite will flip facing the right direction.

	if Input.is_action_just_pressed("p2_dash"):
		start_dash(direction)
# if the player presses the dash button then they will dash

	if direction: 
		velocity.x = lerp(velocity.x, direction * SPEED, DASH_DISTANCE)
		
# Allows the player to move in the direction they are holding
		if is_on_floor():
			animation.play("walking")
# Plays the walking animation if the player is moving while on the floor
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
# If the player lets go they will stop moving
		if is_on_floor():
			animation.play("idle")
# Plays the idle animation if the player isnt moving while on the floor.
	
	if is_on_floor():
		jumps_left = MAX_JUMPS
# If the player is on the floor the player gets the maximum ammount of jumps
		
		if Input.is_action_just_pressed("p2_up"):
			velocity.y = JUMP
			animation.play("jumping")
			jumps_left -= MINUS_JUMPS
# Allows the player to jump when they are on the floor and plays the jumping animation

	if not is_on_floor():
		velocity += get_gravity() * delta
# Aiving the player gravity making them fall if they are in the air
		if velocity.y > 0:
			animation.play("falling")
# If the player is falling (negative y) then the falling animation will play

		if Input.is_action_just_pressed("p2_up") and jumps_left > NO_JUMPS:
			velocity.y = JUMP
			animation.play("jumping")
			jumps_left -= MINUS_JUMPS
# Allows the player to jump in the air if they have enough jumps left and plays the jumping animation

	move_and_slide()
# Makes the player move


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if is_stunned:
		return 
# Returns the function if the players is stunned

	if is_dead:
		return
# Returns the function if the player is dead


	if Input.is_action_just_pressed("p2_block"):
		start_parry()
# If the player presses the block button then it will start the parry window.
	
	if Input.is_action_pressed("p2_block") and not is_parrying:
		is_blocking = true
		animation.play("Block")
# If the player holds the block button and misses the parry window then they will block.
	
	else:
		is_blocking = false
# If the player lets go or doesnt press block then they will remain unblocking


	if Input.is_action_just_pressed("p2_light_attack"):
		light_attack()
# If the player presses the light attack button then they will light attack
	elif Input.is_action_just_pressed("p2_heavy_attack"):
		heavy_attack()
# If the player presses the heavy attack button then they will heavy attack
 

func start_dash(direction):

	if is_attacking:
		return
# Returns the function if the player is attacking

	if is_blocking:
		return
# Returns the function if the player is blocking

	if is_parrying:
		return
# Returns the function if the player is parrying

	if is_stunned:
		return
# Returns the function if the player is stunned

	if is_dashing:
		return
# Returns the function if the player is already dashing

	is_dashing = true
# Sets dashing to true and plays the dash animation

	if direction != 0:
		velocity.x = direction * DASH
# If the player is not stationary then they will dash the direction they are moving

	else:
		if sprite_2d.flip_h:
			velocity.x = -DASH
		else: 
			velocity.x = DASH
# If the player is stationary then they will dash the direction they are facing

	await get_tree().create_timer(DASH_COOLDOWN).timeout
	is_dashing = false
# After 0.2 seconds dashing will be set to false


func light_attack():

	if is_attacking:
		return
# Returns the function if the player is attacking

	if is_blocking:
		return
# Returns the function if the player is blocking


	is_attacking = true 
# Sets attacking to true

	var knockback = Vector2.ZERO
# Creates a varible in the light attack function storing knockback

	if Input.is_action_pressed("p2_down"):
# If the player is holding down when they attack then it will down light
		animation.play("Light down attack")
# Plays the down light attack animation
		knockback = Vector2(0, light_down_knockback)
# Changes the knockback varabile value to the light_down_knockback ammount

	elif Input.is_action_pressed("p2_left") or Input.is_action_pressed("p2_right"):
# If the play is holding right or left when they attack it will side light
		animation.play("Light side attack")
# Plays the side light attack animation
		if sprite_2d.flip_h:
			knockback = Vector2(-light_side_knockback, 0)
		else:
			knockback = Vector2(light_side_knockback, 0)
# Depending on the direction the player is facing will apply knockback in that direction.

	else:
		animation.play("Light up attack")
# If the player is not holding anything when they attack then it will Up attack	
		knockback = Vector2(0, -light_up_knockback)
# Changes the knockback varaible value to the light_up_knockback ammount

	for area in p2_hitbox.get_overlapping_areas():
# A for loop going through for all areas inside of p2_hitbox
		if area.get_parent() != self:
			area.get_parent().take_damage(light_attack_damage, knockback, light_attack_stun, self)
# If there is an area that isnt the p2_hitbox then it will take damage, stun and knockback
# Self is used to reference the player
			GameStats.stats[player_id]["Damage_done"] += light_attack_damage
# Adds the light attack damage to the players damage done stat

	await animation.animation_finished 
	is_attacking = false 
# Waits for the animation to end and then makes the player stop attacking


func heavy_attack():
	if is_attacking:
		return
# Returns the function if the player is already attacking
	
	if is_blocking:
		return
# Returns the function if the player is blocking

	is_attacking = true
# Sets attacking to true

	var knockback = Vector2.ZERO
# Creates an variable in the heavy attack function storing knockback

	if Input.is_action_pressed("p2_down"):
# If the player is holding down when they attack then it will down heavy
		animation.play("Heavy down attack")
# Plays the heavy down attack animation
		knockback = Vector2(0, heavy_down_knockback)
# Changes the knockback varaible value to the heavy_down_knockback amount

	elif Input.is_action_pressed("p2_left") or Input.is_action_pressed("p2_right"):
# If the play is holding right or left when they attack it will side heavy
		animation.play("Heavy side attack")
# Plays the heavy side attack animation
		if sprite_2d.flip_h:
			knockback = Vector2(-heavy_side_knockback, 0)
		else:
			knockback = Vector2(heavy_side_knockback, 0)
# Deals knockback depending on the direction the player is facing

	else:
		animation.play("Heavy up attack")
# If the player is not holding anything when they attack then it will Up heavy and play animation
		knockback = Vector2(0, -heavy_up_knockback)
# Changes the knockback variable value to the heavy_up_knockback ammount

	await get_tree().create_timer(HEAVY_ATTACK_DELAY).timeout
# creates a timer of 0.25s before dealing damage and knockback to players

	for area in p2_hitbox.get_overlapping_areas():
# A for loop going through all areas inside of p2_hitbox
		if area.get_parent() != self:
			area.get_parent().take_damage(heavy_attack_damage, knockback, heavy_attack_stun, self)
# If there is an area that isnt the p2_hitbox then it will take damage, knockback, and stun
# Self is used to reference the player
			GameStats.stats[player_id]["Damage_done"] += heavy_attack_damage
# Adds the heavy attack damage to the players damage done stat

	await animation.animation_finished
	is_attacking = false 
# Waits for the animation to end and then makes the player stop attacking


func start_parry():
	is_parrying = true
# When the player presses the block button then it will turn on parry
	animation.play("Parry")
# Plays the parry animation
	
	await get_tree().create_timer(PARRY_WINDOW).timeout
	is_parrying = false
# Once the parry window closes, the player will no longer be able to parry


func take_knockback(force: Vector2):
	velocity = force
# A function creating knockback and making it an Vector2


func take_stun(duration):
	is_stunned = true
# Sets stun to true
	animation.play("stun")
# Plays the stun animation
	await get_tree().create_timer(duration).timeout
	is_stunned = false
# After the duration of stun is finished the player will become unstunned


func take_damage(amount, knockback, stun, attacker): 
# Attacker is used to reference the player to the attacker

	if is_dead:
		return
# Returns the function if the player is already dead

	if is_parrying:
		
		is_parrying = false
# If player lands a parry then it will turn off
		if p2_posture < P2_MAX_POSTURE:
			p2_posture += POSTURE_GAIN 
			p2_posture_ui.value = p2_posture
# If the player has less than the max posture then when the player lands a parry they will gain 15 posture.
		
		attacker.take_stun(parry_stun)
# If the attacker attacks the player while they are parrying then they will take stun
		GameStats.stats[player_id]["Parries"] += ADD_STAT
# Adds 1 to the players Parries stat total

		return
# Returns the function
	
	if is_blocking:
		
		p2_posture -= amount
		p2_posture_ui.value = p2_posture
# If the player is blocking, damage gets converted into posture damage and makes the player lose posture
		GameStats.stats[player_id]["Damage_blocked"] += amount
# Adds the amount to the players Damage blocked stat total


		if p2_posture <= BROKEN_POSTURE_AMOUNT: 
			posture_break()
		
		return
# Allows the player to block damage again imediatly

	is_attacking = false
# If the player is attacking and gets hit, their attack will stop.

	if p2_health > DEATH_HP:
		p2_health -= amount
		p2_health_ui.value = p2_health
# If the player has health greater than 0 and takes damage it will take damage lowering the HP
		GameStats.stats[player_id]["Damage_taken"] += amount
# Adds the amount to the players Damage taken stat total
		take_knockback(knockback)
# The player takes knockback acording to the attack that they were hit with.
		take_stun(stun)
# Makes the player take stun according to the attack that they were hit with

	if p2_health <= DEATH_HP and not is_dead: 
		GameStats.stats[attacker.player_id]["Kills"] += ADD_STAT
# Adds 1 to the attackers players Kills stat total
		death()
# If the players health goes bellow or is 0 they will die


func posture_break():

	is_blocking = false
# If the players posture breaks they will stop blocking

	await take_stun(posture_break_stun)
# If stuns the player for the stun duration.

	p2_posture = P2_MAX_POSTURE
	p2_posture_ui.value = p2_posture
# Once the players block gets broken, their posture bar will rest back to the max


func death():

	if is_dead:
		return
# Returns the function if the player is already dead

	GameStats.stats[player_id]["Deaths"] += ADD_STAT
# Adds 1 to the players Deaths stat total
	is_dead = true
# Makes the player dead
	animation.play("Death")
	await get_tree().create_timer(DEATH_TIME).timeout
# Plays the death animation and waits 3 seconds after the player dies

	lifes -= MINUS_LIVES
	p2_lifes_ui.text = str(lifes)
# Decreases lives by 1 once the player dies and updates the UI value

	if lifes > NO_LIVES:

		p2_health = P2_MAX_HEALTH
		p2_health_ui.value = p2_health
# Resets the players health back to its max value and shows the value on UI if player has enough lifes
		
		p2_posture = P2_MAX_POSTURE
		p2_posture_ui.value = p2_posture
# Resets the players posture back to its max avlue and shows the value on UI if player has enough lifes
		
		is_attacking = false
		is_blocking = false
		is_parrying = false
		is_stunned = false 
		is_dead = false
# Sets all boolean varaibles to false so player isnt attacking, blocking, parrying, stunned and dead.

	else:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/white_victory_screen.tscn")
# If the player doesnt enough lifes then the player has lost and will go to the white player victory screen.
