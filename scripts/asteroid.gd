extends RigidBody2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var asteroidSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var asteroidCollisionShape: CollisionShape2D = $CollisionShape2D
@onready var damageCollisionShape: CollisionShape2D = $Area2D/CollisionShape2D

var lifetime := 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand_size = randi_range(1, 3)
	var new_scale = Vector2(rand_size, rand_size)
	
	asteroidSprite.scale = new_scale
	asteroidCollisionShape.scale = new_scale
	damageCollisionShape.scale = new_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var rand_rotate_speed = randf_range(500.0, 1000.0)
	apply_torque(rand_rotate_speed)
	
	

func start_explosion():
	animatedSprite.play("explode")
	animatedSprite.connect("animation_finished", _on_explosion_finished)
	
	set_collision_layer(0)
	set_collision_mask(0)
	
	$Area2D.set_collision_layer(0)
	$Area2D.set_collision_mask(0)
	
	get_node("CollisionShape2D").queue_free()
	get_node("Area2D/CollisionShape2D").queue_free()
	
func _on_explosion_finished():
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.is_damaged = true
	body.damage_taken()
	print("hit")
	
func start_lifetime():
	pass

func despawn():
	queue_free()
	print("despawned")
