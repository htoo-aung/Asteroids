extends CharacterBody2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var player_health := 100.0
var rotate_speed := 5.0
var recoil_speed := 50.0
var can_shoot = true

func _ready():
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)

func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()
	
func get_input(delta: float):
	if(Input.is_anything_pressed() == false):
		animatedSprite.play("idle")
	
	if(Input.is_action_pressed("rotate_left")):
		self.rotation -= rotate_speed * delta
		animatedSprite.play("rotate_left")
		
	if(Input.is_action_pressed("rotate_right")):
		self.rotation += rotate_speed * delta
		animatedSprite.play("rotate_right")
		
	if(can_shoot == true):
		if(Input.is_action_pressed("shoot")):
			shoot(delta)
			

func shoot(delta: float):
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
	

func recoil_movement(delta: float):
	var recoil_direction = Vector2.DOWN.rotated(rotation)
	position += recoil_direction * recoil_speed * delta
	

func start_cooldown():
	can_shoot = false
	timer.start(1.0)

func _on_timer_timeout():
	can_shoot = true
