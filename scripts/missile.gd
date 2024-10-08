extends Area2D

@onready var explosion_sfx: AudioStreamPlayer2D = $ExplosionSFX
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

var distance_travelled = 0
var is_exploding = false

signal score_added

func _physics_process(delta: float) -> void:
	const SPEED = 300.0
	const RANGE = 500.0
	
	if(not is_exploding):
		var direction = Vector2.UP.rotated(rotation)
		position += SPEED * direction * delta
		distance_travelled += SPEED * delta
	
		# Remove object if it travels too long without collision
		if (distance_travelled > RANGE):
			start_explosion()
		else:
			animatedSprite.play("shoot")

func start_explosion():
	is_exploding = true
	animatedSprite.play("explode")
	explosion_sfx.play()
	if not animatedSprite.is_connected("animation_finished", _on_explosion_finished):
		animatedSprite.connect("animation_finished", _on_explosion_finished)
	
func _on_body_entered(body: Node2D) -> void:
	emit_signal("score_added")
	body.start_explosion()
	start_explosion()
	
func _on_explosion_finished():
	queue_free()
