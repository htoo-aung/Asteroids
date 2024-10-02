extends RigidBody2D

@onready var shooting_sfx: AudioStreamPlayer2D = $ShootingSFX
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var player_health := 100.0
var rotate_speed := 2000.0
var recoil_force := 80.0
var can_shoot = true
var is_warp = false

func _ready():
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	warp()

func _physics_process(delta: float) -> void:
	get_input(delta)
		
func get_input(delta: float):
	if(Input.is_action_pressed("rotate_left")):
		apply_torque(-rotate_speed)
	elif(Input.is_action_pressed("rotate_right")):
		apply_torque(rotate_speed)
	
	if not is_warp:
		if(Input.is_action_pressed("rotate_left")):
			animatedSprite.play("rotate_left")
		elif(Input.is_action_pressed("rotate_right")):
			animatedSprite.play("rotate_right")
		else:
			animatedSprite.play("idle")
	
	
	if(can_shoot == true and Input.is_action_pressed("shoot")):
		shoot()
			

func shoot():
	const MISSILE = preload("res://scenes/missile.tscn")
	
	var new_missile1 = MISSILE.instantiate()
	var new_missile2 = MISSILE.instantiate()
	
	# Handle missile firing
	new_missile1.global_position = %ShootingPoint1.global_position
	new_missile1.global_rotation = global_rotation
	new_missile2.global_position = %ShootingPoint2.global_position
	new_missile2.global_rotation = global_rotation
	
	# Missiles do not stick to ship's rotation
	get_tree().current_scene.add_child(new_missile1)
	get_tree().current_scene.add_child(new_missile2)
	
	start_cooldown()
	animatedSprite.play("shoot")
	shooting_sfx.play()
	
	apply_central_impulse(Vector2.DOWN.rotated(rotation) * recoil_force)

func start_cooldown():
	can_shoot = false
	timer.start(1.0)

func _on_timer_timeout():
	can_shoot = true
	
func warp():
	var prev_pos = position
	var screen_bounds : Vector2 = get_viewport_rect().size / 2.0
	var new_pos = position
	
	if new_pos.x != wrapf(new_pos.x, -screen_bounds.x, screen_bounds.x):
		start_warp_animation()
	if new_pos.y != wrapf(new_pos.y, -screen_bounds.y, screen_bounds.y):
		start_warp_animation()
	
	new_pos.x = wrapf(new_pos.x, -screen_bounds.x, screen_bounds.x)
	new_pos.y = wrapf(new_pos.y, -screen_bounds.y, screen_bounds.y)
	position = new_pos

func start_warp_animation():
	if not is_warp:
		is_warp = true
		animatedSprite.play("warp")
		animatedSprite.connect("animation_finished", _on_warp_finished)

func _on_warp_finished():
	is_warp = false
	animatedSprite.disconnect("animation_finished", _on_warp_finished)

func damage_taken():
	player_health -= 20
	animatedSprite.play("damaged")
	print(player_health)
	
func death():
	animatedSprite.play("death")
