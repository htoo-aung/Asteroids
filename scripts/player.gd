extends RigidBody2D

@onready var damaged_sfx: AudioStreamPlayer2D = $DamagedSFX
@onready var shooting_sfx: AudioStreamPlayer2D = $ShootingSFX
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var health := 100.0
var rotate_speed := 2000.0
var recoil_force := 80.0
var can_shoot = true
var is_warp = false
var is_damaged = false
var is_game_over = false

func _ready():
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)
	animatedSprite.connect("animation_finished", _on_animation_finished)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	warp()

func _physics_process(delta: float) -> void:
	get_input(delta)
	update_animation()

func update_animation():
	if (is_game_over):
		return
		
	if (is_damaged):
		animatedSprite.play("damaged")
	elif (is_warp):
		animatedSprite.play("warp")
	elif Input.is_action_pressed("rotate_left"):
		animatedSprite.play("rotate_left")
	elif Input.is_action_pressed("rotate_right"):
		animatedSprite.play("rotate_right")
	elif Input.is_action_pressed("shoot"):
		animatedSprite.play("shoot")
	else:
		animatedSprite.play("idle")

func get_input(delta: float):
	if (is_game_over):
		return
		
	if(Input.is_action_pressed("rotate_left")):
		apply_torque(-rotate_speed)
	elif(Input.is_action_pressed("rotate_right")):
		apply_torque(rotate_speed)
	
	if(can_shoot == true and Input.is_action_pressed("shoot")):
		shoot()
		
	if (Input.is_action_pressed("take_damage")):
		take_damage()
			

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
	
	if new_pos.x != wrapf(new_pos.x, -screen_bounds.x, screen_bounds.x) or \
		new_pos.y != wrapf(new_pos.y, -screen_bounds.y, screen_bounds.y):
		start_warp_animation()
	
	new_pos.x = wrapf(new_pos.x, -screen_bounds.x, screen_bounds.x)
	new_pos.y = wrapf(new_pos.y, -screen_bounds.y, screen_bounds.y)
	position = new_pos

func _on_animation_finished():
	var anim_name = animatedSprite.animation
	
	if (anim_name == "warp"):
		is_warp = false
	elif (anim_name == "damaged"):
		is_damaged = false
	elif (anim_name == "shoot"):
		animatedSprite.play("idle")
	elif (anim_name == "death"):
		animatedSprite.stop()
		animatedSprite.frame = animatedSprite.sprite_frames.get_frame_count("death") - 1
		
func start_warp_animation():
	if not is_warp:
		is_warp = true

func _on_warp_finished():
	is_warp = false

func damage_taken():
	health -= 20
	damaged_sfx.play()
	print(health)
	is_damaged = true
	if health <= 0:
		death()

func _on_damaged_finished():
	is_damaged = false
	
func death():
	if not is_game_over:
		is_game_over = true
		animatedSprite.play("death")

func get_health():
	return health
	
func take_damage():
	health -= 20
	
