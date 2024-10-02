extends RigidBody2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

const PLAYER = preload("res://scenes/player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_explosion():
	animatedSprite.play("explode")
	animatedSprite.connect("animation_finished", _on_explosion_finished)
	
	set_collision_layer(0)
	set_collision_mask(0)
	
	get_node("CollisionShape2D").queue_free()
	
func _on_explosion_finished():
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.damage_taken()
	print("hit")
