extends CharacterBody2D

var speed = 300.0
var jump_force = 500.0
var gravity = 30.0

enum state {IDLE, RUN, JUMPUP, JUMPDOWN}

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

var anim_state = state.IDLE

func _physics_process(delta):
	
	update_state()
	update_animation()
	player_movement()
	flip_player()

func player_movement():
	
	if !is_on_floor():
		velocity.y += gravity
	
	handle_jumping()
	
	var direction = Input.get_axis("move_left", "move_right")
	velocity = Vector2(direction * speed, velocity.y)
	move_and_slide()

func handle_jumping():

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force

func update_state():

	if is_on_floor():
		if velocity == Vector2.ZERO:
			anim_state = state.IDLE
		elif velocity.x != 0:
			anim_state = state.RUN
	else:
		if velocity.y < 0:
			anim_state = state.JUMPUP
		else:
			anim_state = state.JUMPDOWN

func update_animation():
	
	match anim_state:
		state.IDLE:
			player_sprite.play("idle")
		state.RUN:
			player_sprite.play("move_side")
		state.JUMPUP:
			player_sprite.play("jump_up")
		state.JUMPDOWN:
			player_sprite.play("jump_down")


func flip_player():
	if velocity.x < 0: 
		player_sprite.flip_h = true
	elif velocity.x > 0:
		player_sprite.flip_h = false
