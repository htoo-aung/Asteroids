extends Area2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

var distance_travelled = 0

func _physics_process(delta: float) -> void:
	const SPEED = 100.0
	const RANGE = 500.0
	var direction = Vector2.UP.rotated(rotation)
	
	position += SPEED * direction * delta
	distance_travelled += SPEED * delta
	
	# Remove object if it travels too long without collision
	if (distance_travelled > RANGE):
		queue_free()
	
	animatedSprite.play("shoot")
