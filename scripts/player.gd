extends RigidBody2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var player_health := 100.0
var rotate_speed := 1000.0
var recoil_force := 80.0
var can_shoot = true

func _ready():
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	warp()

func _physics_process(delta: float) -> void:
	get_input(delta)
	
func get_input(delta: float):
	if(Input.is_anything_pressed() == false):
		animatedSprite.play("idle")
	
	if(Input.is_action_pressed("rotate_left")):
		apply_torque(-rotate_speed)
		animatedSprite.play("rotate_left")
		
	if(Input.is_action_pressed("rotate_right")):
		apply_torque(rotate_speed)
		animatedSprite.play("rotate_right")
		
	if(can_shoot == true):
		if(Input.is_action_pressed("shoot")):
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
	
	new_pos.x = wrapf(new_pos.x, -screen_bounds.x, screen_bounds.x)
	new_pos.y = wrapf(new_pos.y, -screen_bounds.y, screen_bounds.y)
	position = new_pos
